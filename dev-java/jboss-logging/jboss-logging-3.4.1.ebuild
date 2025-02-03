# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.jboss.logging:jboss-logging:${PV}.Final"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="The JBoss Logging Framework"
HOMEPAGE="https://github.com/jboss-logging/jboss-logging"
SRC_URI="https://github.com/jboss-logging/jboss-logging/archive/${PV}.Final.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}.Final"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

CP_DEPEND="
	dev-java/jboss-logmanager:0
	dev-java/log4j-12-api:2
	dev-java/log4j-api:2
	dev-java/log4j-core:2
	dev-java/slf4j-api:1
"

DEPEND="
	${CP_DEPEND}
	>=virtual/jdk-1.8:*
"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

JAVA_SRC_DIR="src/main/java"
