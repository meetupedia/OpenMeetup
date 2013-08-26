#!/bin/bash

if ! pidof -x mailman.rb > /dev/null
then
  cd `dirname $_`
  ./start_mailman.sh
  echo `date` >> log/mailman_restarts.log
fi
