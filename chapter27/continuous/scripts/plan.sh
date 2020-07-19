#!/bin/bash

cd ${CODEBUILD_SRC_DIR}/chapter27/continuous

pwd

terraform init -imput=false -no-color
terraform plan -input=false -no-color

tfnotify --config ${CODEBUILD_SRC_DIR}/chapter27/continuous/tfnotify.yml plan --message "$(date)"