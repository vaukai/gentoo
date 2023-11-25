# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit java-pkg-2

DESCRIPTION="sbt is a build tool for Scala and Java projects that aims to do the basics well"
HOMEPAGE="https://www.scala-sbt.org/"
SRC_URI="https://github.com/sbt/sbt/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://repo1.maven.org/maven2/com/chuusai/shapeless_2.12/2.3.3/shapeless_2.12-2.3.3.jar
	https://repo1.maven.org/maven2/com/eed3si9n/gigahorse-core_2.12/0.3.0/gigahorse-core_2.12-0.3.0.jar
	https://repo1.maven.org/maven2/com/eed3si9n/gigahorse-okhttp_2.12/0.3.0/gigahorse-okhttp_2.12-0.3.0.jar
	https://repo1.maven.org/maven2/com/eed3si9n/jarjarabrams/jarjar-abrams-core_2.12/1.8.1/jarjar-abrams-core_2.12-1.8.1.jar
	https://repo1.maven.org/maven2/com/eed3si9n/jarjar/jarjar/1.8.1/jarjar-1.8.1.jar
	https://repo1.maven.org/maven2/com/eed3si9n/sbt-assembly_2.12_1.0/1.2.0/sbt-assembly-1.2.0.jar
	https://repo1.maven.org/maven2/com/eed3si9n/shaded-jawn-parser_2.12/0.9.0/shaded-jawn-parser_2.12-0.9.0.jar
	https://repo1.maven.org/maven2/com/eed3si9n/shaded-scalajson_2.12/1.0.0-M4/shaded-scalajson_2.12-1.0.0-M4.jar
	https://repo1.maven.org/maven2/com/eed3si9n/sjson-new-core_2.12/0.9.0/sjson-new-core_2.12-0.9.0.jar
	https://repo1.maven.org/maven2/com/eed3si9n/sjson-new-scalajson_2.12/0.9.0/sjson-new-scalajson_2.12-0.9.0.jar
	https://repo1.maven.org/maven2/com/github/sbt/pgp-library_2.12/2.1.2/pgp-library_2.12-2.1.2.jar
	https://repo1.maven.org/maven2/com/github/sbt/sbt-pgp_2.12_1.0/2.1.2/sbt-pgp-2.1.2.jar
	https://repo1.maven.org/maven2/com/google/code/findbugs/jsr305/1.3.9/jsr305-1.3.9.jar
	https://repo1.maven.org/maven2/com/google/errorprone/error_prone_annotations/2.0.18/error_prone_annotations-2.0.18.jar
	https://repo1.maven.org/maven2/com/google/errorprone/javac-shaded/9+181-r4173-1/javac-shaded-9+181-r4173-1.jar
	https://repo1.maven.org/maven2/com/google/googlejavaformat/google-java-format/1.6/google-java-format-1.6.jar
	https://repo1.maven.org/maven2/com/google/guava/guava/22.0/guava-22.0.jar
	https://repo1.maven.org/maven2/com/google/j2objc/j2objc-annotations/1.1/j2objc-annotations-1.1.jar
	https://repo1.maven.org/maven2/com/squareup/okhttp3/okhttp/3.7.0/okhttp-3.7.0.jar
	https://repo1.maven.org/maven2/com/squareup/okio/okio/1.12.0/okio-1.12.0.jar
	https://repo1.maven.org/maven2/com/swoval/sbt-java-format_2.12_1.0/0.3.1/sbt-java-format-0.3.1.jar
	https://repo1.maven.org/maven2/com/swoval/sbt-source-format-global_2.12_1.0/0.3.1/sbt-source-format-global-0.3.1.jar
	https://repo1.maven.org/maven2/com/swoval/sbt-source-format-lib_2.12/0.3.1/sbt-source-format-lib_2.12-0.3.1.jar
	https://repo1.maven.org/maven2/com/typesafe/config/1.4.0/config-1.4.0.jar
	https://repo1.maven.org/maven2/com/typesafe/mima-core_2.12/0.8.1/mima-core_2.12-0.8.1.jar
	https://repo1.maven.org/maven2/com/typesafe/sbt-mima-plugin_2.12_1.0/0.8.1/sbt-mima-plugin-0.8.1.jar
	https://repo1.maven.org/maven2/com/typesafe/ssl-config-core_2.12/0.2.2/ssl-config-core_2.12-0.2.2.jar
	https://repo1.maven.org/maven2/de/heikoseeberger/sbt-header_2.12_1.0/5.6.5/sbt-header-5.6.5.jar
	https://repo1.maven.org/maven2/io/get-coursier/interface/0.0.16/interface-0.0.16.jar
	https://repo1.maven.org/maven2/javax/annotation/jsr250-api/1.0/jsr250-api-1.0.jar
	https://repo1.maven.org/maven2/javax/enterprise/cdi-api/1.0/cdi-api-1.0.jar
	https://repo1.maven.org/maven2/javax/inject/javax.inject/1/javax.inject-1.jar
	https://repo1.maven.org/maven2/jline/jline/2.14.6/jline-2.14.6.jar
	https://repo1.maven.org/maven2/org/apache/ant/ant/1.9.9/ant-1.9.9.jar
	https://repo1.maven.org/maven2/org/apache/ant/ant-launcher/1.9.9/ant-launcher-1.9.9.jar
	https://repo1.maven.org/maven2/org/apache/commons/commons-lang3/3.8.1/commons-lang3-3.8.1.jar
	https://repo1.maven.org/maven2/org/apache/maven/maven-artifact/3.3.9/maven-artifact-3.3.9.jar
	https://repo1.maven.org/maven2/org/apache/maven/maven-model/3.3.9/maven-model-3.3.9.jar
	https://repo1.maven.org/maven2/org/apache/maven/maven-plugin-api/3.3.9/maven-plugin-api-3.3.9.jar
	https://repo1.maven.org/maven2/org/bouncycastle/bcpg-jdk15on/1.60/bcpg-jdk15on-1.60.jar
	https://repo1.maven.org/maven2/org/bouncycastle/bcprov-jdk15on/1.60/bcprov-jdk15on-1.60.jar
	https://repo1.maven.org/maven2/org/codehaus/mojo/animal-sniffer-annotations/1.14/animal-sniffer-annotations-1.14.jar
	https://repo1.maven.org/maven2/org/codehaus/plexus/plexus-classworlds/2.5.2/plexus-classworlds-2.5.2.jar
	https://repo1.maven.org/maven2/org/codehaus/plexus/plexus-component-annotations/1.5.5/plexus-component-annotations-1.5.5.jar
	https://repo1.maven.org/maven2/org/codehaus/plexus/plexus-utils/3.0.22/plexus-utils-3.0.22.jar
	https://repo1.maven.org/maven2/org/eclipse/sisu/org.eclipse.sisu.inject/0.3.2/org.eclipse.sisu.inject-0.3.2.jar
	https://repo1.maven.org/maven2/org/eclipse/sisu/org.eclipse.sisu.plexus/0.3.2/org.eclipse.sisu.plexus-0.3.2.jar
	https://repo1.maven.org/maven2/org/ow2/asm/asm/9.2/asm-9.2.jar
	https://repo1.maven.org/maven2/org/ow2/asm/asm-analysis/9.2/asm-analysis-9.2.jar
	https://repo1.maven.org/maven2/org/ow2/asm/asm-commons/9.2/asm-commons-9.2.jar
	https://repo1.maven.org/maven2/org/ow2/asm/asm-tree/9.2/asm-tree-9.2.jar
	https://repo1.maven.org/maven2/org/parboiled/parboiled_2.12/2.1.8/parboiled_2.12-2.1.8.jar
	https://repo1.maven.org/maven2/org/reactivestreams/reactive-streams/1.0.0/reactive-streams-1.0.0.jar
	https://repo1.maven.org/maven2/org/scalactic/scalactic_2.12/3.0.8/scalactic_2.12-3.0.8.jar
	https://repo1.maven.org/maven2/org/scala-lang/modules/scala-parser-combinators_2.12/1.0.5/scala-parser-combinators_2.12-1.0.5.jar
	https://repo1.maven.org/maven2/org/scala-lang/modules/scala-xml_2.12/2.1.0/scala-xml_2.12-2.1.0.jar
	https://repo1.maven.org/maven2/org/scala-lang/scala-compiler/2.12.18/scala-compiler-2.12.18.jar
	https://repo1.maven.org/maven2/org/scala-lang/scala-library/2.12.18/scala-library-2.12.18.jar
	https://repo1.maven.org/maven2/org/scala-lang/scala-reflect/2.12.18/scala-reflect-2.12.18.jar
	https://repo1.maven.org/maven2/org/scalameta/sbt-native-image_2.12_1.0/0.3.1/sbt-native-image-0.3.1.jar
	https://repo1.maven.org/maven2/org/scalameta/sbt-scalafmt_2.12_1.0/2.3.0/sbt-scalafmt-2.3.0.jar
	https://repo1.maven.org/maven2/org/scalameta/scalafmt-dynamic_2.12/2.3.2/scalafmt-dynamic_2.12-2.3.2.jar
	https://repo1.maven.org/maven2/org/scalameta/scalafmt-interfaces/2.3.2/scalafmt-interfaces-2.3.2.jar
	https://repo1.maven.org/maven2/org/scala-sbt/contraband_2.12/0.5.1/contraband_2.12-0.5.1.jar
	https://repo1.maven.org/maven2/org/scala-sbt/sbt-dependency-tree_2.12_1.0/1.9.1/sbt-dependency-tree_2.12_1.0-1.9.1.jar
	https://repo1.maven.org/maven2/org/slf4j/slf4j-api/1.7.25/slf4j-api-1.7.25.jar
	https://repo1.maven.org/maven2/org/typelevel/macro-compat_2.12/1.1.1/macro-compat_2.12-1.1.1.jar
	https://repo.scala-sbt.org/scalasbt/sbt-plugin-releases/com.dwijnand/sbt-dynver/scala_2.12/sbt_1.0/4.0.0/jars/sbt-dynver.jar
	https://repo.scala-sbt.org/scalasbt/sbt-plugin-releases/org.scala-sbt/sbt-contraband/scala_2.12/sbt_1.0/0.5.1/jars/sbt-contraband.jar
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

