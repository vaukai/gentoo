# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="testng"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Testing framework inspired by JUnit and NUnit with new features"
HOMEPAGE="https://testng.org/"
# Presently we install the binary version of jquery since it is not packaged in ::gentoo.
JQV="3.7.1"
# Currently we bundle the binary versions of spock-core, groovy-all and apache-groovy-binary.
# These are used only for tests, we don't install them.
SCV="1.0-groovy-2.4"
GAV="2.4.7"
AGV="2.4.21"
SRC_URI="https://github.com/testng-team/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://repo1.maven.org/maven2/org/webjars/jquery/${JQV}/jquery-${JQV}.jar
	test? (
		https://repo1.maven.org/maven2/org/spockframework/spock-core/${SCV}/spock-core-${SCV}.jar
		https://repo1.maven.org/maven2/org/codehaus/groovy/groovy-all/${GAV}/groovy-all-${GAV}.jar
		https://downloads.apache.org/groovy/${AGV}/distribution/apache-groovy-binary-${AGV}.zip
	)"
S="${WORKDIR}/${P}"

LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~arm64 ~ppc64"
SLOT="0"

CP_DEPEND="
	>=dev-java/ant-1.10.15:0
	dev-java/bsh:0
	>=dev-java/guice-7.0.0:0
	>=dev-java/jcommander-1.82:0
	dev-java/junit:4
	dev-java/slf4j-api:0
	>=dev-java/snakeyaml-2.5:2
"

DEPEND="${CP_DEPEND}
	>=virtual/jdk-11:*
	test? (
		>=dev-java/assertj-core-3.27.6:0
		>=dev-java/guava-33.5.0:0
	)"

# reason: '<>' with anonymous inner classes is not supported in -source 8
#   (use -source 9 or higher to enable '<>' with anonymous inner classes)
RDEPEND="${CP_DEPEND}
	>=virtual/jre-11:*"

BDEPEND="app-arch/unzip"

DOCS=( README.md {ANNOUNCEMENT,CHANGES}.txt )

JAVA_AUTOMATIC_MODULE_NAME="org.testng"
JAVA_MAIN_CLASS="org.testng.TestNG"
JAVA_RESOURCE_DIRS="testng-core/src/main/resources"
JAVA_SRC_DIR=(
	testng-asserts/src/main/java
	testng-collections/src/main/java
	testng-core-api/src/main/java
	testng-core/src/main/java
	testng-reflection-utils/src/main/java
	testng-runner-api/src/main/java
#	testng-test-kit/src/main/java # only used for tests, not included in upstream jar file
#	testng-test-osgi/src/test/java # only used for tests, not included in upstream jar file
)

JAVA_TEST_GENTOO_CLASSPATH="assertj-core"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_RUN_ONLY="src/test/resources/testng.xml"
JAVA_TEST_SRC_DIR="src/test/java"

src_prepare() {
	java-pkg-2_src_prepare
	java-pkg_clean ! -path "./testng-core/src/test/*"
}

src_test() {
	# This contains the compiler groovyc
	unzip "${DISTDIR}/apache-groovy-binary-${AGV}.zip"

	JAVA_GENTOO_CLASSPATH_EXTRA=":${DISTDIR}/spock-core-${SCV}.jar"

	ejavac -cp "${JAVA_TEST_SRC_DIR}:${PN}.jar:$(java-pkg_getjars --build-only guava)" \
		src/test/java/test/SimpleBaseTest.java || die

	# java-pkg-simple.eclass expects generated test classes in this
	# directory and will copy them to target/test-classes
	mkdir generated-test || die "cannot create generated-test directory"
	"groovy-${AGV}/bin/groovyc" \
		-cp "${JAVA_TEST_SRC_DIR}:${DISTDIR}/spock-core-${SCV}.jar" \
		-d generated-test \
		src/test/groovy/test/groovy/* || die

	JAVA_GENTOO_CLASSPATH_EXTRA+=":${DISTDIR}/groovy-all-${GAV}.jar"
	JAVA_TEST_EXTRA_ARGS=( -Dtest.resources.dir=src/test/resources )
	java-pkg-simple_src_test
}

src_install() {
	java-pkg-simple_src_install

	java-pkg_newjar "${DISTDIR}/jquery-${JQV}.jar" jquery.jar
	java-pkg_regjar "${ED}/usr/share/${PN}/lib/jquery.jar"

	java-pkg_register-ant-task
}
