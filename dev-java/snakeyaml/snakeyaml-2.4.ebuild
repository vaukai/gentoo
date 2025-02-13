# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.yaml:snakeyaml:${PV}"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="YAML 1.1 parser and emitter for Java"
HOMEPAGE="https://bitbucket.org/snakeyaml/snakeyaml"
LV="1.18.30"
SRC_URI="https://bitbucket.org/${PN}/${PN}/get/${P}.tar.gz
	test? ( https://repo.maven.apache.org/maven2/org/projectlombok/lombok/${LV}/lombok-${LV}.jar )"
S="${WORKDIR}/snakeyaml-snakeyaml-558c81a48937"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="~amd64"

DEPEND="
	>=virtual/jdk-11:*
	test? (
		dev-java/jackson-core:0
		dev-java/jackson-databind:0
		dev-java/jackson-dataformat-yaml:0
		dev-java/jmh-core:0
		>=dev-java/joda-time-2.14.0:0
		dev-java/velocity:0
	)
"

RDEPEND=">=virtual/jre-1.8:*"

PATCHES=( "${FILESDIR}/snakeyaml-2.4-skipFailingTests.patch" )

JAVA_INTERMEDIATE_JAR_NAME="org.yaml.snakeyaml"
JAVA_RELEASE_SRC_DIRS=( ["9"]="src/main/java9" )
JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="
	jackson-core
	jackson-databind
	jackson-dataformat-yaml
	jmh-core
	joda-time
	junit-4
	velocity
"

JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"

src_prepare() {
	default #780585
	java-pkg-2_src_prepare
}

src_test() {
	export EnvironmentKey1="EnvironmentValue1"
	export EnvironmentEmpty=""

	# src/test/java/org/yaml/snakeyaml/issues/issue1100/JacksonTest.java:59: error: cannot find symbol
	#     return new YAMLMapper(YAMLFactory.builder().loaderOptions(new LoaderOptions()).build())
	#                                                ^
	#   symbol:   method loaderOptions(LoaderOptions)
	#   location: class YAMLFactoryBuilder
	# src/test/java/org/yaml/snakeyaml/issues/issue307/OrderTest.java:97: warning:
	# non-varargs call of varargs method with inexact argument type for last parameter;
	#           invoke = (Integer) method.invoke(annotation, null);
	#                                                        ^
	#   cast to Object for a varargs call
	#   cast to Object[] for a non-varargs call and to suppress this warning
	# Note: Some input files use or override a deprecated API.
	# Note: Recompile with -Xlint:deprecation for details.
	# Note: Some input files use unchecked or unsafe operations.
	# Note: Recompile with -Xlint:unchecked for details.
	# 1 error
	rm src/test/java/org/yaml/snakeyaml/issues/issue1100/JacksonTest.java || die

	local vm_version="$(java-config -g PROVIDES_VERSION)"
	if ver_test "${vm_version}" -ge 25; then
		einfo "Removing 2 Tests which won't even compile with Java 25"
		rm src/test/java/org/yaml/snakeyaml/env/EnvLombokTest.java || die "rm EnvLombokTest"
		rm src/test/java/org/yaml/snakeyaml/issues/issue387/YamlExecuteProcessContextTest.java || die "rm Yaml...ContextTest"
		rm src/test/java/org/yaml/snakeyaml/env/ApplicationProperties.java || die "rm ApplicationProperties.java"
	else
		JAVA_GENTOO_CLASSPATH_EXTRA="${DISTDIR}/lombok-${LV}.jar"	# Presently not packaged
	fi

	local JAVA_TEST_RUN_ONLY=$(find src/test/java -name "*Test.java" \
		! -name "AbstractTest.java" \
		! -name "PyImportTest.java" -printf "%P\n")

	JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//.java}"
	JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//\//.}"

	java-pkg-simple_src_test
}
