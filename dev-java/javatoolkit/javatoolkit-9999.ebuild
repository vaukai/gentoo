# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
PYTHON_REQ_USE="xml(+)"
DISTUTILS_USE_PEP517=flit

inherit distutils-r1 prefix

DESCRIPTION="Collection of Gentoo-specific tools for Java"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Java"
if [[ ${PV} == *9999* ]]; then
	EGIT_BRANCH="multi-release-jars"
	EGIT_REPO_URI="https://github.com/the-horo/javatoolkit"
	inherit git-r3
else
	SRC_URI="https://gitweb.gentoo.org/proj/${PN}.git/snapshot/${P}.tar.bz2"
	KEYWORDS="~amd64 ~arm64 ~ppc64 ~sparc ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
fi

LICENSE="GPL-2"
SLOT="0"

python_prepare_all() {
	hprefixify src/javatoolkit/scripts/findclass.py
	distutils-r1_python_prepare_all
}

python_install() {
	distutils-r1_python_install

	# The java eclasses expect the scripts to be in a special location
	python_scriptinto /usr/libexec/${PN}
	python_doexe "${D}$(python_get_scriptdir)"/*
}
