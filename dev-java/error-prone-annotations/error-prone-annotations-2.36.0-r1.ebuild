# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="com.google.errorprone:error_prone_annotations:${PV}"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java annotations for the Error Prone static analysis tool"
HOMEPAGE="https://errorprone.info"
SRC_URI="https://github.com/google/error-prone/archive/v${PV}.tar.gz -> error-prone-${PV}.tar.gz"
S="${WORKDIR}/error-prone-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64"
IUSE="type-annotations"

DEPEND=">=virtual/jdk-11:*"	# module-info
RDEPEND=">=virtual/jre-1.8:*"

src_compile() {
	mkdir annotations/src/main/java9 || die
	mv annotations/src/main/java{,9}/module-info.java || die
	JAVA_JAR_FILENAME="error-prone-annotations.jar"
	JAVA_INTERMEDIATE_JAR_NAME="com.google.errorprone.annotations"
	JAVA_RELEASE_SRC_DIRS=( ["9"]="annotations/src/main/java9" )
	JAVA_SRC_DIR="annotations/src/main/java"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA=":error-prone-annotations.jar"
	rm -r target || die

	JAVA_JAR_FILENAME="error-prone-type-annotations.jar"
	JAVA_SRC_DIR="type_annotations/src/main/java"
	java-pkg-simple_src_compile
	rm -r target || die

	JAVADOC_SRC_DIRS=( {,type_}annotations/src/main/java )
	use doc && ejavadoc
}

src_install() {
	JAVA_JAR_FILENAME="${PN}.jar"
	java-pkg-simple_src_install
	use type-annotations && java-pkg_dojar error-prone-type-annotations.jar
}
