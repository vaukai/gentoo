# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/unicode-org/icu/archive/refs/tags/release-69-1.tar.gz --slot 69 --keywords "~amd64 ~arm64 ~ppc64 ~x86" --ebuild icu4j-69.1.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="com.ibm.icu:icu4j:69.1"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A set of Java libraries providing Unicode and Globalization support"
HOMEPAGE="https://icu-project.org/"
SRC_URI="https://github.com/unicode-org/icu/archive/refs/tags/release-${PV/./-}.tar.gz -> ${P}.tar.gz"

LICENSE="icu"
SLOT="69"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"

DEPEND="
	>=virtual/jdk-1.8:*
	test? (
		dev-java/junitparams:0
	)
"

RDEPEND="
	>=virtual/jre-1.8:*
"

BDEPEND="
	app-arch/zip
"

S="${WORKDIR}/icu-release-${PV/./-}/icu4j/main"

HTML_DOCS=( {readme,APIChangeReport}.html  )

JAVA_GENTOO_CLASSPATH_EXTRA="icu4j.jar:icu4j-charset.jar:icu4j-localespi.jar"

# icu4j.jar
ICU4J_JAR="icu4j.jar"
ICU4J_SRC="classes"
ICU4J_RESOURCES="../resources/icu4j"
# icu4j-charset.jar
ICU4J_CHARSET_JAR="icu4j-charset.jar"
ICU4J_CHARSET_SRC="../src/icu4j-charset"
ICU4J_CHARSET_RESOURCES="../resources/icu4j-charset"
# icu4j-localespi.jar
ICU4J_LOCALESPI_JAR="icu4j-localespi.jar"
ICU4J_LOCALESPI_SRC="../src/icu4j-localespi"
ICU4J_LOCALESPI_RESOURCES="../resources/icu4j-localespi"

JAVA_TEST_SRC_DIR=(
	"tests/charset/src"
	"tests/collate/src"
	"tests/core/src"
	"tests/framework/src"
	"tests/localespi/src"
	"tests/packaging/src"
	"tests/translit/src"
	"../tools/misc/src"
)

JAVA_TEST_RESOURCE_DIRS=(
	"tests/charset/resources"
	"tests/collate/resources"
	"tests/core/resources"
	"tests/framework/resources"
	"tests/localespi/resources"
	"tests/packaging/resources"
	"tests/translit/resources"
)

JAVA_TEST_GENTOO_CLASSPATH="junit-4,junitparams"

JAVA_TEST_EXCLUDES=(
	'com.ibm.icu.dev.tool.ime.IMETest'
	'com.ibm.icu.dev.test.bidi.TestData'
	'com.ibm.icu.dev.test.calendar.ChineseTestCase'
	'com.ibm.icu.dev.test.stringprep.TestData'
	'com.ibm.icu.dev.test.ModuleTest'
	'com.ibm.icu.dev.test.TestDataModule'
	'com.ibm.icu.dev.test.TestUtil'
	'com.ibm.icu.dev.test.localespi.TestUtil'
	'com.ibm.icu.dev.test.TestBoilerplate'
	'com.ibm.icu.dev.test.translit.TestUtility'
	'com.ibm.icu.dev.test.TestLog'
	'com.ibm.icu.dev.test.TestFmwk'
	'com.ibm.icu.dev.data.TestDataElements_testtypes'
#	'com.ibm.icu.dev.data.resources.TestDataElements'
	'com.ibm.icu.dev.data.resources.TestDataElements_en_Latn_US'
	'com.ibm.icu.dev.data.resources.TestDataElements_en_US'
	'com.ibm.icu.dev.data.resources.TestDataElements_fr_Latn_FR'
	'com.ibm.icu.dev.data.resources.TestDataElements_te'
	'com.ibm.icu.dev.data.resources.TestMessages'
)

