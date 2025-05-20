# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="com.fasterxml.jackson.core:jackson-databind:2.18.4"
JAVA_TESTING_FRAMEWORKS="junit-jupiter"

inherit java-pkg-2 java-pkg-simple junit5

JMV="0.9.1"
DESCRIPTION="General data-binding functionality for Jackson: works on core streaming API"
HOMEPAGE="https://github.com/FasterXML/jackson-databind"
SRC_URI="https://github.com/FasterXML/${PN}/archive/${P}.tar.gz
	test? ( https://repo1.maven.org/maven2/javax/measure/jsr-275/${JMV}/jsr-275-${JMV}.jar )"
S="${WORKDIR}/${PN}-${P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

# 2 testInetAddress() would fail without network access
PROPERTIES="test_network"
RESTRICT="test"
# RESTRICT="test" #839681

CP_DEPEND="
	~dev-java/jackson-annotations-${PV}:0
	~dev-java/jackson-core-${PV}:0
"

# needs at least jdk-23 due to fastdoubleparser built with class file version 67.0
DEPEND="
	${CP_DEPEND}
	>=virtual/jdk-23:*
	test? (
		dev-java/assertj-core:0
		dev-java/fastdoubleparser:0
		dev-java/guava-testlib:0
		dev-java/jol-core:0
		dev-java/mockito:4
	)
"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

DOCS=( {README,SECURITY}.md release-notes/{CREDITS,VERSION}-2.x )
PATCHES=(
	"${FILESDIR}/jackson-databind-2.18.4-DateSerializationTest.patch"
	"${FILESDIR}/jackson-databind-2.18.4-NoClassDefFoundWorkaroundTest.patch"
	"${FILESDIR}/jackson-databind-2.18.4-LazyIgnoralForNumbers3730Test.patch"
)

JAVA_GENTOO_CLASSPATH_EXTRA=( "${DISTDIR}/jsr-275-${JMV}.jar" )
JAVA_INTERMEDIATE_JAR_NAME="com.fasterxml.jackson.databind"
JAVA_RELEASE_SRC_DIRS=( ["9"]="src/moditect" )
JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR="src/main/java"
JAVA_TEST_EXTRA_ARGS=( -Djdk.attach.allowAttachSelf -Djol.magicFieldOffset=true )
JAVA_TEST_GENTOO_CLASSPATH="assertj-core fastdoubleparser guava-testlib jol-core mockito-4"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"

src_prepare() {
	default #780585
	java-pkg-2_src_prepare

	sed -e 's:@package@:com.fasterxml.jackson.databind.cfg:g' \
		-e "s:@projectversion@:${PV}:g" \
		-e 's:@projectgroupid@:com.fasterxml.jackson.core:g' \
		-e "s:@projectartifactid@:${PN}:g" \
		"${JAVA_SRC_DIR}/com/fasterxml/jackson/databind/cfg/PackageVersion.java.in" \
		> "${JAVA_SRC_DIR}/com/fasterxml/jackson/databind/cfg/PackageVersion.java" || die

	# Test fails with openjdk:25 (also 'mvn clean test' fails)
	# caught: org.opentest4j.AssertionFailedError: Expected an exception with one of substrings
	# ([Security Manager is deprecated]): got one (of type java.lang.UnsupportedOperationException)
	# with message "Setting a Security Manager is not supported"
	rm src/test/java/com/fasterxml/jackson/databind/misc/AccessFixTest.java || die

	# testUsesCorrectClassLoaderWhenThreadClassLoaderIsNotNull()
	# Underlying exception : java.lang.IllegalStateException: Could not invoke proxy:
	# Type not available on current VM: codes.rafael.asmjdkbridge.JdkClassWriter
	rm src/test/java/com/fasterxml/jackson/databind/type/TypeFactoryWithClassLoaderTest.java || die

	local vm_version="$(java-config -g PROVIDES_VERSION)"
	if ver_test "${vm_version}" -ge 17; then
		JAVA_TEST_EXTRA_ARGS+=( --add-opens=java.base/java.{lang,util}=ALL-UNNAMED )
	fi
}
