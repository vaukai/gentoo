# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.slf4j:slf4j-api:${PV}"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="The slf4j API"
HOMEPAGE="https://www.slf4j.org"
SRC_URI="https://github.com/qos-ch/slf4j/archive/v_${PV}.tar.gz -> slf4j-${PV}.tar.gz"
S="${WORKDIR}/slf4j-v_${PV}/${PN}"

LICENSE="MIT"
SLOT="1"
KEYWORDS="~amd64 ~arm64 ~ppc64"

BDEPEND="app-arch/zip"
DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR="src/main/java"

JAVA_TEST_EXCLUDES=(
	# java.lang.InstantiationException - not run by upstream anyway
	"org.slf4j.helpers.MultithreadedInitializationTest"
)

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="src/test/java"

src_prepare() {
	java-pkg-2_src_prepare
	java-pkg_clean
}

src_compile() {
	java-pkg-simple_src_compile

	# remove org/slf4j/impl/ from the jar file
	zip -d ${PN}.jar org/slf4j/impl/\* || die "Failed to remove impl files"
}
