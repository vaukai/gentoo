# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="ru.vyarus:generics-resolver:${PV}"
JAVA_TESTING_FRAMEWORKS="junit-4"
# org.spockframework:spock-core:1.1-groovy-2.4

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java generics runtime resolver"
HOMEPAGE="https://xvik.github.io/generics-resolver/3.0.3/"
SRC_URI="https://github.com/xvik/generics-resolver/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

CP_DEPEND=""

DEPEND="
	${CP_DEPEND}
	>=virtual/jdk-1.8:*
"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

JAVA_SRC_DIR="src/main/java"
