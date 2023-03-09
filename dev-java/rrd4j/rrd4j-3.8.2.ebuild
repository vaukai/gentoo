# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.rrd4j:rrd4j:3.8.2"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A high performance data logging and graphing system for time series data"
HOMEPAGE="https://github.com/rrd4j/rrd4j/"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}"

LICENSE="Apache-2.0"
SLOT="3.8"
KEYWORDS="~amd64"

# Common dependencies
# POM: pom.xml
# com.sleepycat:je:18.3.12 -> !!!groupId-not-found!!!
# org.mongodb:mongo-java-driver:3.12.11 -> !!!groupId-not-found!!!

CDEPEND="
	dev-java/sleepycat-je:0
"
CDEPEND=""

# Compile dependencies
# POM: pom.xml
# test? junit:junit:4.13.2 -> >=dev-java/junit-4.13.2:4
# test? org.apache.felix:org.apache.felix.framework:7.0.5 -> >=dev-java/felix-framework-7.0.5:0
# test? org.apache.logging.log4j:log4j-api:2.19.0 -> >=dev-java/log4j-api-2.19.0:2
# test? org.apache.logging.log4j:log4j-core:2.19.0 -> >=dev-java/log4j-core-2.19.0:2
# test? org.apache.logging.log4j:log4j-slf4j-impl:2.19.0 -> !!!artifactId-not-found!!!
# test? org.easymock:easymock:4.3 -> !!!suitable-mavenVersion-not-found!!!
# test? org.ops4j.pax.exam:pax-exam-container-native:4.13.5 -> !!!groupId-not-found!!!
# test? org.ops4j.pax.exam:pax-exam-junit4:4.13.5 -> !!!groupId-not-found!!!
# test? org.ops4j.pax.exam:pax-exam-link-mvn:4.13.5 -> !!!groupId-not-found!!!

DEPEND="
	>=virtual/jdk-1.8:*
	${CDEPEND}
	test? (
		dev-java/easymock:3.2
		>=dev-java/felix-framework-7.0.5:0
		>=dev-java/log4j-api-2.19.0:2
		>=dev-java/log4j-core-2.19.0:2
	)
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CDEPEND}"

DOCS=( README.md changelog.txt )

JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="
	easymock-3.2
	felix-framework
	junit-4
	log4j-api-2
	log4j-core-2"
#	!!!artifactId-not-found!!!
#	!!!suitable-mavenVersion-not-found!!!
#	!!!groupId-not-found!!!
#	!!!groupId-not-found!!!
#	!!!groupId-not-found!!!"

JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"

src_prepare() {
	java-pkg-2_src_prepare

	rm src/*/java/org/rrd4j/core/RrdBerk*leyDb*.java ||
		die 'rm Berkeley DB support'
	rm src/*/java/org/rrd4j/core/Rrd*MongoD?*.java ||
		die 'rm Mongo DB support'
}

src_compile() {
	# Do not install the JAR file produced by java-pkg-simple_src_compile.
	# Upstream packages the compiled sources differently.
	JAVA_JAR_FILENAME="temp.jar"
	java-pkg-simple_src_compile

	pushd target/classes > /dev/null || die

	# https://github.com/rrd4j/rrd4j/blob/3.8.2/pom.xml#L291-L301
	jar -cvf ../../rrd4j.jar $(find -type f \
		! -path '**/converter/*' \
		! -path '**/inspector/*' \
		! -path '**/demo/*' \
		! -name '*.gif' \
		! -name '*.png' \
		! -path '**/org/rrd4j/core/timespec/Epoch*.class') || die

	# https://github.com/rrd4j/rrd4j/blob/3.8.2/pom.xml#L313-L316
	jar -cvfe ../../rrd4j-converter.jar org.rrd4j.converter.Converter \
		$(find -type f 	-path '**/converter/*') || die

	# https://github.com/rrd4j/rrd4j/blob/3.8.2/pom.xml#L334-L339
	jar -cvfe ../../rrd4j-inspector.jar org.rrd4j.inspector.RrdInspector \
		$(find -type f \
		\( -path '**/inspector/*' \
		-o -name '*.gif' \
		-o -name '*.png' \)) || die

	# https://github.com/rrd4j/rrd4j/blob/3.8.2/pom.xml#L378-L381
	jar -cvfe ../../rrd4j-epoch.jar org.rrd4j.core.timespec.Epoch \
		$(find -type f 	-path '**/org/rrd4j/core/timespec/Epoch*.class') || die

	popd > /dev/null || die

	# Do not install "temp.jar"
	JAVA_JAR_FILENAME="${PN}.jar"
}

src_test() {
	# error: package org.ops4j.pax.exam does not exist
	rm src/test/java/org/rrd4j/osgi/OSGiSmokeTest.java || die

	# error: cannot find symbol Demo.main(new String[] {});
	# we didn't build "demo"
	rm src/test/java/org/rrd4j/demo/RunDemo.java || die

	# java.lang.ClassFormatError accessible: module
	# java.base does not "opens java.lang" to unnamed module @3bc9f433
	local vm_version="$(java-config -g PROVIDES_VERSION)"
	if ver_test "${vm_version}" -ge 17; then
		JAVA_TEST_EXTRA_ARGS+=( --add-opens=java.base/java.lang=ALL-UNNAMED )
	#	JAVA_TEST_EXTRA_ARGS+=( --add-opens=java.base/java.io=ALL-UNNAMED )
	fi

	java-pkg-simple_src_test
}

src_install() {
	java-pkg-simple_src_install
	java-pkg_dojar rrd4j-converter.jar rrd4j-inspector.jar rrd4j-epoch.jar
	java-pkg_dolauncher rrd4j-converter --main org.rrd4j.converter.Converter
	java-pkg_dolauncher rrd4j-inspector --main org.rrd4j.inspector.RrdInspector
	java-pkg_dolauncher rrd4j-epoch --main org.rrd4j.core.timespec.Epoch
}
