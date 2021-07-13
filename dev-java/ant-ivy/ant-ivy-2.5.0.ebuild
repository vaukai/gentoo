# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom ivy-2.5.0.pom.xml --download-uri https://repo1.maven.org/maven2/org/apache/ivy/ivy/2.5.0/ivy-2.5.0-sources.jar --slot 2 --keywords "~amd64 ~ppc64 ~x86" --ebuild ant-ivy-2.5.0.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.apache.ivy:ivy:2.5.0"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Ivy is a free java based dependency manager"
HOMEPAGE="https://ant.apache.org/ivy/"
SRC_URI="https://downloads.apache.org/ant/ivy/${PV}/apache-ivy-${PV}-src.tar.gz"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="~amd64 ~ppc64 ~x86"

# Common dependencies
# POM: ivy-${PV}.pom.xml
# com.jcraft:jsch:0.1.55 -> >=dev-java/jsch-0.1.54:0
# com.jcraft:jsch.agentproxy:0.0.9 -> !!!artifactId-not-found!!!
# com.jcraft:jsch.agentproxy.connector-factory:0.0.9 -> !!!artifactId-not-found!!!
# com.jcraft:jsch.agentproxy.jsch:0.0.9 -> !!!artifactId-not-found!!!
# org.apache.ant:ant:1.9.14 -> !!!groupId-not-found!!!
# org.apache.commons:commons-vfs2:2.2 -> !!!artifactId-not-found!!!
# org.apache.httpcomponents:httpclient:4.5.9 -> !!!groupId-not-found!!!
# org.bouncycastle:bcpg-jdk15on:1.62 -> >=dev-java/bcpg-1.68:0
# org.bouncycastle:bcprov-jdk15on:1.62 -> >=dev-java/bcprov-1.68:0
# oro:oro:2.0.8 -> >=dev-java/jakarta-oro-2.0.8:2.0

CDEPEND="
	dev-java/ant-core:0
	dev-java/bcpg:0
	dev-java/bcprov:0
	dev-java/commons-httpclient:4
	dev-java/commons-vfs:2
	dev-java/jakarta-oro:2.0
	dev-java/jsch:0
	dev-java/jsch-agent-proxy:0
	test? (
		dev-java/ant-junit:0
		dev-java/ant-junit4:0
		dev-java/ant-junitlauncher:0
		dev-java/ant-testutil:0
		dev-java/hamcrest-core:1.3
		dev-java/hamcrest-library:1.3
		dev-java/xmlunit:1
	)"
DEPEND="${CDEPEND}
	>=virtual/jdk-1.8:*"
RDEPEND="${CDEPEND}
	>=virtual/jre-1.8:*"

DOCS=( LICENSE NOTICE README.adoc )

S="${WORKDIR}/apache-ivy-${PV}"

JAVA_GENTOO_CLASSPATH="commons-httpclient-4,commons-vfs-2,ant-core,jsch,jsch-agent-proxy,bcpg,bcprov,jakarta-oro-2.0"
JAVA_MAIN_CLASS="org.apache.ivy.Main"
JAVA_SRC_DIR="src/java"
JAVA_RESOURCE_DIRS="resources"

JAVA_TEST_GENTOO_CLASSPATH="ant-junit,ant-junit4,ant-junitlauncher,ant-testutil,hamcrest-core-1.3,hamcrest-library-1.3,junit-4,xmlunit-1"
JAVA_TEST_SRC_DIR="test/java"
JAVA_TEST_RESOURCE_DIRS="testresources"
#	JAVA_TEST_EXCLUDES=( )

src_prepare() {
	default
#	java-pkg_clean # Most tests come in jar files

	mkdir --parents "${JAVA_RESOURCE_DIRS}/META-INF" || die
	cp NOTICE LICENSE "${JAVA_RESOURCE_DIRS}/META-INF" || die
	cp -r "${JAVA_SRC_DIR}"/* "${JAVA_RESOURCE_DIRS}" || die
	find "${JAVA_RESOURCE_DIRS}" -type f -name '*.java' -exec rm -rf {} + || die

	mkdir "${JAVA_TEST_RESOURCE_DIRS}" || die
	cp -r "test" "${JAVA_TEST_RESOURCE_DIRS}" || die
	find "${JAVA_TEST_RESOURCE_DIRS}" -type f -name '*.java' -exec rm -rf {} + || die

	# JUnit version 4.13.2-SNAPSHOT
	# Exception in thread "main" java.lang.ExceptionInInitializerError
	#         at java.base/java.lang.Class.forName0(Native Method)
	#         at java.base/java.lang.Class.forName(Class.java:398)
	#         at org.junit.internal.Classes.getClass(Classes.java:42)
	#         at org.junit.internal.Classes.getClass(Classes.java:27)
	#         at org.junit.runner.JUnitCommandLineParseResult.parseParameters(JUnitCommandLineParseResult.java:98)
	#         at org.junit.runner.JUnitCommandLineParseResult.parseArgs(JUnitCommandLineParseResult.java:50)
	#         at org.junit.runner.JUnitCommandLineParseResult.parse(JUnitCommandLineParseResult.java:44)
	#         at org.junit.runner.JUnitCore.runMain(JUnitCore.java:72)
	#         at org.junit.runner.JUnitCore.main(JUnitCore.java:36)
	# Caused by: java.lang.NullPointerException
	#         at java.base/java.io.Reader.<init>(Reader.java:167)
	#         at java.base/java.io.InputStreamReader.<init>(InputStreamReader.java:72)
	#         at org.apache.ivy.plugins.parser.m2.PomModuleDescriptorWriterTest.<clinit>(PomModuleDescriptorWriterTest.java:42)
	#         ... 9 more
	#  * ERROR: dev-java/ant-ivy-2.5.0::gentoo failed (test phase):
	rm test/java/org/apache/ivy/plugins/parser/m2/PomModuleDescriptorWriterTest.java || die

	# JUnit version 4.13.2-SNAPSHOT
	# Exception in thread "main" java.lang.ExceptionInInitializerError
	#         at java.base/java.lang.Class.forName0(Native Method)
	#         at java.base/java.lang.Class.forName(Class.java:398)
	#         at org.junit.internal.Classes.getClass(Classes.java:42)
	#         at org.junit.internal.Classes.getClass(Classes.java:27)
	#         at org.junit.runner.JUnitCommandLineParseResult.parseParameters(JUnitCommandLineParseResult.java:98)
	#         at org.junit.runner.JUnitCommandLineParseResult.parseArgs(JUnitCommandLineParseResult.java:50)
	#         at org.junit.runner.JUnitCommandLineParseResult.parse(JUnitCommandLineParseResult.java:44)
	#         at org.junit.runner.JUnitCore.runMain(JUnitCore.java:72)
	#         at org.junit.runner.JUnitCore.main(JUnitCore.java:36)
	# Caused by: java.lang.NullPointerException
	#         at java.base/java.io.Reader.<init>(Reader.java:167)
	#         at java.base/java.io.InputStreamReader.<init>(InputStreamReader.java:72)
	#         at org.apache.ivy.plugins.parser.xml.XmlModuleDescriptorWriterTest.<clinit>(XmlModuleDescriptorWriterTest.java:53)
	#         ... 9 more
	#  * ERROR: dev-java/ant-ivy-2.5.0::gentoo failed (test phase):
	rm test/java/org/apache/ivy/plugins/parser/xml/XmlModuleDescriptorWriterTest.java || die
}

src_install() {
	default
	java-pkg-simple_src_install
}
