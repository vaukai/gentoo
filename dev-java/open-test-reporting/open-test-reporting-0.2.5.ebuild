# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Language-agnostic test reporting format and tooling"
HOMEPAGE="https://github.com/ota4j-team/open-test-reporting"
SRC_URI="https://github.com/ota4j-team/open-test-reporting/archive/r${PV}.tar.gz -> ${P}.tar.gz
	https://repo1.maven.org/maven2/org/immutables/value/2.12.0/value-2.12.0.jar"
S="${WORKDIR}/open-test-reporting-r${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64"

DEPEND="
	>=dev-java/apiguardian-api-1.1.2-r1:0
	>=dev-java/gson-2.13.2:0
	>=dev-java/picocli-4.6.3-r1:0
	>=dev-java/slf4j-api-2.0.3:0
	>=virtual/jdk-17:*
"

# error: records are not supported in -source 11
RDEPEND=">=virtual/jre-17:*"

JAVA_CLASSPATH_EXTRA="apiguardian-api gson picocli slf4j-api"
JAVA_GENTOO_CLASSPATH_EXTRA="${DISTDIR}/value-2.12.0.jar"
JAVADOC_CLASSPATH="${JAVA_CLASSPATH_EXTRA}" # immutalbles.value-2.12.0.jar
JAVADOC_SRC_DIRS=( {schema,events,tooling-spi,tooling-core,cli}/src/main/java )
MODULES=( schema events tooling-spi tooling-core cli )

src_compile() {
	local module
	for module in "${MODULES[@]}"; do
		einfo "Compiling ${module}"
		JAVA_JAR_FILENAME="${module}.jar"
	#	JAVA_SRC_DIR=( "${module}"/src/{main,module}/java ) # JAVA_GENTOO_CLASSPATH_EXTRA is not on -module-path
		JAVA_SRC_DIR=( "${module}"/src/main/java )
		java-pkg-simple_src_compile
		JAVA_GENTOO_CLASSPATH_EXTRA+=":${module}.jar"
		rm -r target || die
	done
#	use doc && ejavadoc # does not work
}

src_install() {
	JAVA_JAR_FILENAME="cli.jar"
	java-pkg-simple_src_install
	local module
	for module in schema events tooling-{core,spi}; do
		java-pkg_dojar ${module}.jar
		if use source; then
			java-pkg_dosrc "${module}/src/main/java/*"
		fi
	done
}
