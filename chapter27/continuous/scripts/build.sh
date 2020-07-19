#!/bin/bash

set -x

pwd

if [[ ${CODEBUILD_WEBHOOK_TRIGGER} = 'branch/master' ]]; then
    ${CODEBUILD_SRC_DIR}/chapter27/continuous/scripts/apply.sh
else
    ${CODEBUILD_SRC_DIR}/chapter27/continuous/scripts/plan.sh
fi
