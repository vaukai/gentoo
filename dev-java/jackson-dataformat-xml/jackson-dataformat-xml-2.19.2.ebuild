# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="com.fasterxml.jackson.dataformat:jackson-dataformat-xml:2.18.4"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Data format extension for Jackson"
HOMEPAGE="https://github.com/FasterXML/jackson-dataformat-xml"
SRC_URI="https://github.com/FasterXML/${PN}/archive/${P}.tar.gz"
S="${WORKDIR}/${PN}-${P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

CP_DEPEND="
	~dev-java/jackson-annotations-${PV}:0
	~dev-java/jackson-core-${PV}:0
	~dev-java/jackson-databind-${PV}:0
	>=dev-java/stax2-api-4.2.1-r1:0
"

DEPEND="
	${CP_DEPEND}
	>=virtual/jdk-11:*
	test? (
		dev-java/fastdoubleparser:0
		~dev-java/jackson-module-jakarta-xmlbind-${PV}:0
		dev-java/jaxb-api:4
		dev-java/sjsxp:0
		>=dev-java/woodstox-core-7.1.0:0
	)
"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

DOCS=( {README,SECURITY}.md release-notes/{CREDITS,VERSION}-2.x )

JAVA_INTERMEDIATE_JAR_NAME="com.fasterxml.jackson.dataformat.xml"
JAVA_RELEASE_SRC_DIRS=( ["9"]="src/moditect" )
JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="
	fastdoubleparser
	jackson-module-jakarta-xmlbind
	jaxb-api-4
	junit-4
	sjsxp
	woodstox-core
"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"

src_prepare() {
	java-pkg-2_src_prepare

	sed -e 's:@package@:com.fasterxml.jackson.dataformat.xml:g' \
		-e "s:@projectversion@:${PV}:g" \
		-e 's:@projectgroupid@:com.fasterxml.jackson.dataformat:g' \
		-e "s:@projectartifactid@:${PN}:g" \
		"${JAVA_SRC_DIR}/com/fasterxml/jackson/dataformat/xml/PackageVersion.java.in" \
		> "${JAVA_SRC_DIR}/com/fasterxml/jackson/dataformat/xml/PackageVersion.java" || die
}

src_test() {
	local JAVA_TEST_RUN_ONLY=$(find src/test/java -name "*Test*.java" \
		! -path "**/failing**/*.java" \
		! -name "*TestBase.java" -printf '%P\n')

	JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//.java}"
	JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//\//.}"

	local vm_version="$(java-config -g PROVIDES_VERSION)"
	if ver_test "${vm_version}" -ge "17" ; then
		JAVA_TEST_EXTRA_ARGS+=( --add-opens=java.base/java.util=ALL-UNNAMED )
	fi

	java-pkg-simple_src_test
}
