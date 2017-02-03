consul formula
==============

201702 (2017-02-03)
-------------------

- Refactored to make version management easier
- Moved install location from `/usr/bin/consul` to `/usr/local/bin/consul`
- Added an `upgrade` state
- Fixed ordering of install for Testinfra dependency so that tests work on first run

201701 (2017-01-23)
------------------
- Updated service definition to reload instead of restart on conciguration update.

201612 (2016-12-11)
------------------

- Added `enforce_toplevel` to `install_consul_binary` state in order to work properly with v2016.11.0 release of SaltStack.

201605 (2016-05-25)
-------------------

- First release
