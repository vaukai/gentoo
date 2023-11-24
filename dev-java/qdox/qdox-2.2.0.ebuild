# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# No tests, #839681
JAVA_PKG_IUSE="doc source"
MAVEN_ID="com.thoughtworks.qdox:qdox:${PV}"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Parser for extracting class/interface/method definitions"
HOMEPAGE="https://github.com/paul-hammant/qdox"
SRC_URI="https://github.com/paul-hammant/qdox/archive/qdox-${PV}.tar.gz"
S="${WORKDIR}/qdox-${P}"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~ppc-macos ~x64-macos"

BDEPEND="dev-java/byaccj:0"

DEPEND="
	dev-java/jflex:0
	>=virtual/jdk-1.8:*
"
RDEPEND=">=virtual/jre-1.8:*"

JAVA_AUTOMATIC_MODULE_NAME="com.thoughtworks.qdox"
JAVA_CLASSPATH_EXTRA="jflex"
JAVA_SRC_DIR="src/main/java"

src_compile() {
	einfo "Running jflex"
	jflex src/grammar/lexer.flex src/grammar/commentlexer.flex \
		-d src/main/java/com/thoughtworks/qdox/parser/impl || die

	einfo "Running byaccj for DefaultJavaCommentParser"
	byaccj -v \
		-Jnorun \
		-Jnoconstruct \
		-Jclass=DefaultJavaCommentParser \
		-Jpackage=com.thoughtworks.qdox.parser.impl \
		src/grammar/commentparser.y || die

	einfo "Running byaccj for Parser"
	byaccj -v \
		-Jnorun \
		-Jnoconstruct \
		-Jclass=Parser \
		-Jimplements=CommentHandler \
		-Jsemantic=Value \
		-Jpackage=com.thoughtworks.qdox.parser.impl \
		src/grammar/parser.y || die

	mv Parser.java src/main/java/com/thoughtworks/qdox/parser/impl/ || die
	mv DefaultJavaCommentParser.java src/main/java/com/thoughtworks/qdox/parser/impl/ || die
	mv DefaultJavaCommentParserVal.java src/main/java/com/thoughtworks/qdox/parser/impl/ || die

	einfo "Running java-pkg-simple_src_compile"
	java-pkg-simple_src_compile
}
