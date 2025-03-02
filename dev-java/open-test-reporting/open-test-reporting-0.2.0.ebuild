# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_PROVIDES="
	org.opentest4j.reporting:open-test-reporting-schema:${PV}
	org.opentest4j.reporting:open-test-reporting-events:${PV}
"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Language-agnostic test reporting format and tooling"
HOMEPAGE="https://github.com/ota4j-team/open-test-reporting"
SRC_URI="https://github.com/ota4j-team/open-test-reporting/archive/r${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/open-test-reporting-r${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64"

DEPEND="
	dev-java/apiguardian-api:0
	>=virtual/jdk-17:*
"

# error: records are not supported in -source 11
RDEPEND=">=virtual/jre-17:*"

JAVA_CLASSPATH_EXTRA="apiguardian-api"

src_compile() {
	einfo ""
	local cp="$(java-pkg_getjars apiguardian-api,gson,picocli,slf4j-api)"

#	local sources=$(find \
#		cli/src/main/java \
#		events/src/main/java \
#		schema/src/main/java \
#		tooling-core/src/main/java \
#		tooling-spi/src/main/java \
#		-name '*.java') || die "gather sources"

	local sources=$(find */src/main/java -name '*.java') || die "gather sources"

	einfo "compile them all"
	ejavac -d target/classes -classpath "${cp}" ${sources[@]}

	use doc && ejavadoc -d target/api -classpath "${cp}" -quiet ${sources[@]}
}

src_install() {
	java-pkg_dojar "open-test-reporting-schema.jar"
	java-pkg-simple_src_install

	if use source; then
		java-pkg_dosrc "schema/src/main/java/*"
		java-pkg_dosrc "events/src/main/java/*"
	fi
}
