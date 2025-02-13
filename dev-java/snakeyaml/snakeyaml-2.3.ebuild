# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.yaml:snakeyaml:${PV}"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="YAML 1.1 parser and emitter for Java"
HOMEPAGE="https://bitbucket.org/snakeyaml/snakeyaml"
SRC_URI="https://bitbucket.org/${PN}/${PN}/get/${P}.tar.gz"
S="${WORKDIR}/snakeyaml-snakeyaml-01521bc09001"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="~amd64 ~arm64 ~ppc64"

DEPEND="
	>=virtual/jdk-11:*
	test? (
		dev-java/jmh-core:0
		dev-java/joda-time:0
		dev-java/velocity:0
	)
"

RDEPEND=">=virtual/jre-1.8:*"

JAVA_INTERMEDIATE_JAR_NAME="org.yaml.snakeyaml"
JAVA_RELEASE_SRC_DIRS=( ["9"]="src/main/java9" )
JAVA_SRC_DIR="src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="jmh-core,joda-time,junit-4,velocity"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"

src_test() {
	export EnvironmentKey1="EnvironmentValue1"
	export EnvironmentEmpty=""

	# Not packaged org.projectlombok:lombok - https://bugs.gentoo.org/868684
	rm src/test/java/org/yaml/snakeyaml/env/EnvLombokTest.java || die # Tests run: 1
	rm src/test/java/org/yaml/snakeyaml/issues/issue387/YamlExecuteProcessContextTest.java || die # Tests run: 1
	rm src/test/java/org/yaml/snakeyaml/env/ApplicationProperties.java || die # No tests # import lombok.

	pushd src/test/java || die
		local JAVA_TEST_RUN_ONLY=$(find * -name "*Test.java" \
			! -name "AbstractTest.java" \
			! -name "ContextClassLoaderTest.java" \
			! -name "Fuzzer50355Test.java" \
			! -name "PyImportTest.java" \
			)
	popd

	JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//.java}"
	JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//\//.}"

	java-pkg-simple_src_test
}
