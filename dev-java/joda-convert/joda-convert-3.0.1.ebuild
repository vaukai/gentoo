# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# No tests, #839681
JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.joda:joda-convert:${PV}"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Library to convert Objects to and from String"
HOMEPAGE="https://www.joda.org/joda-convert/"
SRC_URI="https://github.com/JodaOrg/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

# jdk-21:* because of pom.xml line 96
DEPEND="
	dev-java/guava:0
	dev-java/threetenbp:0
	>=virtual/jdk-21:*
"

# Cannot use target 1.8 because of:
# src/main/java/org/joda/convert/RenameHandler.java:81: warning: as of release 10, 'var' is a
# restricted type name and cannot be used for type declarations or as the element type of an array
#
# which leads to:
#
# src/main/java/org/joda/convert/RenameHandler.java:81: error: cannot find symbol
#         var instance = create(false);
#         ^
#   symbol:   class var
#   location: class RenameHandler
RDEPEND=">=virtual/jre-10:*"

DOCS=( {NOTICE,RELEASE-NOTES}.txt README.md )

JAVA_CLASSPATH_EXTRA="guava,threetenbp"
JAVA_SRC_DIR="src/main/java"
