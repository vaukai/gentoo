# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="javax.resource:javax.resource-api:1.7.1"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java EE Connector Architecture API"
HOMEPAGE="https://github.com/javaee/javax.resource"
SRC_URI="https://github.com/javaee/javax.resource/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/javax.resource-${PV}"

LICENSE="CDDL GPL-2-with-classpath-exception"
SLOT="0"
KEYWORDS="~amd64"

CP_DEPEND="dev-java/jta:0"

RDEPEND=">=virtual/jre-1.8:*
	${CP_DEPEND}"
DEPEND=">=virtual/jdk-1.8:*
	${CP_DEPEND}"
