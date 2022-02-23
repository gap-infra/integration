#!/usr/bin/env bash

# Test a GAP package individually

set -e

# TODO: why do we set TERM here? Perhaps due to https://github.com/gap-system/gap/issues/1617 ?
# -> Ask Alex and Thomas about this, and either remove it, or else keep it but then document it
TERM=${TERM:-xterm}

# TODO: should also try to *compile* the package

${GAP_HOME}/bin/gap.sh --quitonbreak -r $@ /home/workspace/pkg-tests.g
