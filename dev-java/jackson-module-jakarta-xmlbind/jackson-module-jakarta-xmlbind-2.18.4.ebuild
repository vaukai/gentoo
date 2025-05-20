# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="com.fasterxml.jackson.module:jackson-module-jakarta-xmlbind-annotations:2.18.4"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Support for using Jakarta XML Bind (aka JAXB 3.0) annotations"
HOMEPAGE="https://github.com/FasterXML/jackson-modules-base"
SRC_URI="https://github.com/FasterXML/jackson-modules-base/archive/jackson-modules-base-${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/jackson-modules-base-jackson-modules-base-${PV}/jakarta-xmlbind/"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

CP_DEPEND="
	~dev-java/jackson-annotations-${PV}:0
	~dev-java/jackson-core-${PV}:0
	~dev-java/jackson-databind-${PV}:0
	dev-java/jaxb-api:4
"

DEPEND="
	${CP_DEPEND}
	dev-java/jakarta-activation:1
	>=virtual/jdk-11:*
	test? (
		dev-java/jaxb-runtime:4
	)
"

RDEPEND="
	${CP_DEPEND}
	dev-java/jakarta-activation:2
	>=virtual/jre-1.8:*
"

JAVA_CLASSPATH_EXTRA="jakarta-activation-1"
JAVA_INTERMEDIATE_JAR_NAME="com.fasterxml.jackson.module.jakarta.xmlbind"
JAVA_RELEASE_SRC_DIRS=( ["9"]="src/moditect" )
JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR="src/main/java"

JAVA_TEST_EXCLUDES=(
	# Upstream does not run these
	com.fasterxml.jackson.module.jakarta.xmlbind.failing.TestUnwrapping
	com.fasterxml.jackson.module.jakarta.xmlbind.failing.TestXmlID3
)

JAVA_TEST_GENTOO_CLASSPATH="jaxb-runtime-4 junit-4"
JAVA_TEST_SRC_DIR="src/test/java"

src_prepare() {
	java-pkg-2_src_prepare

	sed -e 's:@package@:com.fasterxml.jackson.module.jakarta.xmlbind:g' \
		-e "s:@projectversion@:${PV}:g" \
		-e 's:@projectgroupid@:com.fasterxml.jackson.module:g' \
		-e "s:@projectartifactid@:jackson-module-jakarta-xmlbind-annotations:g" \
		"${JAVA_SRC_DIR}/com/fasterxml/jackson/module/jakarta/xmlbind/PackageVersion.java.in" \
		> "${JAVA_SRC_DIR}/com/fasterxml/jackson/module/jakarta/xmlbind/PackageVersion.java" || die
}

src_install() {
	java-pkg-simple_src_install
	java-pkg_register-dependency jakarta-activation-2
}