src_prepare() {
	default

	mkdir --parents \
		${ICU4J_RESOURCES} \
		${ICU4J_CHARSET_SRC} \
		${ICU4J_CHARSET_RESOURCES}/com/ibm/icu/{charset,impl/data/icudt69b} \
		${ICU4J_LOCALESPI_SRC} \
		${ICU4J_LOCALESPI_RESOURCES}/com/ibm/icu/impl/javaspi \
		|| die "failed to create source directories"

	# resources for icu4j.jar
	pushd "${ICU4J_RESOURCES}"
	jar --create \
		-C "${S}"/shared/licenses LICENSE \
		-C "${S}/${ICU4J_SRC}"/collate/src com \
		-C "${S}/${ICU4J_SRC}"/core/src com \
		-C "${S}/${ICU4J_SRC}"/currdata/src com \
		-C "${S}/${ICU4J_SRC}"/langdata/src com \
		-C "${S}/${ICU4J_SRC}"/regiondata/src com \
		-C "${S}/${ICU4J_SRC}"/translit/src com \
		| jar --extract  || die
	find . -type f -name '*.java' -exec rm -rf {} + || die "deleting classes failed"
	jar --extract --file "${S}/shared/data/icudata.jar" || die
	jar --extract --file "${S}/shared/data/icutzdata.jar" || die
	for dir in $(find com/ibm/icu/impl/data/icudt69b/ -type d ! -name 'unit' -exec echo {} +); do
		ls -1 $dir/*.res | sed -e 's%.*\/%%' -e 's%\..*$%%' -e '/pool/d' -e '/res_index/d' -e '/tzdbNames/d'\
			> $dir/'fullLocaleNames.lst';
	done || die "fullLocaleNames.lst failed"
	popd || die "failed in ICU4J_RESOURCES"

	# resources for icu4j-charset.jar
	pushd "${ICU4J_CHARSET_RESOURCES}"
	mv "${S}/${ICU4J_RESOURCES}"/com/ibm/icu/impl/data/icudt69b/{*.cnv,cnvalias.icu} \
		com/ibm/icu/impl/data/icudt69b || die
	mv "${S}/${ICU4J_SRC}"/charset/src/com/ibm/icu/charset/package.html \
		com/ibm/icu/charset || die
	mv "${S}/${ICU4J_SRC}"/charset/src/META-INF .  || die "moving CharsetProvider failed"
	cp "${S}"/shared/licenses/LICENSE . || die "copying license failed"
	popd || die "failed in ICU4J_CHARSET_RESOURCES"

	# resources for icu4j-localespi.jar
	pushd "${ICU4J_LOCALESPI_RESOURCES}"
	mv "${S}/${ICU4J_SRC}"/localespi/src/com/ibm/icu/impl/javaspi/{ICULocaleServiceProviderConfig.properties,package.html} \
		com/ibm/icu/impl/javaspi || die
	mv "${S}/${ICU4J_SRC}"/localespi/src/META-INF . || die
	cp "${S}"/shared/licenses/LICENSE . || die "copying license failed"
	popd || die "failed in ICU4J_LOCALESPI_RESOURCES"

	# classes for icu4j-charset.jar
	mv "${ICU4J_SRC}"/charset "${ICU4J_CHARSET_SRC}" || die "moving charset failed"

	# classes for icu4j-localespi.jar
	mv "${ICU4J_SRC}"/localespi "${ICU4J_LOCALESPI_SRC}" || die "moving localespi failed"
}

src_compile() {
	JAVA_SRC_DIR="${ICU4J_SRC}"
	JAVA_RESOURCE_DIRS="${ICU4J_RESOURCES}"
	JAVA_JAR_FILENAME="${ICU4J_JAR}"
	java-pkg-simple_src_compile
	rm -fr target/classes || die "Failed to remove compiled files"

	JAVA_SRC_DIR="${ICU4J_CHARSET_SRC}"
	JAVA_RESOURCE_DIRS="${ICU4J_CHARSET_RESOURCES}"
	JAVA_JAR_FILENAME="${ICU4J_CHARSET_JAR}"
	java-pkg-simple_src_compile
	rm -fr target/classes || die "Failed to remove compiled files"

	JAVA_SRC_DIR="${ICU4J_LOCALESPI_SRC}"
	JAVA_RESOURCE_DIRS="${ICU4J_LOCALESPI_RESOURCES}"
	JAVA_JAR_FILENAME="${ICU4J_LOCALESPI_JAR}"
	java-pkg-simple_src_compile
}

src_test(){
	# data resource '/com/ibm/icu/dev/data/unicode/...txt' not found
	# data resource '/com/ibm/icu/dev/data/collationtest.txt' not found
	jar --update --file icu4j.jar \
		-C tests/core/src com/ibm/icu/dev/data \
		-C tests/collate/src com/ibm/icu/dev/data || die "updating jar failed"

	# testdata.jar
	mkdir --parents "${JAVA_TEST_RESOURCE_DIRS}" || die "mkdir failed"
	pushd "${JAVA_TEST_RESOURCE_DIRS}"
	jar --extract --file "${S}/shared/data/testdata.jar" || die
	popd || die

	# clone tests src
	for i in charset collate core framework localespi packaging translit; do \
		cp -r tests/$i/src tests/$i/resources ; \
	done || die "copying from src to tests failed"

	# separate tests resources from tests src
	find tests/*/src -type f -not -name '*.java' -exec rm -rf {} + || die
	find tests/*/resources -type f -name '*.java' -exec rm -rf {} + || die

	java-pkg-simple_src_test

	# remove stuff added in test phase
	zip --delete icu4j.jar \
		"com/ibm/icu/dev/" || die "cleaning after tests failed"
}

src_install() {
	JAVA_SRC_DIR="${ICU4J_SRC}"
	JAVA_JAR_FILENAME="${ICU4J_JAR}"
	java-pkg-simple_src_install

	java-pkg_dojar "${ICU4J_CHARSET_JAR}"
	java-pkg_dojar "${ICU4J_LOCALESPI_JAR}"
}
