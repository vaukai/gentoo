# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="sets javac target"
S="${WORKDIR}"
SLOT="0/${PV}"	# SLOT must always be "0".
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"

src_prepare() {
	eapply_user
	cat > java-gentoo-target <<-EOF || die
		JAVA_GENTOO_SOURCE=${PV}
		JAVA_GENTOO_TARGET=${PV}
	EOF
}

src_install() {
	insinto /usr/share/java-gentoo-target
	doins "java-gentoo-target"
}
