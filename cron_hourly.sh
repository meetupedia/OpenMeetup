#!/bin/bash

cd `dirname $_`
git pull
/opt/ruby-enterprise/bin/bundle
touch tmp/restart.txt
