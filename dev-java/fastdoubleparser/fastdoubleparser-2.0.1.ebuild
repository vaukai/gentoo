# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID=""
MAVEN_PROVIDES=""
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION=""
HOMEPAGE="https://github.com/wrandelshofer/FastDoubleParser/"
SRC_URI="https://github.com/wrandelshofer/FastDoubleParser/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/FastDoubleParser-${PV}"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"

CP_DEPEND=""

DEPEND="${CP_DEPEND}
	>=virtual/jdk-17:*"

RDEPEND="${CP_DEPEND}
	>=virtual/jre-17:*"

JAVA_SRC_DIR="fastdoubleparser-dev/src/main/java"
