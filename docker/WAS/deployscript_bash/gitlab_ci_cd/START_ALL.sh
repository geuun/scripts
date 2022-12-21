#!/bin/bash

bash ./script_deploy/001_SET_ENV.sh
bash ./script_deploy/002_APP_IMAGE_PULL.sh
bash ./script_deploy/003_APP_RUN.sh
bash ./script_deploy/004_SET_CRONTAB.sh