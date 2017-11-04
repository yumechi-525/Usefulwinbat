#!/bin/sh
git branch --merged master | grep -vE '^\*|master$' | xargs -I % git branch -d %
