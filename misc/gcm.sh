# Alternative to `git-commit -m` that does not require to put the commit message in quotes
#! /usr/bin/env bash
# https://stackoverflow.com/questions/14258491/dont-want-to-use-double-quotes-when-using-git-commit-a-m
exec git commit -m "$*"
