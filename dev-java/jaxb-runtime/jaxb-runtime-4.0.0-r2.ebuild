# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.glassfish.jaxb:jaxb-runtime:4.0.0"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="JAXB (JSR 222) Reference Implementation"
HOMEPAGE="https://eclipse-ee4j.github.io/jaxb-ri/"
SRC_URI="https://github.com/eclipse-ee4j/jaxb-ri/archive/${PV}-RI.tar.gz -> jaxb-ri-${PV}.tar.gz"
S="${WORKDIR}/jaxb-ri-${PV}-RI/jaxb-ri"

LICENSE="EPL-1.0"
SLOT="4"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

DEPEND="
	dev-java/istack-commons-runtime:0
	>=dev-java/fastinfoset-2.1.0-r1:0
	dev-java/jakarta-activation:2
	dev-java/jaxb-api:4
	>=dev-java/jaxb-stax-ex-2.1.0-r1:0
	>=virtual/jdk-11:*
"

# reason: '<>' with anonymous inner classes is not supported in -source 8
#   (use -source 9 or higher to enable '<>' with anonymous inner classes)
RDEPEND=">=virtual/jre-11:*"

DOCS=( ../{CONTRIBUTING,NOTICE,README}.md )

JAVA_CLASSPATH_EXTRA="fastinfoset,jaxb-stax-ex"
JAVA_GENTOO_CLASSPATH_EXTRA=":core.jar:txw-runtime.jar"	# tests need it on classpath
JAVA_JAR_FILENAME="runtime.jar"	# for java-pkg-simple_src_install
JAVA_TEST_GENTOO_CLASSPATH="jaxb-api-4,junit-4"

src_prepare() {
	java-pkg-2_src_prepare

	# fixing the directory structure to allow multi-mode compilation
	mkdir -p source/{com.sun.xml.txw2,org.glassfish.jaxb.core,org.glassfish.jaxb.runtime} || die
	cp -r txw/runtime/src/main/java/* source/com.sun.xml.txw2/ || die
	cp -r core/src/main/java/* source/org.glassfish.jaxb.core || die
	cp -r runtime/impl/src/main/java/* source/org.glassfish.jaxb.runtime || die
}

src_compile() {
	# getting dependencies on the modulepath
	DEPENDENCIES=(
		fastinfoset
		istack-commons-runtime
		jakarta-activation-2
		jaxb-api-4
		jaxb-stax-ex
	)
	local modulepath
	for dependency in ${DEPENDENCIES[@]}; do
		modulepath="${modulepath}:$(java-pkg_getjars --build-only ${dependency})"
	done

	mkdir -p target/classes || die

	# Multi-module compilation, https://openjdk.org/projects/jigsaw/quick-start
	ejavac -d target/classes \
		--module-version ${PV} \
		--module-path "${modulepath}" \
		--module-source-path ./source $(find source -type f -name '*.java') || die

	if use doc; then
		ejavadoc -d target/api \
			--module-path "${modulepath}" \
			--module-source-path ./source $(find source -type f -name '*.java') || die
	fi

	# packaging seems possible only per each module (?)
	jar cf txw-runtime.jar -C target/classes/com.sun.xml.txw2 . || die
	jar cf core.jar -C target/classes/org.glassfish.jaxb.core . || die
	jar cf runtime.jar -C target/classes/org.glassfish.jaxb.runtime . || die

	java-pkg_addres core.jar core/src/main/resources
	java-pkg_addres runtime.jar runtime/impl/src/main/resources
}

src_test() {
	einfo "Testing core"
	JAVA_TEST_SRC_DIR="core/src/test/java"
	JAVA_TEST_RESOURCE_DIRS="core/src/test/resources"
	java-pkg-simple_src_test

	einfo "Testing runtime"
	JAVA_TEST_SRC_DIR="runtime/impl/src/test/java"
	JAVA_TEST_RESOURCE_DIRS=()
	java-pkg-simple_src_test
}

src_install() {
	java-pkg-simple_src_install
	java-pkg_dojar {core,txw-runtime}.jar

	if use source; then
		java-pkg_dosrc "txw/runtime/src/main/java/*"
		java-pkg_dosrc "core/src/main/java/*"
		java-pkg_dosrc "runtime/impl/src/main/java/*"
	fi
}
