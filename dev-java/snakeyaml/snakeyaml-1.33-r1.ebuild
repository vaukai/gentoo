# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.yaml:snakeyaml:1.33"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="YAML 1.1 parser and emitter for Java"
HOMEPAGE="https://bitbucket.org/snakeyaml/snakeyaml"
LV="1.18.30"
SRC_URI="https://bitbucket.org/${PN}/${PN}/get/${P}.tar.gz
	test? ( https://repo.maven.apache.org/maven2/org/projectlombok/lombok/${LV}/lombok-${LV}.jar )"
S="${WORKDIR}/snakeyaml-snakeyaml-7f5106920d77"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm64 ppc64"

DEPEND="
	>=virtual/jdk-1.8:*
	test? (
		dev-java/velocity:0
	)
"

RDEPEND=">=virtual/jre-1.8:*"

JAVA_AUTOMATIC_MODULE_NAME="org.yaml.snakeyaml"
JAVA_SRC_DIR="src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="junit-4,velocity"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"

src_prepare() {
	java-pkg-2_src_prepare

	# JSR-310
	# Since Java 8, the Joda-Time library has been integrated into the JDK as a new package 'java.time'.
	rm -r src/test/java/examples/jodatime || die "jodatime"
}

src_test() {
	export EnvironmentKey1="EnvironmentValue1"
	export EnvironmentEmpty=""


	local vm_version="$(java-config -g PROVIDES_VERSION)"
	if ver_test "${vm_version}" -ge 25; then
		einfo "Removing 2 Tests which won't even compile with Java 25"
		rm src/test/java/org/yaml/snakeyaml/env/EnvLombokTest.java || die "rm EnvLombokTest"
		rm src/test/java/org/yaml/snakeyaml/issues/issue387/YamlExecuteProcessContextTest.java || die "rm Yaml...ContextTest"
		rm src/test/java/org/yaml/snakeyaml/env/ApplicationProperties.java || die "rm ApplicationProperties.java"
	else
		JAVA_GENTOO_CLASSPATH_EXTRA="${DISTDIR}/lombok-${LV}.jar"	# Presently not packaged
	fi

	# https://bugs.gentoo.org/871744
	local JAVA_TEST_RUN_ONLY=$(find src/test/java -name "*Test.java" \
		! -name "StressTest.java" \
		! -name "ParallelTest.java" \
		! -name "AbstractTest.java" \
		! -name "PyImportTest.java" \
		! -name "Fuzzer50355Test.java" \
		! -name "ContextClassLoaderTest.java" -printf "%P\n")

	JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//.java}"
	JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//\//.}"

	java-pkg-simple_src_test
}
