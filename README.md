# Installing RedHat SSO on minishift

This repository contains a step by step explanation to get RedHat SSO running on minishift. Furthermore it contains a very basic script that creates or deletes a Redhat SSO Deployment.

## Manual steps

Run your minishift application.

1. Set the oc-env specific environment variables.
```
eval $(minishift oc-env)
```
2. Login using system:admin (certificate based login).
```
oc login -u system:admin
```
3. Change to project _openshift_.
```
oc project openshift
```
All the used files below are based on the repository: https://github.com/jboss-openshift/application-templates
For your convenience they are provided in */files* directory in this repository.

4. Import image streams.
```
oc create -f files/jboss-images-streams.json -n openshift
```
5. Change to _developer_ user.
```
oc login -u developer -p whatever
```
6. Create a new test project. However you may also use any existing project though.
```
oc new-project sso-poc
```
7. Create the sso secrets.
```
oc create -n sso-poc -f sso-app-secret.json
```
8. Create the sso Template and start Deployment. This template has slightly changed. Due to some issues when starting wildfly (because of errors related to Dockers layered architecture) we are using a persistent volume claim. Furthermore the image `redhat-sso71-openshift:1.2` is used. 
```
oc process -f sso71-https.json -p HTTPS_NAME=jboss -p HTTPS_PASSWORD=mykeystorepass | oc create -n sso-poc -f -
```
You may also want to set the SSO_ADMIN_USERNAME SSO_ADMIN_PASSWORD variables to your preferred values.
```
oc process -f sso71-https.json -p HTTPS_NAME=jboss -p HTTPS_PASSWORD=mykeystorepass -p SSO_ADMIN_USERNAME=admin -p SSO_ADMIN_PASSWORD=admin | oc create -n sso-poc -f -
```

Use `oc delete all -l application=sso` to delete the create RedHat SSO environment.

## Script
The script is currently not more than very basic stuff. You can run the creation presented above at once using

```
./bin/os-sso.sh -m create
```

and delete everything using

```
./bin/os-sso-sh -m delete
```
