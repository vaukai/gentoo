# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# No tests, 
JAVA_PKG_IUSE="doc source"
MAVEN_ID="jakarta.servlet:jakarta.servlet-api:6.1.1"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="API for Jakarta Servlet"
HOMEPAGE="https://projects.eclipse.org/projects/ee4j.servlet"
SRC_URI="https://github.com/jakartaee/servlet/archive/${PV}-RELEASE-tck.tar.gz -> ${P}-RELEASE-tck.tar.gz"
S="${WORKDIR}/servlet-${PV}-RELEASE-tck"

LICENSE="EPL-2.0 GPL-2-with-classpath-exception"
SLOT="6.1"
KEYWORDS="~amd64 ~arm64 ~ppc64"

DEPEND=">=virtual/jdk-11:*" # module-info
RDEPEND=">=virtual/jre-1.8:*"

DOCS=( {CONTRIBUTING,NOTICE,README}.md )

JAVA_RESOURCE_DIRS="api/src/main/resources"
JAVA_SRC_DIR="api/src/main/java"

src_prepare() {
	java-pkg-2_src_prepare
	pushd api/src/main/java > /dev/null || die
		find -type f -name '*.properties' \
			| xargs cp --parents -t ../resources || die
	popd > /dev/null || die
}
