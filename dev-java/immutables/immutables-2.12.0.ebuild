# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID=""
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Compile time annotations and compile time annotation processor"
HOMEPAGE="https://immutables.github.io"
SRC_URI="https://github.com/immutables/immutables/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

CP_DEPEND=""

DEPEND="
	${CP_DEPEND}
	dev-java/eclipse-ecj:4.38
	>=dev-java/guava-33.5.0:0
	>=dev-java/jsr305-3.0.2-r1:0
	>=dev-java/parboiled-1.4.1:0
	>=virtual/jdk-1.8:*
"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

JAVA_CLASSPATH_EXTRA="
	checker-framework-qual
	eclipse-ecj-4.38
	guava
	jsr305
	parboiled
"

src_compile() {
#	local cp="$(java-pkg_getjars eclipse-ecj-4.33)"
#	cp="${cp}:$(java-pkg_getjars --with-dependencies guava,parboiled)"
#
#	einfo "compile them all"
#	local sources=$(find \
#		value-annotations/src \
#		generator/src \
#		trees/src \
#		metainf/src \
#		mirror/src \
#		generator-processor/src \
#		-name '*.java') || die "gather sources"
#	#	value-processor/src \
#	#	generator-fixture/src \
#	#	value/src \
#	ejavac -d target/classes -classpath "${cp}" ${sources[@]} -s generator-processor/src
#	use doc && ejavadoc -d target/api -classpath "${cp}" -quiet ${sources[@]}

	JAVA_AUTOMATIC_MODULE_NAME="org.immutables.value.annotations"
	JAVA_JAR_FILENAME="value-annotations.jar"
	JAVA_SRC_DIR="value-annotations/src"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA=":value-annotations.jar"
	rm -r target || die

	JAVA_AUTOMATIC_MODULE_NAME="org.immutables.generator"
	JAVA_JAR_FILENAME="generator.jar"
	JAVA_SRC_DIR="generator/src"
	JAVAC_ARGS="-s generator/src -g"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":generator.jar"
	rm -r target || die

#	JAVA_JAR_FILENAME="value-processor.jar"
#	JAVA_SRC_DIR="value-processor/src"
#	java-pkg-simple_src_compile
#	JAVA_GENTOO_CLASSPATH_EXTRA=":value-processor.jar"
#	rm -r target || die

	JAVA_AUTOMATIC_MODULE_NAME=""
	JAVA_JAR_FILENAME="trees.jar"
	JAVA_SRC_DIR="trees/src"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":trees.jar"
	rm -r target || die

	JAVA_AUTOMATIC_MODULE_NAME=""
	JAVA_JAR_FILENAME="metainf.jar"
	JAVA_SRC_DIR="metainf/src"
	JAVAC_ARGS="-s metainf/src -g"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":metainf.jar"
	rm -r target || die

	JAVA_AUTOMATIC_MODULE_NAME="org.immutables.generator.processor"
	JAVA_JAR_FILENAME="generator-processor.jar"
	JAVA_SRC_DIR="generator-processor/src"
	JAVAC_ARGS="-s generator-processor/src -g"
	JAVA_GENTOO_CLASSPATH_EXTRA+=":generator-processor/src"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":generator-processor.jar"
	rm -r target || die


# [DEBUG]
# -d /var/tmp/portage/dev-java/immutables-2.10.1/work/immutables-2.10.1/generator-processor/target/classes
# -classpath /var/tmp/portage/dev-java/immutables-2.10.1/work/immutables-2.10.1/generator-processor/target/classes:
# 	/home/volkmar/.m2/repository/org/immutables/generator/2.10.1/generator-2.10.1.jar:
# 	/home/volkmar/.m2/repository/com/google/guava/guava/30.0-jre/guava-30.0-jre.jar:
# 	/home/volkmar/.m2/repository/com/google/guava/failureaccess/1.0.1/failureaccess-1.0.1.jar:
# 	/home/volkmar/.m2/repository/com/google/guava/listenablefuture/9999.0-empty-to-avoid-conflict-with-guava/listenablefuture-9999.0-empty-to-avoid-conflict-with-guava.jar:
# 	/home/volkmar/.m2/repository/org/checkerframework/checker-qual/3.5.0/checker-qual-3.5.0.jar:
# 	/home/volkmar/.m2/repository/com/google/errorprone/error_prone_annotations/2.3.4/error_prone_annotations-2.3.4.jar:
# 	/home/volkmar/.m2/repository/com/google/j2objc/j2objc-annotations/1.3/j2objc-annotations-1.3.jar:
# 	/home/volkmar/.m2/repository/com/google/code/findbugs/jsr305/3.0.2/jsr305-3.0.2.jar:
# 	/home/volkmar/.m2/repository/org/immutables/value/2.7.5/value-2.7.5.jar:
# 	/home/volkmar/.m2/repository/org/immutables/trees/2.7.5/trees-2.7.5.jar:
# 	/home/volkmar/.m2/repository/org/immutables/metainf/2.7.5/metainf-2.7.5.jar:
# 	/home/volkmar/.m2/repository/org/parboiled/parboiled-java/1.3.1/parboiled-java-1.3.1.jar:
# 	/home/volkmar/.m2/repository/org/parboiled/parboiled-core/1.3.1/parboiled-core-1.3.1.jar:
# 	/home/volkmar/.m2/repository/org/ow2/asm/asm/7.1/asm-7.1.jar:
# 	/home/volkmar/.m2/repository/org/ow2/asm/asm-tree/7.1/asm-tree-7.1.jar:
# 	/home/volkmar/.m2/repository/org/ow2/asm/asm-analysis/7.1/asm-analysis-7.1.jar:
# 	/home/volkmar/.m2/repository/org/ow2/asm/asm-util/7.1/asm-util-7.1.jar:
# -sourcepath /var/tmp/portage/dev-java/immutables-2.10.1/work/immutables-2.10.1/generator-processor/src/:
# 	/var/tmp/portage/dev-java/immutables-2.10.1/work/immutables-2.10.1/generator-processor/target/generated-sources/annotations: 
# 	/var/tmp/portage/dev-java/immutables-2.10.1/work/immutables-2.10.1/generator-processor/src/org/immutables/generator/processor/Accessors.java 
# 	/var/tmp/portage/dev-java/immutables-2.10.1/work/immutables-2.10.1/generator-processor/src/org/immutables/generator/processor/TypeResolver.java 
# 	/var/tmp/portage/dev-java/immutables-2.10.1/work/immutables-2.10.1/generator-processor/src/org/immutables/generator/processor/Spacing.java 
# 	/var/tmp/portage/dev-java/immutables-2.10.1/work/immutables-2.10.1/generator-processor/src/org/immutables/generator/processor/Introspection.java 
# 	/var/tmp/portage/dev-java/immutables-2.10.1/work/immutables-2.10.1/generator-processor/src/org/immutables/generator/processor/Parser.java 
# 	/var/tmp/portage/dev-java/immutables-2.10.1/work/immutables-2.10.1/generator-processor/src/org/immutables/generator/processor/SwissArmyKnife.java 
# 	/var/tmp/portage/dev-java/immutables-2.10.1/work/immutables-2.10.1/generator-processor/src/org/immutables/generator/processor/Balancing.java 
# 	/var/tmp/portage/dev-java/immutables-2.10.1/work/immutables-2.10.1/generator-processor/src/org/immutables/generator/processor/Trees.java 
# 	/var/tmp/portage/dev-java/immutables-2.10.1/work/immutables-2.10.1/generator-processor/src/org/immutables/generator/processor/Processor.java 
# 	/var/tmp/portage/dev-java/immutables-2.10.1/work/immutables-2.10.1/generator-processor/src/javax/annotation/Generated.java 
# 	/var/tmp/portage/dev-java/immutables-2.10.1/work/immutables-2.10.1/generator-processor/src/org/immutables/generator/processor/Imports.java 
# 	/var/tmp/portage/dev-java/immutables-2.10.1/work/immutables-2.10.1/generator-processor/src/org/immutables/generator/processor/Inliner.java 
# 	/var/tmp/portage/dev-java/immutables-2.10.1/work/immutables-2.10.1/generator-processor/src/org/immutables/generator/processor/GeneratedTypes.java 
# 	/var/tmp/portage/dev-java/immutables-2.10.1/work/immutables-2.10.1/generator-processor/src/org/immutables/generator/processor/TemplateWriter.java 
# -s /var/tmp/portage/dev-java/immutables-2.10.1/work/immutables-2.10.1/generator-processor/target/generated-sources/annotations 
# -g -target 1.8 -source 1.8 -encoding UTF-8 -Xlint:unchecked -Xmaxerrs 1000000

#	JAVA_AUTOMATIC_MODULE_NAME=""
#	JAVA_JAR_FILENAME="value-processor.jar"
#	JAVA_SRC_DIR="value-processor/src"
#	java-pkg-simple_src_compile
#	JAVA_GENTOO_CLASSPATH_EXTRA=":value-processor.jar"
#	rm -r target || die
}

src_install() {
	JAVA_JAR_FILENAME="generator.jar"
	java-pkg-simple_src_install
	java-pkg_dojar value-annotations.jar
}
