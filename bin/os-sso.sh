#!/bin/sh
if [ $# -lt 1 ]
then
  echo "Usage: $0 -m [create | delete]"
  exit 1
fi

getopts m: opt

if [ ${OPTARG} = "create" ]
then
  oc login -u system admin
  oc project openshift
  oc create -f files/jboss-images-streams.json -n openshift
  oc login -u developer -p whatever
  oc new-project sso-poc
  oc project sso-poc
  oc create -n sso-poc -f files/sso-app-secret.json
  oc process -f files/sso71-https.json -p HTTPS_NAME=jboss -p HTTPS_PASSWORD=mykeystorepass -p SSO_ADMIN_USERNAME=admin -p SSO_ADMIN_PASSWORD=admin | oc create -n sso-poc -f -
else
  oc login -u developer -p whatever
  oc project sso-poc
  oc delete all -l application=sso
fi
