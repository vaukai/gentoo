# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.jboss.jdeparser:jdeparser:${PV}.Final"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Version 2.x of JDeparser, a Java source code generating library"
HOMEPAGE="https://github.com/jdeparser/jdeparser2"
SRC_URI="https://github.com/jdeparser/jdeparser2/archive/${PV}.Final.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/jdeparser2-${PV}.Final"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="virtual/jdk:1.8"
RDEPEND=">=virtual/jre-1.8:*"

JAVA_SRC_DIR="src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="src/test/java"
