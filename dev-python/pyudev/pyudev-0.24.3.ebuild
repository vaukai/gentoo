# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )
inherit distutils-r1 optfeature pypi

DESCRIPTION="Python binding to libudev"
HOMEPAGE="https://pyudev.readthedocs.io/en/latest/ https://github.com/pyudev/pyudev"
SRC_URI="https://github.com/pyudev/pyudev/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~loong ~mips ppc ppc64 ~riscv sparc x86"

# Known to fail on test system that aren't exactly the same devices as on CI
#RESTRICT="test"

RDEPEND="
	virtual/udev
"
BDEPEND="
	test? (
		dev-python/docutils[${PYTHON_USEDEP}]
		dev-python/hypothesis[${PYTHON_USEDEP}]
	)
"

DOCS=( CHANGES.rst README.rst )

PATCHES=(
	"${FILESDIR}/pyudev-0.24.3-tests.patch"
)

distutils_enable_tests pytest

python_prepare_all() {
	if use test; then
		ewarn "If your PORTAGE_TMPDIR is longer in length then '/var/tmp/',"
		ewarn "change it to /var/tmp to ensure tests will pass."
	fi

	# tests are known to pass then fail on alternate runs
	# tests: fix run_path
	sed -e "s|== \('/run/udev'\)|in (\1,'/dev/.udev')|g" \
		-i tests/test_core.py || die

	# disable usage of hypothesis timeouts (too short)
	sed -e '/@settings/s/(/(deadline=None,/' -i tests{,/_device_tests}/*.py || die

	# remove GUI tests that require a display server
	rm tests/test_observer.py tests/test_observer_deprecated.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	local -a EPYTEST_DESELECT=(
		# tests that require root access
		tests/test_device.py::TestAttributes::test_asint
		tests/test_device.py::TestAttributes::test_asbool
		tests/test_device.py::TestAttributes::test_getitem
		tests/test_device.py::TestAttributes::test_asstring

		# tests don't work on systems that differ from the upstream CI
		tests/test_monitor.py::TestMonitorObserver::test_deprecated_handler
		tests/test_monitor.py::TestMonitorObserver::test_fake
	)
	epytest tests
}

src_test() {
	local virt=$(systemd-detect-virt 2>/dev/null)
	if [[ ${virt} == systemd-nspawn ]] ; then
		ewarn "Skipping tests because in systemd-nspawn container"
	else
		distutils-r1_src_test
	fi
}

pkg_postinst() {
	optfeature "PyQt5 bindings" "dev-python/pyqt5"
}
