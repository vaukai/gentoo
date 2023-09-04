# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.testng:testng:${PV}"
JAVA_TESTING_FRAMEWORKS="testng"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Testing framework inspired by JUnit and NUnit with new features"
HOMEPAGE="https://testng.org/"
# Presently we install the binary version of jquery since it is not packaged in ::gentoo.
JQV="3.5.1"
# These test dependencies are not getting installed, only used for tests.
AGV="2.4.21"
GAV="2.4.7"
SCV="1.0-groovy-2.4"
SRC_URI="https://github.com/testng-team/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://repo1.maven.org/maven2/org/webjars/jquery/${JQV}/jquery-${JQV}.jar
	test? (
		https://repo1.maven.org/maven2/org/spockframework/spock-core/${SCV}/spock-core-${SCV}.jar
		https://repo1.maven.org/maven2/org/codehaus/groovy/groovy-all/${GAV}/groovy-all-${GAV}.jar
		https://downloads.apache.org/groovy/${AGV}/distribution/apache-groovy-binary-${AGV}.zip
	)"
S="${WORKDIR}/${P}"

LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
SLOT="0"

BDEPEND="app-arch/unzip"

CP_DEPEND="
	dev-java/ant-core:0
	dev-java/guice:4
	dev-java/jcommander:0
	dev-java/junit:4
	dev-java/jsr305:0
	dev-java/snakeyaml:0
"

DEPEND="${CP_DEPEND}
	>=virtual/jdk-1.8:*
	test? (
		dev-java/ant-testutil:0
		dev-java/assertj-core:3
		dev-java/bsh:0
		dev-java/commons-io:1
		dev-java/guava:0
		dev-java/mockito:4
		dev-java/shrinkwrap-api:0
		dev-java/shrinkwrap-impl-base:0
		dev-java/xmlunit-assertj:2
		dev-java/xmlunit-core:2
	)
"

RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*
"

DOCS=( README.md {ANNOUNCEMENT,CHANGES}.txt )

PATCHES=(
	"${FILESDIR}/testng-7.5.1-BasicTest.patch" # needs ant-testutil and kotlin
	"${FILESDIR}/testng-7.5.1-FailedReporterTest.patch" # java.lang.AssertionError
	"${FILESDIR}/testng-7.5.1-GroovyTest.patch" # Issue2360Sample
	"${FILESDIR}/testng-7.5.1-ParallelTestTest.patch" # java.lang.AssertionError
	"${FILESDIR}/testng-7.5.1-ScriptTest.patch" # No engine found for language: beanshell.
	"${FILESDIR}/testng-7.5.1-XmlSuiteTest.patch" # No engine found for language: beanshell.
	"${FILESDIR}/testng-7.5.1-YamlTest.patch" # java.lang.AssertionError
)

JAVA_AUTOMATIC_MODULE_NAME="org.testng"
JAVA_MAIN_CLASS="org.testng.TestNG"
JAVA_RESOURCE_DIRS="testng-core/src/main/resources"
JAVA_SRC_DIR=(
	testng-ant/src/main/java
	testng-asserts/src/main/java
	testng-collections/src/main/java
	testng-core-api/src/main/java
	testng-core/src/main/java
	testng-reflection-utils/src/main/java
	testng-runner-api/src/main/java
#	testng-test-kit/src/main/java # only used for tests, not included in upstream jar file
)
JAVA_TEST_GENTOO_CLASSPATH="
	ant-testutil
	assertj-core-3
	bsh
	commons-io-1
	mockito-4
	shrinkwrap-api
	shrinkwrap-impl-base
	xmlunit-assertj-2
	xmlunit-core-2
"
JAVA_TEST_RESOURCE_DIRS=(
	testng-core/src/test/resources
	testng-test-osgi/src/test/resources
)
JAVA_TEST_RUN_ONLY="testng-core/src/test/resources/testng.xml"
#	F O R  D E B U G G I N G  O N L Y
#	JAVA_TEST_RUN_ONLY=(
#		test.reports.FailedReporterTest # Total tests run: 8, Passes: 7, Failures: 1, Skips: 0
#		test.groovy.GroovyTest # Total tests run: 5, Passes: 4, Failures: 1, Skips: 0
#		test.thread.ParallelTestTest # Total tests run: 17, Passes: 16, Failures: 1, Skips: 0
#		test.methodselectors.ScriptTest # Total tests run: 2, Passes: 1, Failures: 1, Skips: 0
#		org.testng.xml.XmlSuiteTest # Total tests run: 7, Passes: 5, Failures: 2, Skips: 0
#		test.yaml.YamlTest # Total tests run: 7, Passes: 6, Failures: 1, Skips: 0
#	)
JAVA_TEST_SRC_DIR=(
	testng/src/test/java
	testng-asserts/src/test/java # needs testng-test-kit/src/main/java
	testng-core/src/test/java
	testng-core/src/test/groovy
	testng-test-kit/src/main/java # needed for testng-asserts/src/test
#	testng-test-osgi/src/test/java # package org.ops4j.pax.exam does not exist
)

src_unpack () {
	# do not unpack anything except testng
	unpack "${P}.tar.gz"
}

src_prepare() {
	default # bug #780585
	java-pkg-2_src_prepare
	java-pkg_clean ! -path "./testng-core/src/test/*"
}

src_test() {
	# Some tests in testng-core expect their test resources in src/test/resources
	mkdir -p src/test || die "Cannot create src/test"
	cp -r testng-core/src/test/resources src/test || die "Cannot copy src/test/resources"

	mkdir -p build/resources/test || die "Cannot create build/resources/test"

	# This contains the compiler groovyc
	unzip "${DISTDIR}/apache-groovy-binary-${AGV}.zip"

	JAVA_GENTOO_CLASSPATH_EXTRA=":${DISTDIR}/spock-core-${SCV}.jar"
	local CP="testng-core/src/test/java:testng-asserts/src/test/java"

	# SimpleBaseTest is needed to compile GroovyTest
	ejavac -cp "${CP}:${PN}.jar:$(java-pkg_getjars guava)" \
		testng-core/src/test/java/test/SimpleBaseTest.java || die "Compiling SimpleBaseTest failed"

	# java-pkg-simple.eclass expects generated test classes in this
	# directory and will copy them to target/test-classes
	"groovy-${AGV}/bin/groovyc" \
		-cp "${CP}:${DISTDIR}/spock-core-${SCV}.jar:$(java-pkg_getjars assertj-core-3)" \
		-d generated-test \
		testng-core/src/test/groovy/test/groovy/*.groovy || die "groovy failed to compile"

	JAVA_GENTOO_CLASSPATH_EXTRA+=":${DISTDIR}/jquery-${JQV}.jar"
	JAVA_GENTOO_CLASSPATH_EXTRA+=":${DISTDIR}/groovy-all-${GAV}.jar"
	java-pkg-simple_src_test
}

src_install() {
	java-pkg-simple_src_install

	java-pkg_newjar "${DISTDIR}/jquery-${JQV}.jar" jquery.jar
	java-pkg_regjar "${ED}/usr/share/${PN}/lib/jquery.jar"

	java-pkg_register-ant-task
}
