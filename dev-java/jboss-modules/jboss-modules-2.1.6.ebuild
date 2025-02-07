# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.jboss.modules:jboss-modules:${PV}.Final"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="JBoss Modules"
HOMEPAGE="https://www.jboss.org/"
SRC_URI="https://github.com/jboss-modules/jboss-modules/archive/${PV}.Final.tar.gz"
S="${WORKDIR}/${P}.Final"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	>=virtual/jdk-11:*
	test? ( dev-java/shrinkwrap-impl-base:0 )
"

# src/main/java/org/jboss/modules/ModuleLoader.java:336
# reason: '<>' with anonymous inner classes is not supported in -source 8
RDEPEND=">=virtual/jre-11:*"

JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR="src/main/java"

JAVA_TEST_EXCLUDES=(
	# Invalid test class 'org.jboss.modules.test.TestClass': 1. No runnable methods
	org.jboss.modules.test.TestClass
	# org.jboss.modules.ModuleLoadException: Error loading module from
	# target/test-classes/test/repo/test/maven/main/module.xml
	# Caused by: org.jboss.modules.xml.XmlPullParserException: Failed to resolve artifact
	# 'org.jboss.resteasy:resteasy-jackson-provider:3.0.4.Final'
	# (position: END_TAG seen ... name="org.jboss.resteasy:resteasy-jackson-provider:3.0.4.Final"/>... @23:84)
	org.jboss.modules.MavenResourceTest
	# Invalid test class 'org.jboss.modules.util.TestModuleLoader': 1. No runnable methods
	org.jboss.modules.util.TestModuleLoader
	# Invalid test class 'org.jboss.modules.util.TestResourceLoader': 1. No runnable methods
	org.jboss.modules.util.TestResourceLoader
	# org.jboss.modules.ModuleLoadException: Error loading module from
	# target/test-classes/test/repo/test/maven/non-main/module.xml
	# Caused by: org.jboss.modules.xml.XmlPullParserException: Failed to resolve artifact
	# 'org.jboss.resteasy:resteasy-jackson-provider:3.0.5.Final'
	# (position: END_TAG seen ... name="org.jboss.resteasy:resteasy-jackson-provider:3.0.5.Final"/>... @23:84)
	org.jboss.modules.MavenResource2Test
	# Invalid test class 'org.jboss.modules.ref.util.TestReaper': 1. No runnable methods
	org.jboss.modules.ref.util.TestReaper
)

JAVA_TEST_GENTOO_CLASSPATH="junit-4,shrinkwrap-impl-base"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"

src_prepare() {
	java-pkg-2_src_prepare
	mkdir -p src/main/resources/org/jboss/modules || die "mkdir"
	sed \
		-e "s/\${project.version}/${PV}.Final/" \
		-e "s/\${project.artifactId}/${PN}/" \
		src/main/java/org/jboss/modules/version.properties \
		> src/main/resources/org/jboss/modules/version.properties || die "set version.properties"
}
