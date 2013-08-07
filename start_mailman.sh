#/bin/bash

nohup rails runner -e production script/mailman.rb >> log/mailman.log &
