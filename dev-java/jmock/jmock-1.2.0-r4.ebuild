# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Library for testing Java code using mock objects"
HOMEPAGE="http://jmock.org/"
SRC_URI="https://github.com/jmock-developers/jmock-library/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/jmock-library-${PV}"

LICENSE="BSD"
SLOT="1.0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

# src/test/jmock/core/testsupport/MethodFactory.java:8: error: package net.sf.cglib.asm does not exist
# import net.sf.cglib.asm.ClassWriter;
#                        ^
# src/test/jmock/core/testsupport/MethodFactory.java:9: error: package net.sf.cglib.asm does not exist
# import net.sf.cglib.asm.Type;
#                        ^
# src/test/jmock/core/testsupport/MethodFactory.java:88: error: cannot find symbol
#     private static Type[] classesToTypes( Class[] classes ) {
#                    ^
#   symbol:   class Type
#   location: class MethodFactory
RESTRICT="test"

CP_DEPEND="
	dev-java/cglib:3
	dev-java/junit:0
"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

DEPEND="
	${CP_DEPEND}
	app-arch/unzip
	>=virtual/jdk-1.8:*
"

JAVA_SRC_DIR="src/org"
JAVA_TEST_GENTOO_CLASSPATH="cglib-3 junit"
JAVA_TEST_SRC_DIR="src/test"

PATCHES=( "${FILESDIR}/jmock-1.2.0-r3-AbstractMo.patch" )

src_prepare() {
	default #780585
	java-pkg-2_src_prepare
}
