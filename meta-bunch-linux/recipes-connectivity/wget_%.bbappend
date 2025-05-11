PACKAGECONFIG += "gnutls pcre zlib iri ares \
                   ${@bb.utils.filter('DISTRO_FEATURES', 'ipv6', d)}"
