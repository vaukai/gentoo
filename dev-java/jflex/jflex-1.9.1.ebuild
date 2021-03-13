# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="JFlex is a lexical analyzer generator for Java"
HOMEPAGE="https://www.jflex.de/"
SRC_URI="https://github.com/jflex-de/jflex/releases/download/v${PV}/${P}.tar.gz
	test? ( https://repo1.maven.org/maven2/com/google/truth/truth/1.1.3/truth-1.1.3.jar )"
S="${WORKDIR}/${P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc-macos ~x64-macos"
IUSE="ant-task examples test vim-syntax"
REQUIRED_USE="test? ( ant-task )"

CP_DEPEND="
	dev-java/auto-value-annotations:0
	dev-java/javacup:0
	dev-java/jsr305:0
"

DEPEND="${CP_DEPEND}
	>=virtual/jdk-1.8:*
	ant-task? ( >=dev-java/ant-1.10.14-r3:0 )
	test? ( dev-java/junit:4 )
"

RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*
	ant-task? ( >=dev-java/ant-1.10.14-r3:0 )
	vim-syntax? ( || ( app-editors/vim app-editors/gvim ) )
"

PDEPEND=">=dev-java/javacup-11b_p20160615:0"

JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR="src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="
	ant
	junit-4
"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"

src_prepare() {
	java-pkg-2_src_prepare

	if use ant-task; then
		JAVA_GENTOO_CLASSPATH_EXTRA+=":$(java-pkg_getjar --build-only ant ant.jar)"
	else
		rm src/main/java/jflex/anttask/JFlexTask.java || die
	fi
}

src_compile() {
	JAVA_GENTOO_CLASSPATH_EXTRA="lib/jflex-full-${PV}.jar"
	jflex src/main/jflex/LexScan.flex

	JAVACUP=$(java-pkg_getjar --build-only javacup javacup.jar)
	JAVA_GENTOO_CLASSPATH_EXTRA+=":${JAVACUP}"
	java -jar "${JAVACUP}" -destdir ${JAVA_SRC_DIR}/${PN} -package ${PN} \
		-parser LexParse -interface src/main/cup/LexParse.cup || die

	java-pkg-simple_src_compile
}

src_test() {
	JAVA_GENTOO_CLASSPATH_EXTRA="${DISTDIR}/truth-1.1.3.jar"
	java-pkg-simple_src_test
}

src_install() {
	java-pkg-simple_src_install
	java-pkg_dolauncher ${PN} --main ${PN}.Main

	java-pkg_register-dependency javacup javacup-runtime.jar
	use ant-task && java-pkg_register-ant-task

	use examples && java-pkg_doexamples examples
	dodoc {changelog,README}.md

	if use doc; then
		dodoc doc/*.pdf
		docinto html
		dodoc doc/*.{css,html,png} doc/COPYRIGHT
	fi

	if use vim-syntax; then
		insinto /usr/share/vim/vimfiles/syntax
		doins lib/${PN}.vim
	fi
}
