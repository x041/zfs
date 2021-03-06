#!/bin/ksh -p
#
# CDDL HEADER START
#
# This file and its contents are supplied under the terms of the
# Common Development and Distribution License ("CDDL"), version 1.0.
# You may only use this file in accordance with the terms of version
# 1.0 of the CDDL.
#
# A full copy of the text of the CDDL should have accompanied this
# source.  A copy of the CDDL is also available via the Internet at
# http://www.illumos.org/license/CDDL.
#
# CDDL HEADER END
#
# Copyright (c) 2017 Lawrence Livermore National Security, LLC.
#

. $STF_SUITE/include/libtest.shlib
. $STF_SUITE/tests/functional/trim/trim.cfg
. $STF_SUITE/tests/functional/trim/trim.kshlib

#
# DESCRIPTION:
#	A badly formed parameter passed to 'zpool trim' should
#	return an error.
#
# STRATEGY:
#	1. Create an array containing bad 'zpool trim' parameters.
#	2. For each element, execute the sub-command.
#	3. Verify it returns an error.
#

verify_runnable "global"

set -A args "1" "-a" "-?" "--%" "-123456" "0.5" "-o" "-b" "-b no" "-z 2"

log_assert "Execute 'zpool trim' using invalid parameters."
log_onexit cleanup_trim

log_must truncate -s $VDEV_SIZE $VDEVS
log_must zpool create -o cachefile=none -f $TRIMPOOL raidz $VDEVS

typeset -i i=0
while [[ $i -lt ${#args[*]} ]]; do
	log_mustnot zpool trim ${args[i]} $TRIMPOOL
	((i = i + 1))
done

log_must zpool destroy $TRIMPOOL

log_pass "Invalid parameters to 'zpool trim' fail as expected."
