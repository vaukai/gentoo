# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://codeload.github.com/assertj/assertj-core/tar.gz/assertj-core-3.22.0 --slot 2 --keywords "~amd64 ~arm ~arm64 ~ppc64 ~x86" --ebuild assertj-core-3.22.0.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.assertj:assertj-core:3.22.0"
# No tests because we don't have this framework.
# JAVA_TESTING_FRAMEWORKS="junit-vintage"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Rich and fluent assertions for testing for Java"
HOMEPAGE="https://assertj.github.io/doc/assertj-core/"
SRC_URI="https://github.com/assertj/assertj-core/archive/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

# Common dependencies
# POM: pom.xml
# net.bytebuddy:byte-buddy:1.12.6 -> >=dev-java/byte-buddy-1.12.8:0

CP_DEPEND="dev-java/byte-buddy:0"

# Compile dependencies
# POM: pom.xml
# junit:junit:4.13.2 -> >=dev-java/junit-4.13.2:4
# org.hamcrest:hamcrest:2.2 -> >=dev-java/hamcrest-2.2:0
# org.junit.jupiter:junit-jupiter-api:5.8.2 -> !!!groupId-not-found!!!
# org.opentest4j:opentest4j:1.2.0 -> >=dev-java/opentest4j-1.2.0:0
# POM: pom.xml
# test? com.fasterxml.jackson.core:jackson-databind:2.13.1 -> >=dev-java/jackson-databind-2.13.3:0
# test? com.google.guava:guava:31.0.1-jre -> !!!suitable-mavenVersion-not-found!!!
# test? commons-io:commons-io:2.11.0 -> >=dev-java/commons-io-2.11.0:1
# test? nl.jqno.equalsverifier:equalsverifier:3.8.1 -> !!!groupId-not-found!!!
# test? org.apache.commons:commons-collections4:4.4 -> >=dev-java/commons-collections-4.4:4
# test? org.apache.commons:commons-lang3:3.12.0 -> >=dev-java/commons-lang-3.12.0:3.6
# test? org.eclipse.platform:org.eclipse.osgi:3.17.100 -> !!!groupId-not-found!!!
# test? org.hibernate.orm:hibernate-core:6.0.0.Beta3 -> !!!groupId-not-found!!!
# test? org.junit.jupiter:junit-jupiter:5.8.2 -> !!!groupId-not-found!!!
# test? org.junit.platform:junit-platform-testkit:1.8.2 -> !!!groupId-not-found!!!
# test? org.junit.vintage:junit-vintage-engine:5.8.2 -> !!!groupId-not-found!!!
# test? org.mockito:mockito-core:4.2.0 -> >=dev-java/mockito-4.6.1:4
# test? org.mockito:mockito-junit-jupiter:4.2.0 -> !!!artifactId-not-found!!!
# test? org.springframework:spring-core:5.3.14 -> !!!groupId-not-found!!!

DEPEND="
	>=virtual/jdk-11:*
	${CP_DEPEND}
	dev-java/apiguardian-api:0
	dev-java/hamcrest:0
	dev-java/junit:4
	dev-java/junit:5
	dev-java/opentest4j:0"
#	test? (
#		!!!artifactId-not-found!!!
#		!!!groupId-not-found!!!
#		!!!suitable-mavenVersion-not-found!!!
#		>=dev-java/commons-collections-4.4:4
#		>=dev-java/commons-io-2.11.0:1
#		>=dev-java/commons-lang-3.12.0:3.6
#		>=dev-java/jackson-databind-2.13.3:0
#		>=dev-java/mockito-4.6.1:4
#	)
#"

RDEPEND="
	>=virtual/jre-1.8:*
	${CP_DEPEND}"

S="${WORKDIR}/assertj-assertj-core-${PV}"

# Do not add junit-4 here.
# The eclass would put it "--with-dependencies" which we do not want.
JAVA_CLASSPATH_EXTRA="
	apiguardian-api
	hamcrest
	junit-5
	opentest4j
"

JAVA_SRC_DIR=( src/main/java{,9} )

#	JAVA_TEST_GENTOO_CLASSPATH="jackson-databind,!!!suitable-mavenVersion-not-found!!!,commons-io-1,!!!groupId-not-found!!!,commons-collections-4,commons-lang-3.6,!!!groupId-not-found!!!,!!!groupId-not-found!!!,!!!groupId-not-found!!!,!!!groupId-not-found!!!,!!!groupId-not-found!!!,mockito-4,!!!artifactId-not-found!!!,!!!groupId-not-found!!!"
#	JAVA_TEST_SRC_DIR="src/test/java"
#	JAVA_TEST_RESOURCE_DIRS=(
#		"src/test/resources"
#	)

src_prepare() {
	default
	# hamcrest does not provide module-info
	sed \
		-e '/org.hamcrest/d' \
		-i src/main/java9/module-info.java || die
}

src_compile() {
	# We want junit-4 on classpath but without dependencies:
	# https://github.com/assertj/assertj/blob/assertj-core-3.22.0/pom.xml#LL314
	JAVA_GENTOO_CLASSPATH_EXTRA="$(java-pkg_getjars --build-only junit-4)"
	java-pkg-simple_src_compile
}
