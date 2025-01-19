# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="codes.rafael.asmjdkbridge:asm-jdk-bridge:${PV}"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A Bridge to Translate ASM From and to The OpenJDK Class File API"
HOMEPAGE="https://github.com/raphw/asm-jdk-bridge"
SRC_URI="https://github.com/raphw/asm-jdk-bridge/archive/asm-jdk-bridge-parent-${PV}.tar.gz"
S="${WORKDIR}/${PN}-${PN}-parent-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
#	KEYWORDS="~amd64"	# Needs at least Java 24

CP_DEPEND="
	dev-java/asm:0
	dev-java/junit:4
"

DEPEND="
	${CP_DEPEND}
	>=virtual/jdk-24:*
"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-24:*
"

JAVA_INTERMEDIATE_JAR_NAME="codes.rafael.asmjdkbridge"

# Same problem with Jar file created by maven:
# $ jar --validate -f asm-jdk-bridge/target/asm-jdk-bridge-0.0.2.jar
# entry: META-INF/versions/24/codes/rafael/asmjdkbridge/JdkClassWriter.class, contains a class with different api from earlier version
# invalid multi-release jar file asm-jdk-bridge.jar deleted
JAVA_PACKAGER_ZIP="24"	# Here we use app-arch/zip instead of java pacvkager
JAVA_RELEASE_SRC_DIRS=(
	["9"]="asm-jdk-bridge/src/main/java-9"
	["24"]="asm-jdk-bridge/src/main/java-24"
)

JAVA_SRC_DIR="asm-jdk-bridge/src/main/java"
