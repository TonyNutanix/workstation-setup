#!/bin/bash
########################################
# 06252025: Refresh the local copy of the repo and overwrite any local changes
#
########################################
git fetch --all
git branch backup-main
git reset --hard origin/main