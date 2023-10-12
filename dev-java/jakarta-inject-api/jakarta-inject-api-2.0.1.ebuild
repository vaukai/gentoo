# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="jakarta.inject:jakarta.inject-api:${PV}"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Jakarta Dependency Injection"
HOMEPAGE="https://github.com/jakartaee/inject"
SRC_URI="https://github.com/jakartaee/inject/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/inject-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DOCS=( CONTRIBUTING.md NOTICE.md )

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"
