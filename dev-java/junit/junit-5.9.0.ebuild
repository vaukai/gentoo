# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.junit:bom:5.9.0"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Programmer-friendly testing framework for Java and the JVM"
HOMEPAGE="https://junit.org/junit5/"
SRC_URI="https://github.com/junit-team/junit5/archive/r${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="EPL-2.0"
SLOT="5"
KEYWORDS="~amd64"
IUSE="jupiter migrationsupport vintage"

CP_DEPEND="
	dev-java/opentest4j:0
	dev-java/open-test-reporting-events:0
	dev-java/picocli:0
"

DEPEND="
	dev-java/apiguardian-api:0
	>=virtual/jdk-11:*
	${CP_DEPEND}
	jupiter? ( dev-java/univocity-parsers:0 )
	migrationsupport? ( dev-java/junit:4 )
	vintage? ( dev-java/junit:4 )
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CP_DEPEND}
	jupiter? ( dev-java/univocity-parsers:0 )
	migrationsupport? ( dev-java/junit:4 )
	vintage? ( dev-java/junit:4 )
"

S="${WORKDIR}/junit5-r${PV}"

JUNIT_5_MODULES=(
	junit-platform-commons
	junit-platform-suite-api
	junit-platform-engine
	junit-platform-launcher
	junit-platform-suite-commons
	junit-platform-suite-engine
	junit-platform-jfr
	junit-platform-reporting
	junit-platform-console
	junit-jupiter-api
)

JAVA_CLASSPATH_EXTRA="apiguardian-api"

src_prepare() {
	default
	java-pkg_clean
	local module
	for module in "${JUNIT_5_MODULES[@]}"; do
		echo ${module} >> "${T}/junit-${PV}-modules" || die
	done

	# junit-jupiter-params pulls univocity-parsers
	if use jupiter; then
		JAVA_GENTOO_CLASSPATH+=" univocity-parsers"
		sed -e '/jupiter-api/a junit-jupiter-engine \njunit-jupiter-params \njunit-jupiter' \
			-i "${T}/junit-${PV}-modules" || die
	fi

	# junit-jupiter-migrationsupport pulls junit:4
	if use migrationsupport; then
		JAVA_GENTOO_CLASSPATH+=" junit-4"
		echo "junit-jupiter-migrationsupport" >> \
			"${T}/junit-${PV}-modules" || die
	fi

	# junit-vintage-engine pulls junit:4
	if use vintage; then
		JAVA_GENTOO_CLASSPATH+=" junit-4"
		echo "junit-vintage-engine" >> \
			"${T}/junit-${PV}-modules" || die
	fi
}

src_compile() {
	# We loop over the modules list and compile the jar files.
	while read module; do
		JAVA_MAIN_CLASS=""
		JAVA_RESOURCE_DIRS=()
		JAVA_SRC_DIR=()

		einfo "Compiling $module"

		JAVA_JAR_FILENAME="$module.jar"

		# Not all of the modules have resources.
		if [[ -d $module/src/main/resources ]]; then
			JAVA_RESOURCE_DIRS="$module/src/main/resources"
		fi

		JAVA_SRC_DIR=(
			"$module/src/main/java"
			"$module/src/module"
		)
		if [[ $module == junit-platform-console ]]; then
			JAVA_SRC_DIR+=( "$module/src/main/java9" )
			JAVA_MAIN_CLASS="org.junit.platform.console.ConsoleLauncher"
		fi

		java-pkg-simple_src_compile
		JAVA_GENTOO_CLASSPATH_EXTRA+=":$module.jar"

		rm -r target || die
	done < "${T}/junit-${PV}-modules"

	if use doc; then
		JAVA_SRC_DIR=()
		JAVA_JAR_FILENAME="ignoreme.jar"
		while read module ; do
			JAVA_SRC_DIR+=( "$module/src/main/java" )
		done < "${T}/junit-${PV}-modules"
		java-pkg-simple_src_compile
	fi
}

src_install() {
	einstalldocs # https://bugs.gentoo.org/789582
	while read module; do
		java-pkg_dojar $module.jar
		if use source; then
			java-pkg_dosrc "$module/src/main/java/*"
		fi
	done < "${T}/junit-${PV}-modules"
	java-pkg_dolauncher "junit-platform-console-${SLOT}" \
		--main "org.junit.platform.console.ConsoleLauncher"
	if use doc; then
		java-pkg_dojavadoc target/api
	fi
}
