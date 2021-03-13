# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="JFlex is a lexical analyzer generator for Java"
HOMEPAGE="https://www.jflex.de/"
SRC_URI="https://github.com/jflex-de/jflex/releases/download/v${PV}/${P}.tar.gz"
S="${WORKDIR}/${P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc-macos ~x64-macos"
IUSE="ant-task examples test vim-syntax"
REQUIRED_USE="test? ( ant-task )"

DEPEND="
	>=virtual/jdk-1.8:*
	dev-java/auto-value:0
	dev-java/escapevelocity:0
	dev-java/guava:0
	dev-java/incap:0
	>=dev-java/javacup-11b_p20160615-r1:0
	dev-java/javapoet:0
	dev-java/jsr305:0
	ant-task? ( >=dev-java/ant-1.10.15:0 )
	test? (
		dev-java/junit:4
		dev-java/truth:0
	)
"

RDEPEND="
	>=virtual/jre-1.8:*
	ant-task? ( >=dev-java/ant-1.10.15:0 )
	vim-syntax? ( || ( app-editors/vim app-editors/gvim ) )
"

DOCS=( {changelog,README}.md )

JAVA_CLASSPATH_EXTRA="auto-value,jsr305"
JAVA_MAIN_CLASS="jflex.Main"
JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR="src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="
	ant
	junit-4
	truth
"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"

src_compile() {
#	$(java-config -J) -cp "lib/jflex-full-${PV}.jar" jflex.Main \
#		src/main/jflex/LexScan.flex -d src/main/java || die

	# Using the self-genetated causes those 5 errors.

	# src/main/java/LexScan.java:1848: error: cannot find symbol
	#     yypushStream(Files.newBufferedReader(f.toPath(), Options.encoding));
	#     ^
	#   symbol:   method yypushStream(BufferedReader)
	#   location: class LexScan
	# src/main/java/LexScan.java:2319: error: cannot find symbol
	#               if ( yymoreStreams() ) {
	#                    ^
	#   symbol:   method yymoreStreams()
	#   location: class LexScan
	# src/main/java/LexScan.java:2321: error: cannot find symbol
	#                                   yypopStream();
	#                                   ^
	#   symbol:   method yypopStream()
	#   location: class LexScan
	# src/main/java/LexScan.java:2365: error: cannot find symbol
	#                 if ( yymoreStreams() ) {
	#                      ^
	#   symbol:   method yymoreStreams()
	#   location: class LexScan
	# src/main/java/LexScan.java:2367: error: cannot find symbol
	#              yypopStream();
	#              ^
	#   symbol:   method yypopStream()
	#   location: class LexScan
	# Note: src/main/java/jflex/LexParse.java uses or overrides a deprecated API.
	# Note: Recompile with -Xlint:deprecation for details.
	# 5 errors

	# Using the pre-generated LexScan.java works.
	cp src/{generated/jflex/jflex/core,main/java}/LexScan.java || die

	if use ant-task; then
		JAVA_GENTOO_CLASSPATH_EXTRA+=":$(java-pkg_getjar --build-only ant ant.jar)"
	else
		rm src/main/java/jflex/anttask/JFlexTask.java || die
	fi

	JAVACUP=$(java-pkg_getjar --build-only javacup javacup.jar)
	JAVA_GENTOO_CLASSPATH_EXTRA+=":${JAVACUP}"
	java -jar "${JAVACUP}" -destdir ${JAVA_SRC_DIR} -package ${PN} \
		-parser LexParse -interface src/main/cup/LexParse.cup || die

	# get processorpath
	local pp="$(java-pkg_getjar --build-only auto-value auto-value.jar)"
	pp="${pp}:$(java-pkg_getjar --build-only auto-value auto-common.jar)"
	pp="${pp}:$(java-pkg_getjars --build-only escapevelocity,guava,incap,javapoet)"

	JAVAC_ARGS="-processorpath ${pp} -s src/main/java"

	java-pkg-simple_src_compile

}

#src_test() {
#	java-pkg-simple_src_test
#}

src_install() {
	java-pkg-simple_src_install
#	java-pkg_dolauncher ${PN} --main ${PN}.Main

	use ant-task && java-pkg_register-ant-task

	use examples && java-pkg_doexamples examples

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
