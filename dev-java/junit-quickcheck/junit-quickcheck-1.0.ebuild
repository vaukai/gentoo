# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TDODO: tests
JAVA_PKG_IUSE="doc source"
MAVEN_PROVIDES=""
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Property-based testing, JUnit-style"
HOMEPAGE="https://github.com/pholser/junit-quickcheck"
SRC_URI="https://github.com/pholser/junit-quickcheck/archive/${P}.tar.gz"
S="${WORKDIR}/junit-quickcheck-${P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

CP_DEPEND="
	dev-java/generics-resolver:0
	dev-java/javaruntype:0
	dev-java/junit:4
	dev-java/ognl:0
	dev-java/slf4j-api:0
"

DEPEND="
	${CP_DEPEND}
	>=virtual/jdk-1.8:*
"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

JAVADOC_SRC_DIRS=( {core,generators}/src/main/java )

src_prepare() {
	java-pkg-2_src_prepare
	local services="generators/src/main/resources/META-INF/services"
	mkdir -p "${services}"
	cat > "${services}/com.pholser.junit.quickcheck.generator.Generator" <<-EOF || die "here doc"
		com.pholser.junit.quickcheck.generator.java.util.ArrayListGenerator
		com.pholser.junit.quickcheck.generator.java.util.HashSetGenerator
		com.pholser.junit.quickcheck.generator.java.util.LocaleGenerator
		com.pholser.junit.quickcheck.generator.java.util.LinkedListGenerator
		com.pholser.junit.quickcheck.generator.java.util.StackGenerator
		com.pholser.junit.quickcheck.generator.java.util.OptionalDoubleGenerator
		com.pholser.junit.quickcheck.generator.java.util.DateGenerator
		com.pholser.junit.quickcheck.generator.java.util.LinkedHashMapGenerator
		com.pholser.junit.quickcheck.generator.java.util.OptionalLongGenerator
		com.pholser.junit.quickcheck.generator.java.util.TimeZoneGenerator
		com.pholser.junit.quickcheck.generator.java.util.function.FunctionGenerator
		com.pholser.junit.quickcheck.generator.java.util.function.UnaryOperatorGenerator
		com.pholser.junit.quickcheck.generator.java.util.function.ToIntBiFunctionGenerator
		com.pholser.junit.quickcheck.generator.java.util.function.PredicateGenerator
		com.pholser.junit.quickcheck.generator.java.util.function.BinaryOperatorGenerator
		com.pholser.junit.quickcheck.generator.java.util.function.BiPredicateGenerator
		com.pholser.junit.quickcheck.generator.java.util.function.ToIntFunctionGenerator
		com.pholser.junit.quickcheck.generator.java.util.function.ToDoubleFunctionGenerator
		com.pholser.junit.quickcheck.generator.java.util.function.ToLongBiFunctionGenerator
		com.pholser.junit.quickcheck.generator.java.util.function.BiFunctionGenerator
		com.pholser.junit.quickcheck.generator.java.util.function.IntFunctionGenerator
		com.pholser.junit.quickcheck.generator.java.util.function.ToLongFunctionGenerator
		com.pholser.junit.quickcheck.generator.java.util.function.DoubleFunctionGenerator
		com.pholser.junit.quickcheck.generator.java.util.function.SupplierGenerator
		com.pholser.junit.quickcheck.generator.java.util.function.LongFunctionGenerator
		com.pholser.junit.quickcheck.generator.java.util.function.ToDoubleBiFunctionGenerator
		com.pholser.junit.quickcheck.generator.java.util.BitSetGenerator
		com.pholser.junit.quickcheck.generator.java.util.OptionalIntGenerator
		com.pholser.junit.quickcheck.generator.java.util.HashMapGenerator
		com.pholser.junit.quickcheck.generator.java.util.VectorGenerator
		com.pholser.junit.quickcheck.generator.java.util.PropertiesGenerator
		com.pholser.junit.quickcheck.generator.java.util.OptionalGenerator
		com.pholser.junit.quickcheck.generator.java.util.concurrent.CallableGenerator
		com.pholser.junit.quickcheck.generator.java.util.RFC4122\$Version4
		com.pholser.junit.quickcheck.generator.java.util.HashtableGenerator
		com.pholser.junit.quickcheck.generator.java.util.LinkedHashSetGenerator
		com.pholser.junit.quickcheck.generator.java.util.RFC4122\$Version3
		com.pholser.junit.quickcheck.generator.java.util.RFC4122\$Version5
		com.pholser.junit.quickcheck.generator.java.math.BigDecimalGenerator
		com.pholser.junit.quickcheck.generator.java.math.BigIntegerGenerator
		com.pholser.junit.quickcheck.generator.java.time.ZonedDateTimeGenerator
		com.pholser.junit.quickcheck.generator.java.time.LocalDateGenerator
		com.pholser.junit.quickcheck.generator.java.time.OffsetTimeGenerator
		com.pholser.junit.quickcheck.generator.java.time.ZoneIdGenerator
		com.pholser.junit.quickcheck.generator.java.time.PeriodGenerator
		com.pholser.junit.quickcheck.generator.java.time.YearMonthGenerator
		com.pholser.junit.quickcheck.generator.java.time.InstantGenerator
		com.pholser.junit.quickcheck.generator.java.time.LocalDateTimeGenerator
		com.pholser.junit.quickcheck.generator.java.time.OffsetDateTimeGenerator
		com.pholser.junit.quickcheck.generator.java.time.DurationGenerator
		com.pholser.junit.quickcheck.generator.java.time.YearGenerator
		com.pholser.junit.quickcheck.generator.java.time.ClockGenerator
		com.pholser.junit.quickcheck.generator.java.time.ZoneOffsetGenerator
		com.pholser.junit.quickcheck.generator.java.time.LocalTimeGenerator
		com.pholser.junit.quickcheck.generator.java.time.MonthDayGenerator
		com.pholser.junit.quickcheck.generator.java.lang.ShortGenerator
		com.pholser.junit.quickcheck.generator.java.lang.CharacterGenerator
		com.pholser.junit.quickcheck.generator.java.lang.DoubleGenerator
		com.pholser.junit.quickcheck.generator.java.lang.IntegerGenerator
		com.pholser.junit.quickcheck.generator.java.lang.StringGenerator
		com.pholser.junit.quickcheck.generator.java.lang.LongGenerator
		com.pholser.junit.quickcheck.generator.java.lang.FloatGenerator
		com.pholser.junit.quickcheck.generator.java.lang.ByteGenerator
		com.pholser.junit.quickcheck.generator.java.lang.Encoded
		com.pholser.junit.quickcheck.generator.java.lang.BooleanGenerator
		com.pholser.junit.quickcheck.generator.java.nio.charset.CharsetGenerator
		com.pholser.junit.quickcheck.generator.VoidGenerator
	EOF
}

src_compile() {
	einfo "Compiling core"
	JAVA_JAR_FILENAME="core.jar"
	JAVA_RESOURCE_DIRS="core/src/main/resources"
	JAVA_SRC_DIR="core/src/main/java"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA=":core.jar"
	rm -r target || die "clean core"

	einfo "Compiling generators"
	JAVA_JAR_FILENAME="generators.jar"
	JAVA_RESOURCE_DIRS="generators/src/main/resources"
	JAVA_SRC_DIR="generators/src/main/java"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA=":generators.jar"
	rm -r target || die "clean generators"

	use doc && ejavadoc
}

src_test() {
	JAVA_TEST_GENTOO_CLASSPATH="junit-4"
	JAVA_TEST_RESOURCE_DIRS="core/src/test/resources"
	JAVA_TEST_SRC_DIR="core/src/test/java"

	JAVA_TEST_RESOURCE_DIRS=()
	JAVA_TEST_SRC_DIR="generators/src/test/java"
}

src_install() {
	java-pkg_dojar generators.jar
	JAVA_JAR_FILENAME="core.jar"
	java-pkg-simple_src_install
}
