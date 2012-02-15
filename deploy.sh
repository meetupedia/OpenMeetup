#!/bin/bash

rsync -rptzL --stats --progress --exclude-from=deploy.exclude -e 'ssh -p 30000' . nagybence@tipogral.hu:/var/www/openmeetup
ssh -p 30000 nagybence@tipogral.hu /var/www/openmeetup/restart.sh
