# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.apache.logging.log4j:log4j-api:${PV}"

inherit java-pkg-2 java-pkg-simple verify-sig

DESCRIPTION="The Apache Log4j API"
HOMEPAGE="https://logging.apache.org/log4j/2.x/"
SRC_URI="mirror://apache/logging/log4j/${PV}/apache-log4j-${PV}-src.zip
	verify-sig? ( https://downloads.apache.org/logging/log4j/${PV}/apache-log4j-${PV}-src.zip.asc )"
S="${WORKDIR}/log4j-api"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/logging.apache.org.asc"
BDEPEND="
	app-arch/unzip
	verify-sig? ( sec-keys/openpgp-keys-apache-logging )
"

DEPEND="
	dev-java/bnd-annotation:0
	dev-java/error-prone-annotations:0
	dev-java/findbugs-annotations:0
	dev-java/jspecify:0
	dev-java/osgi-annotation:0
	dev-java/osgi-core:0
	>=virtual/jdk-1.8:*
"

RDEPEND=">=virtual/jre-1.8:*"

JAVA_CLASSPATH_EXTRA="
	bnd-annotation
	error-prone-annotations
	findbugs-annotations
	jspecify
	osgi-annotation
	osgi-core
"
JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR="src/main/java"
