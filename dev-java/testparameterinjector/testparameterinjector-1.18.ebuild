# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="com.google.testparameterinjector:test-parameter-injector:${PV}"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="TestParameterInjector For JUnit4"
HOMEPAGE="https://github.com/google/testparameterinjector"
SRC_URI="https://github.com/google/TestParameterInjector/archive//v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/TestParameterInjector-${PV}/junit4"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

CP_DEPEND="
	dev-java/auto-value-annotations:0
	dev-java/guava:0
	dev-java/junit:4
	dev-java/snakeyaml:0
"
# Still missing:
# src/main/java/com/google/testing/junit/testparameterinjector/TestInfo.java:87: error: cannot find symbol
#     return new AutoValue_TestInfo(
#                ^
#   symbol:   class AutoValue_TestInfo
#   location: class TestInfo

DEPEND="
	${CP_DEPEND}
	>=virtual/jdk-1.8:*
"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

JAVA_SRC_DIR="src/main/java"
JAVA_TEST_SRC_DIR="src/test/java"
