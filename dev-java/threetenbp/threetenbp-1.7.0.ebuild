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

# Restricting virtual/jdk because of test failures with higher versions.
# FAILED: test_getText(DayOfWeek, 1, SHORT, pt_BR, "Seg")
# FAILED: test_getText(DayOfWeek, 2, SHORT, pt_BR, "Ter")
# FAILED: test_getText(DayOfWeek, 3, SHORT, pt_BR, "Qua")
# FAILED: test_getText(DayOfWeek, 4, SHORT, pt_BR, "Qui")
# FAILED: test_getText(DayOfWeek, 5, SHORT, pt_BR, "Sex")
# FAILED: test_getText(DayOfWeek, 6, SHORT, pt_BR, "Sáb")
# FAILED: test_getText(DayOfWeek, 7, SHORT, pt_BR, "Dom")
DEPEND="<virtual/jdk-17:*"
RDEPEND=">=virtual/jre-1.8:*"

JAVA_AUTOMATIC_MODULE_NAME="org.threeten.bp"
JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR="src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="testng"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"
