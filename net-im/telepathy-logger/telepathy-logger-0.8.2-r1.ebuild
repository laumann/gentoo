# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
GCONF_DEBUG="no"
PYTHON_COMPAT=( python3_{7..9} )

inherit epatch gnome2 python-any-r1 virtualx

DESCRIPTION="Daemon that centralizes the communication logging within the Telepathy framework"
HOMEPAGE="https://telepathy.freedesktop.org/wiki/Logger"
SRC_URI="https://telepathy.freedesktop.org/releases/${PN}/${P}.tar.bz2
	https://gitlab.freedesktop.org/telepathy/telepathy-logger/-/merge_requests/1.patch
		-> ${P}-py3.patch"

LICENSE="LGPL-2.1+"
SLOT="0/3"
KEYWORDS="~alpha amd64 ~arm arm64 ~ia64 ~ppc ~ppc64 ~sparc x86 ~x86-linux"
IUSE="+introspection"

RDEPEND="
	>=dev-libs/glib-2.28:2
	>=sys-apps/dbus-1.1
	>=dev-libs/dbus-glib-0.82
	>=net-libs/telepathy-glib-0.19.2[introspection?]
	dev-libs/libxml2
	dev-libs/libxslt
	dev-db/sqlite:3
	introspection? ( >=dev-libs/gobject-introspection-0.9.6 )
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	dev-util/glib-utils
	>=dev-util/gtk-doc-am-1.10
	>=dev-util/intltool-0.35
	virtual/pkgconfig
"

src_prepare() {
	epatch "${DISTDIR}"/${P}-py3.patch
	gnome2_src_prepare
}

src_configure() {
	# --enable-debug needed due to https://bugs.freedesktop.org/show_bug.cgi?id=83390
	gnome2_src_configure \
		$(use_enable introspection) \
		--enable-debug \
		--enable-public-extensions \
		--disable-coding-style-checks \
		--disable-Werror \
		--disable-static
}

src_test() {
	virtx emake -j1 check
}
