# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.threeten:threetenbp:${PV}"
JAVA_TESTING_FRAMEWORKS="testng"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Backport of JSR-310 from JDK 8 to JDK 7 and JDK 6"
HOMEPAGE="https://www.threeten.org/threetenbp/"
SRC_URI="https://github.com/ThreeTen/threetenbp/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}"

LICENSE="BSD" # BSD-3-Clause
SLOT="0"
KEYWORDS="~amd64"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

PATCHES=( "${FILESDIR}/threetenbp-1.7.1-skipFailingTests.patch" )

JAVA_AUTOMATIC_MODULE_NAME="org.threeten.bp"
JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR="src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="testng"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"

src_prepare() {
	default #780585
	java-pkg-2_src_prepare
}
