# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.reflections:reflections:${PV}"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Reflections - a Java runtime metadata analysis"
HOMEPAGE="https://github.com/ronmamo/reflections"
SRC_URI="https://github.com/ronmamo/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}"

LICENSE="WTFPL-2 BSD-2"
SLOT="0"
KEYWORDS="~amd64"

CP_DEPEND="
	dev-java/dom4j:1
	dev-java/gson:0
	dev-java/javassist:3
	dev-java/jboss-vfs:0
	dev-java/slf4j-api:0
	dev-java/slf4j-simple:0
"

DEPEND="
	${CP_DEPEND}
	dev-java/javax-servlet-api:2.5
	dev-java/jsr305:0
	>=virtual/jdk-1.8:*
"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

JAVA_CLASSPATH_EXTRA="javax-servlet-api-2.5,jsr305"
JAVA_SRC_DIR="src/main/java"

JAVA_TEST_EXCLUDES=(
	# Upstream does not run this test
	"org.reflections.TestModel"
	# 1) testMethodParameterNames(org.reflections.ReflectionsCollectTest)
	# org.reflections.ReflectionsException: Scanner MethodParameterNamesScanner was not configured
	#         at org.reflections.Store.get(Store.java:39)
	#         at org.reflections.Store.get(Store.java:61)
	#         at org.reflections.Store.get(Store.java:46)
	#         at org.reflections.Reflections.getMethodParamNames(Reflections.java:579)
	#         at org.reflections.ReflectionsTest.testMethodParameterNames(ReflectionsTest.java:239)
	org.reflections.ReflectionsCollectTest
	# 2) testMethodParameterNames(org.reflections.ReflectionsParallelTest)
	# org.reflections.ReflectionsException: Scanner MethodParameterNamesScanner was not configured
	#         at org.reflections.Store.get(Store.java:39)
	#         at org.reflections.Store.get(Store.java:61)
	#         at org.reflections.Store.get(Store.java:46)
	#         at org.reflections.Reflections.getMethodParamNames(Reflections.java:579)
	#         at org.reflections.ReflectionsTest.testMethodParameterNames(ReflectionsTest.java:239)
	org.reflections.ReflectionsParallelTest
	# 3) testMethodParameterNames(org.reflections.ReflectionsTest)
	# org.reflections.ReflectionsException: Scanner MethodParameterNamesScanner was not configured
	#         at org.reflections.Store.get(Store.java:39)
	#         at org.reflections.Store.get(Store.java:61)
	#         at org.reflections.Store.get(Store.java:46)
	#         at org.reflections.Reflections.getMethodParamNames(Reflections.java:579)
	#         at org.reflections.ReflectionsTest.testMethodParameterNames(ReflectionsTest.java:239)
	org.reflections.ReflectionsTest
	#
	# https://github.com/ronmamo/reflections/issues/277#issuecomment-927152981
	# scanner was not configured exception - this is a known issue in 0.9.12, a simple workaround is to
	# check if the getStore() contains index for the scanner before querying. next version 0.10 fixes this.
)

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"
