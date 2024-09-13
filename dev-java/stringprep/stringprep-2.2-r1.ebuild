# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# tests are wip
JAVA_PKG_IUSE="doc source"
MAVEN_ID="com.ongres.stringprep:stringprep:2.2"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Stringprep (RFC 3454) Java implementation"
HOMEPAGE="https://gitlab.com/ongresinc/stringprep"
SRC_URI="https://github.com/ongres/stringprep/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"

DEPEND=">=virtual/jdk-11:*"	# module-info
RDEPEND=">=virtual/jre-11:*"

JAVA_SRC_DIR=( {name,sasl,string}prep/src/main/java ) # for USE=source

src_prepare() {
	java-pkg-2_src_prepare

	# fixing the directory structure to allow multi-mode compilation
	local module
	for module in nameprep saslprep stringprep; do
		mkdir -p src/com.ongres."${module}"
		cp -r "${module}"/src/main/java{,9}/* src/com.ongres."${module}"/ || die
	done
}

src_compile() {
	mkdir -p target/classes || die
	# Multi-module compilation, https://openjdk.org/projects/jigsaw/quick-start
	ejavac -d target/classes --module-source-path ./src $(find src -type f -name '*.java') -verbose || die

	if use doc; then
		ejavadoc -d target/api --module-source-path ./src $(find src -type f -name '*.java') || die
	fi

	# packaging seems possible only per each module (?)
	for module in nameprep saslprep stringprep; do
		jar cvf "${module}".jar -C target/classes com.ongres."${module}" || die
	done

	java-pkg_addres nameprep.jar nameprep/src/main/resources
	java-pkg_addres saslprep.jar saslprep/src/main/resources
}

src_install() {
	java-pkg-simple_src_install
	java-pkg_dojar {name,sasl}prep.jar
}
