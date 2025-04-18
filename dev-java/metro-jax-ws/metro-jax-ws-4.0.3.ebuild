# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID=""
MAVEN_PROVIDES=""
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Open source Reference Implementation of JSR-224: Java API for XML Web Services"
HOMEPAGE="https://eclipse-ee4j.github.io/metro-jax-ws/"
SRC_URI="https://github.com/eclipse-ee4j/metro-jax-ws/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}"

LICENSE="BSD"	# SPDX-License-Identifier: BSD-3-Clause
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
