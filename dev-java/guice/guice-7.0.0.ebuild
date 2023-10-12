# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="com.google.inject:guice:7.0.0"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Guice is a lightweight dependency injection framework for Java 6 and above"
HOMEPAGE="https://github.com/google/guice"
# Currently we bundle the binary version of truth.jar used only for tests, we don't install it.
SRC_URI="https://github.com/google/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	test? (
		https://repo1.maven.org/maven2/com/google/truth/truth/1.1.3/truth-1.1.3.jar
		https://repo1.maven.org/maven2/com/google/truth/extensions/truth-java8-extension/1.1.3/truth-java8-extension-1.1.3.jar
	)"
S="${WORKDIR}/${P}"

LICENSE="Apache-2.0"
SLOT="7"
KEYWORDS="~amd64"

CP_DEPEND="dev-java/guava:0"

DEPEND="${CP_DEPEND}
	dev-java/aopalliance:1
	dev-java/asm:9
	dev-java/jakarta-inject-api:0
	>=virtual/jdk-1.8:*
	test? (
		dev-java/felix-framework:0
		dev-java/guava-testlib:0
		dev-java/jakarta-inject-tck:0
		dev-java/osgi-core:0
	)
"

RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"

DOCS=( {COPYING,{CONTRIBUTING,README}.md} )

PATCHES=(
	"${FILESDIR}/guice-7.0.0-BinderTest.patch"
	"${FILESDIR}/guice-7.0.0-NullableInjectionPointTest.patch"
	"${FILESDIR}/guice-7.0.0-ProvisionExceptionTest.patch"
	"${FILESDIR}/guice-7.0.0-ProviderMethodsTest.patch"
	"${FILESDIR}/guice-7.0.0-LineNumbersTest.patch"
	"${FILESDIR}/guice-7.0.0-ChildBindingAlreadySetErrorTest.patch"
	"${FILESDIR}/guice-7.0.0-GenericErrorTest.patch"
	"${FILESDIR}/guice-7.0.0-missingImplementationErrors.patch"
)

JAVA_AUTOMATIC_MODULE_NAME="com.google.guice"
JAVA_CLASSPATH_EXTRA="aopalliance-1 asm-9 jakarta-inject-api"
JAVA_SRC_DIR="core/src"

src_prepare() {
	java-pkg-2_src_prepare
	default
}

src_test() {
	# line 99, pom.xml
	rm core/test/com/googlecode/guice/OSGiContainerTest.java || die

	JAVA_GENTOO_CLASSPATH_EXTRA="${DISTDIR}/truth-1.1.3.jar"
	JAVA_GENTOO_CLASSPATH_EXTRA+=":${DISTDIR}/truth-java8-extension-1.1.3.jar"
#	JAVA_GENTOO_CLASSPATH_EXTRA+=":testdata.jar"
	# exclude tests not run by mvn test
	JAVA_TEST_EXCLUDES=(
		com.google.inject.AllTests
		com.google.inject.ScopesTest
		com.google.inject.TypeConversionTest
	)
	# exclude test having test failures which should be solved
	JAVA_TEST_EXCLUDES+=(
		com.google.inject.errors.ErrorMessagesTest
		com.google.inject.errors.MissingConstructorErrorTest
		com.google.inject.errors.NullInjectedIntoNonNullableTest
	)
	# line 111, pom.xml
	JAVA_TEST_EXTRA_ARGS=(
		-Dguice_custom_class_loading=ANONYMOUS
		-XX:+UnlockDiagnosticVMOptions
		-XX:+ShowHiddenFrames
	)
	JAVA_TEST_GENTOO_CLASSPATH="
		felix-framework
		guava-testlib
		jakarta-inject-tck
		junit-4
		osgi-core
	"
	JAVA_TEST_RESOURCE_DIRS="core/test"
	JAVA_TEST_SRC_DIR="core/test"
	java-pkg-simple_src_test
}
