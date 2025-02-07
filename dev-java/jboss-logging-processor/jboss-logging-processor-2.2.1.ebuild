# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.jboss.logging:jboss-logging-processor:${PV}.Final"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="JBoss Logging I18n Annotation Processor"
HOMEPAGE="https://github.com/jboss-logging/jboss-logging-tools"
SRC_URI="https://github.com/jboss-logging/jboss-logging-tools/archive/${PV}.Final.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/jboss-logging-tools-${PV}.Final"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

CP_DEPEND="dev-java/jboss-logging:0"

# processor/src/main/java/org/jboss/logging/processor/model/MessageMethod.java:35:
# error: types DelegatingElement and ExecutableElement are incompatible;
# public interface MessageMethod extends Comparable<MessageMethod>, JavaDocComment, DelegatingExecutableElement {
#        ^
#   interface MessageMethod inherits abstract and default for getEnclosingElement()
#   from types DelegatingElement and ExecutableElement
DEPEND="
	${CP_DEPEND}
	~dev-java/jboss-logging-annotations-${PV}:0
	dev-java/jdeparser:0
	<=virtual/jdk-17:*
"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

JAVA_CLASSPATH_EXTRA="jboss-logging-annotations,jdeparser"
JAVA_RESOURCE_DIRS="processor/src/main/resources"
JAVA_SRC_DIR="processor/src/main/java"
JAVA_TEST_RESOURCE_DIRS="processor/src/test/resources"
JAVA_TEST_SRC_DIR="processor/src/test/java"