# Each build with separate java slots requires slightly different deps?
# Either that else I cannot build with jdk:8 / jdk:17
# Locked in jdk:11 as it seems like a sensible default.
DEPEND="virtual/jdk:11"
RDEPEND=">=virtual/jre-1.8:*"

# NOTES FOR BUMPING:
# 1. Remove the deps tarball in SRC_URI.
# 2. Emerge the package without network-sandbox to download all deps.
# 	 	- Ensure you fail before installation if you wish to do so.
# 		- sbt may download more deps when running tests.
# 		- "FEATURES='noclean -network-sandbox test' emerge -v1 dev-java/sbt"
# 3. cd to ${WORKDIR}
# 4. Create the deps tarball:
# 		- "XZ_OPT=-9 tar --owner=portage --group=portage -cJf /var/cache/distfiles/${P}-deps.tar.xz \
# 			.cache/ .ivy2/cache/ .sbt/ sbt-${PV}/target/ivyhome/cache/"
# 5. Undo any temporary edits to the ebuild.

src_compile() {
	local vm_version="$(java-config -g PROVIDES_VERSION)"

	einfo "=== sbt compile with jdk ${vm_version} ==="
	./sbt -Djavac.args="-encoding UTF-8" -Duser.home="${WORKDIR}" compile || die

	einfo "=== sbt publishLocal with jdk ${vm_version} ==="
	./sbt -Djavac.args="-encoding UTF-8" -Duser.home="${WORKDIR}" publishLocal || die
}

src_test() {
	einfo "=== sbt test with jdk ${vm_version} ==="
	./sbt -Djavac.args="-encoding UTF-8" -Duser.home="${WORKDIR}" test || die
}

src_install() {
	# Place sbt-launch.jar at the end of the CLASSPATH
	java-pkg_dojar \
		$(find "${WORKDIR}"/.ivy2/local -name \*.jar -print | grep -v sbt-launch.jar) \
		$(find "${WORKDIR}"/.ivy2/local -name sbt-launch.jar -print)

	local javaags="-Dsbt.version=${PV} -Xms512M -Xmx1536M -Xss1M -XX:+CMSClassUnloadingEnabled"
	java-pkg_dolauncher sbt --jar sbt-launch.jar --java_args "${javaags}"
}
