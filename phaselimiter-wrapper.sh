#!/bin/bash

if [ X"$TBBROOT" == X ]; then \
    . /opt/intel/oneapi/setvars.sh
fi
phase_limiter.real $@
