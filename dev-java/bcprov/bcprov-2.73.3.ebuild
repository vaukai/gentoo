# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.bouncycastle:bcprov-lts8on:${PV}"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple cmake check-reqs

DESCRIPTION="Java cryptography APIs"
HOMEPAGE="https://www.bouncycastle.org/lts-java/"
MY_PV="r$(ver_rs 1 'rv' 2 'dot')"
MY_COMMIT="0dc2dedde48813762429472b9ffe9b427d401046"
SRC_URI="https://github.com/bcgit/bc-lts-java/archive/${MY_PV}.tar.gz -> bc-lts-java-${MY_PV}.tar.gz
	test? ( https://github.com/bcgit/bc-test-data/archive/${MY_COMMIT}.tar.gz -> bc-test-data-${MY_COMMIT}.tar.gz )"

S="${WORKDIR}/bc-lts-java-${MY_PV}/native_c"

LICENSE="BSD"
SLOT="2"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

DEPEND=">=virtual/jdk-11:*"
RDEPEND=">=virtual/jre-1.8:*"
BDEPEND="app-arch/zip"

DOCS=( ../{MIGRATION,README}.md )

check_env() {
	if use test; then
		# this is needed only for tests
		CHECKREQS_MEMORY="2048M"
		check-reqs_pkg_pretend
	fi
}

pkg_pretend() {
	check_env
}

pkg_setup() {
	check_env
	java-pkg-2_pkg_setup
}

src_unpack() {
	unpack bc-lts-java-${MY_PV}.tar.gz
	use test && unpack bc-test-data-${MY_COMMIT}.tar.gz
}

src_prepare() {
	cmake_src_prepare
	java-pkg-2_src_prepare
	# TBD: unboundid-ldapsdk should be packaged from source.
	java-pkg_clean ! -path "./libs/unboundid-ldapsdk-6.0.8.jar"

	sed \
		-e '/CMAKE_C_FLAGS "-std=c99"/a set(CMAKE_C_STANDARD 23)' \
		-e '/CMAKE_C_FLAGS "-std=c99"/d' \
		-i CMakeLists.txt || die
}

src_compile() {
	einfo "Compiling bcprov.jar"
	JAVA_RESOURCE_DIRS=(
		"../prov/src/main/resources"
	)
	JAVA_SRC_DIR=(
		"../core/src/main/java"
		"../prov/src/main/java"
		"../prov/src/main/jdk1.9"
	)
	java-pkg-simple_src_compile

	einfo "Generating headers"
	mkdir -p ../core/build/generated/sources/headers/java/main || die
	javac -h ../core/build/generated/sources/headers/java/main \
		-classpath "${JAVA_SRC_DIR}" \
		../core/src/main/java/org/bouncycastle/crypto/NativeFeatures.java \
		../core/src/main/java/org/bouncycastle/crypto/NativeLibIdentity.java \
		../core/src/main/java/org/bouncycastle/crypto/VariantSelector.java \
		../core/src/main/java/org/bouncycastle/crypto/engines/AESNativeEngine.java \
		../core/src/main/java/org/bouncycastle/math/raw/Mul.java \
		|| die

	einfo "Compiling native libraries"
	cmake_src_compile
}

src_test() {
	mv ../../bc-test-data-${MY_COMMIT} bc-test-data || die "cannot move bc-test-data"

	JAVA_TEST_EXTRA_ARGS=(
		-Dbc.test.data.home="${S}"/../core/src/test/data
	)
	# https://github.com/bcgit/bc-lts-java/blob/r2rv73dot3/core/build.gradle#L16
	JAVA_TEST_EXTRA_ARGS+=(
		-Dorg.bouncycastle.bks.enable_v1=true
		-Dtest.bclts.ignore.native=sha,gcm,cbc,ecb,es,cfb,ctr,ccm
		-Dorg.bouncycastle.native.cpu_variant=java
	)
	JAVA_TEST_EXTRA_ARGS+=" -Xmx${CHECKREQS_MEMORY}"
	JAVA_TEST_GENTOO_CLASSPATH="junit-4"

	einfo "Testing \"core\""
	JAVA_TEST_RESOURCE_DIRS="../core/src/test/resources"
	JAVA_TEST_SRC_DIR="../core/src/test/java"
	pushd ../core/src/test/java || die
		local JAVA_TEST_RUN_ONLY=$(find * \
			-name "AllTests.java" )
	popd || die
	JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//.java}"
	JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//\//.}"
	java-pkg-simple_src_test

	einfo "Testing bcprov"
	JAVA_GENTOO_CLASSPATH_EXTRA=":core.jar:libs/unboundid-ldapsdk-6.0.8.jar"
	JAVA_TEST_RESOURCE_DIRS="../prov/src/test/resources"
	JAVA_TEST_SRC_DIR="../prov/src/test/java"
	pushd ../prov/src/test/java || die
		local JAVA_TEST_RUN_ONLY=$(find * \
			-name "AllTests.java" )
	popd || die
	JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//.java}"
	JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//\//.}"
	java-pkg-simple_src_test
}

src_install() {
	java-pkg-simple_src_install
	java-pkg_doso ../native_c_build/libbc-lts-vaesf.so \
		../native_c_build/libbc-lts-vaes.so \
		../native_c_build/libbc-lts-avx.so \
		../native_c_build/libbc-probe.so
}
