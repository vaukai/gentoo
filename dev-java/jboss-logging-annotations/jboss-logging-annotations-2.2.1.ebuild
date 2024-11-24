# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.jboss.logging:jboss-logging-annotations:${PV}.Final"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="JBoss Logging I18n Annotations"
HOMEPAGE="https://github.com/jboss-logging/jboss-logging-tools"
SRC_URI="https://github.com/jboss-logging/jboss-logging-tools/archive/${PV}.Final.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/jboss-logging-tools-${PV}.Final"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

CP_DEPEND="dev-java/jboss-logging:0"

DEPEND="
	${CP_DEPEND}
	>=virtual/jdk-1.8:*
"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

JAVA_SRC_DIR="annotations/src/main/java"
