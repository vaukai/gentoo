# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake elisp-common java-pkg-2

PATCHSET_VER="2"

DESCRIPTION="Advanced development platform for intelligent, distributed applications"
HOMEPAGE="http://mozart2.org/"
SRC_URI="https://github.com/mozart/mozart2/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~keri/distfiles/mozart/${P}-gentoo-patchset-${PATCHSET_VER}.tar.gz"
S="${WORKDIR}/${PN}2-${PV}"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="emacs test"
RESTRICT="!test? ( test )"

COMMON_DEPEND="
	dev-lang/tcl:0
	dev-lang/tk:0
	dev-libs/boost:=
	dev-libs/gmp:0
	emacs? ( >=app-editors/emacs-23.1:* )"

# https://bugs.gentoo.org/916882 restrict to <=virtual/jdk-17:*
DEPEND="${COMMON_DEPEND}
	>=dev-java/ant-1.10.14-r3:0
	<=virtual/jdk-17:*
	dev-lang/scala:2.12
	test? ( dev-cpp/gtest:= )"

RDEPEND="${COMMON_DEPEND}
	>=virtual/jre-1.8:*"

SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	java-pkg-2_src_prepare
	if [[ -d "${WORKDIR}"/${PV} ]] ; then
		eapply "${WORKDIR}"/${PV}
	fi

	touch stdlib/CMakeLists.txt || die
	touch vm/vm/test/gtest/CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DMOZART_BOOST_USE_STATIC_LIBS=OFF
		-DEMACS=$(usex emacs "/usr/bin/emacs" "")
	)

	cmake_src_configure
}

src_compile() {
	pushd bootcompiler > /dev/null || die
	ANT_OPTS="-Xss2M" eant jar -Dgentoo.classpath="$(java-pkg_getjars --build-only scala-2.12)"
	popd > /dev/null || die

	cmake_src_compile
}

src_test() {
	cmake_build vmtest platform-test
	cmake_src_test -V
}

src_install() {
	cmake_src_install

	dolib.so "${BUILD_DIR}"/vm/vm/main/libmozartvm.so
	dolib.so "${BUILD_DIR}"/vm/boostenv/main/libmozartvmboost.so

	if use emacs; then
		elisp-install ${PN} "${S}"/opi/emacs/*.el
		elisp-site-file-install "${FILESDIR}"/"${SITEFILE}" \
			|| die "elsip-site-file-install failed"
	fi
}

pkg_postinst() {
	if use emacs; then
		xdg_icon_cache_update
		xdg_desktop_database_update
		elisp-site-regen
	fi
}

pkg_postrm() {
	if use emacs; then
		xdg_icon_cache_update
		xdg_desktop_database_update
		elisp-site-regen
	fi
}
