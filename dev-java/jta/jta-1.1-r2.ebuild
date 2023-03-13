# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="The Java Transaction API"
HOMEPAGE="https://www.oracle.com/java/technologies/jta.html"
SRC_URI="https://repo1.maven.org/maven2/javax/transaction/jta/${PV}/jta-${PV}-sources.jar"
S="${WORKDIR}"

LICENSE="sun-bcla-jta"
SLOT=0
KEYWORDS="~amd64"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"
BDEPEND="app-arch/unzip"
