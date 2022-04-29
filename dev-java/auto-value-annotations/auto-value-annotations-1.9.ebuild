# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="com.google.auto.value:auto-value-annotations:1.9"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Immutable value-type code generation for Java 1.7+"
HOMEPAGE="https://github.com/google/auto/tree/master/value"
SRC_URI="https://github.com/google/auto/archive/auto-value-${PV}.tar.gz"
S="${WORKDIR}/auto-auto-value-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

CP_DEPEND="
	dev-java/checker-framework-qual:0
	dev-java/escapevelocity:0
	dev-java/guava:0
	dev-java/incap:0
	dev-java/javapoet:0
"

DEPEND="${CP_DEPEND}
	>=virtual/jdk-1.8:*"

RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"

JAVA_SRC_DIR=(
	"common/src/main/java"
	"service/annotations/src/main/java"
#	"service/processor/src/main/java"
	"value/src/main/java"
)
