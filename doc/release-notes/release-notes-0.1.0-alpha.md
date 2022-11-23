0.1.0-alpha Release Notes
==================

Bitcoin Core on Tails version 0.1.0-alpha is now available from:

  <https://github.com/BenWestgate/Bitcoin-Core-on-Tails>

This release includes only the setup script. Clone & backup features not tested.

Please report bugs using the issue tracker at GitHub:

  <https://github.com/BenWestgate/Bitcoin-Core-on-Tails/issues>

To receive security and update notifications, please subscribe to:

  <https://bitcoincore.org/en/list/announcements/join/>

How to Upgrade
==============

If you are running an older version, shut it down. Wait until it has completely
shut down (which might take a few minutes in some cases), then run the
installer (on Tails) or just copy over or `bitcoind`/`bitcoin-qt` (on Linux).

Compatibility
==============

Bitcoin Core on Tails is supported and extensively tested on Tails OS 5.4+.
Bitcoin Core could also work on most other Unix-like systems but will require
porting. It is not recommended to use on unsupported non-Tails systems.

Notable changes
===============

Initial alpha Release for Internal testing
-----------------------

- Node Setup is working.
- Backup, Clone, Wipe and Update features are untested and/or not working
- Passphrase Management and Sync Faster in the menu are not implemented

Credits
=======

Thanks to everyone who directly contributed to this release:

- Ben Westgate
- JWWeatherman (concept reviews)
