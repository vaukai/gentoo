# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="com.google.escapevelocity:escapevelocity:0.9.1"
# Missing deps: com.google.truth:truth:0.44
# JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A reimplementation of a subset of the Apache Velocity templating system."
HOMEPAGE="https://github.com/google/escapevelocity"
SRC_URI="https://github.com/google/${PN}/archive/${P}.tar.gz"
S="${WORKDIR}/${PN}-${P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

CP_DEPEND="dev-java/guava:0"

# Compile dependencies
# POM: pom.xml
# test? com.google.guava:guava-testlib:23.5-jre -> >=dev-java/guava-testlib-30.1.1:0
# test? com.google.truth:truth:0.44 -> !!!groupId-not-found!!!
# test? junit:junit:4.12 -> >=dev-java/junit-4.13.2:4
# test? org.apache.velocity:velocity:1.7 -> !!!artifactId-not-found!!!

DEPEND="${CP_DEPEND}
	>=virtual/jdk-1.8:*"

RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"

JAVA_SRC_DIR="src/main/java"
