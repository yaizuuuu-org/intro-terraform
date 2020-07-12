#!/bin/bash

NAME=''
VALUE=''
TYPE=''
TYPE_STRING=''
IS_GET=false
PROFILE='default'
OVERWRITE=''

usage() {
    echo "sh put_parameter.sh -n NAME -v VALUE [-t TYPE<string|secure-string>]" 1>&2
}

while getopts ":n:v:t:go" OPT
do
    case $OPT in
        "n") NAME=$OPTARG;;
        "v") VALUE=$OPTARG;;
        "t") TYPE=$OPTARG;;
        "g") IS_GET=true;;
        "p") PROFILE=$OPTARG;;
        "o") OVERWRITE='--overwrite';;
          *) exit 1 ;;
    esac
done

shift $(($OPTIND - 1))

if [[ -z ${NAME} || -z ${VALUE} ]]; then
    usage
    exit 1
fi

if [[ -z ${TYPE} || ${TYPE} = "string" ]]; then
    TYPE_STRING='String'
elif [[ ${TYPE} = "secure-string" ]]; then
    TYPE_STRING='SecureString'
else
    usage
    exit 1
fi

if ${IS_GET} ; then
    aws --profile ${PROFILE} ssm get-parameter --name ${NAME} --output text --query Parameter.Value
else
    aws --profile ${PROFILE} ssm put-parameter --name ${NAME} --value "${VALUE}" --type ${TYPE_STRING} ${OVERWRITE}
fi
