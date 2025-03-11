# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID=""
MAVEN_PROVIDES=""
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Property-based testing, JUnit-style"
HOMEPAGE="https://github.com/pholser/junit-quickcheck"
SRC_URI="https://github.com/pholser/junit-quickcheck/archive/${P}.tar.gz"
S="${WORKDIR}/junit-quickcheck-${P}"

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
