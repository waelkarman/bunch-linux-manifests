# Access to local, never-committed secrets (signing keys, passwords, VPN config).
#
# Secrets live in BUNCH_SECRETS_DIR (default: <repo>/secrets, git-ignored).
# Run scripts/gen-secrets.sh to create the ones that can be generated.
#
# A recipe inheriting this class:
#   - finds files in BUNCH_SECRETS_DIR first through FILESEXTRAPATHS,
#     so they can be listed in SRC_URI as plain file:// entries;
#   - lists the files it cannot build without in BUNCH_REQUIRED_SECRETS.
#     If one is missing the recipe is skipped with a message that says
#     which file to create, instead of failing later in do_fetch.

BUNCH_SECRETS_DIR ??= "${TOPDIR}/../secrets"
BUNCH_REQUIRED_SECRETS ??= ""

FILESEXTRAPATHS:prepend = "${BUNCH_SECRETS_DIR}:"

def bunch_secret_exists(d, name):
    import os
    path = os.path.join(d.getVar('BUNCH_SECRETS_DIR'), name)
    # Re-parse the recipe when the file appears or changes.
    bb.parse.mark_dependency(d, path)
    return os.path.isfile(path)

python () {
    missing = [f for f in (d.getVar('BUNCH_REQUIRED_SECRETS') or '').split()
               if not bunch_secret_exists(d, f)]
    if missing:
        raise bb.parse.SkipRecipe(
            "missing secret file(s) %s in %s: see secrets/README.md "
            "(scripts/gen-secrets.sh creates the RAUC keys and hotspot.psk)" % (", ".join(missing), d.getVar('BUNCH_SECRETS_DIR')))
}
