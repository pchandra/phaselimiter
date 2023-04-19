#!/bin/bash

DIR=`dirname "$(realpath ./bin/phase_limiter)"`

if [ X"$TBBROOT" == X ]; then \
    . /opt/intel/oneapi/setvars.sh
fi
$DIR/phase_limiter.real $@
