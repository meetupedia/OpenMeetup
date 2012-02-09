#!/bin/bash

rsync -rptzL --stats --progress --exclude-from=deploy.exclude -e 'ssh -p 30000' . nagybence@tipogral.hu:/var/www/kaffa
ssh -p 30000 nagybence@tipogral.hu /var/www/kaffa/restart.sh
