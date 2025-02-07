# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.jboss.logmanager:jboss-logmanager:${PV}.Final"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="An implementation of java.util.logging.LogManager"
HOMEPAGE="https://www.jboss.org/"
SRC_URI="https://github.com/jboss-logging/jboss-logmanager/archive/${PV}.Final.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}.Final"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

CP_DEPEND="
	dev-java/jboss-modules:0
	dev-java/jsonp-api:javax
"

DEPEND="
	${CP_DEPEND}
	>=virtual/jdk-11:*
"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

JAVA_MODULE_NAME="org.jboss.logmanager"

# entry: META-INF/versions/9/org/jboss/logmanager/JBossLoggerFinder.class,
# contains a class with different api from earlier version
JAVA_PACKAGER_ZIP="9"	# so we use app-arch/zip instead of java packager

JAVA_RELEASE_SRC_DIRS=( ["9"]="src/main/java9" )
JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR="src/main/java"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"
