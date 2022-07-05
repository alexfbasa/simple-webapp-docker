# Jenkins on OpenShift

This repo contains resources used to build a pipeline for building new Jenkins
container image for OpenShift.

https://community.ibm.com/community/user/integration/viewdocument/create-your-integration-application?CommunityKey=77544459-9fda-40da-ae0b-fc8c76f0ce18&tab=librarydocuments

# Building a new image - step by step

* Log in the command line

  ```
  oc login -u system:admin 
  ```

* Create a new project

  ```
  oc new-project jenkins-builder
  ```

* For OKD/Minishift import jenkins-persistent template - for some reasons it's
  missing in newer version (skip it if your cluster already has it)

  ```
  oc apply -f https://raw.githubusercontent.com/openshift/origin/master/examples/jenkins/jenkins-persistent-template.json -n openshift
  ```

* Start a new Jenkins instance

  ```
  oc process -n openshift jenkins-persistent -p MEMORY_LIMIT=1024M|oc apply -f- -n jenkins-builder
  oc set env dc/jenkins \
  OVERRIDE_PV_CONFIG_WITH_IMAGE_CONFIG=true \
  OVERRIDE_PV_PLUGINS_WITH_IMAGE_PLUGINS=true \
  CASC_JENKINS_CONFIG=configuration/jenkins-casc.yaml
  ```

* Assign an admin role to jenkins

  ```
  oc adm policy add-cluster-role-to-user admin -z jenkins
  ```

* Create a pipeline

   ```
   oc process -f jenkins-pipeline-template.yaml|oc apply -f- -n jenkins-builder
   ```

* Run the pipeline job

  ```
  oc start-build build-image-jenkins-master
  ```

  Log in to Jenkins and check the build progress. Approve its promotion to **openshift** project to make it available to other users on your cluster.


* Troubleshoot 

  ```
  "MINISHIFT DENIED ACCESSS - create /etc/vbox/networks.conf"
  * 0.0.0.0/0 ::/0
  * 10.0.0.0/8 192.168.0.0/16
  * 2001::/64

  minishift stop && minishift delete --clear-cache
  minishift delete --force
  minishift start --show-libmachine-logs -v5
  minishift start --docker-opt "add-registry=quay.io" --memory 10000 --cpus 4
  minishift config set cpus 4
  minishift config set memory 8G
  minishift config set image-caching true
  minishift config set vm-driver virtualbox
  
  ```
  
Dicas sobre Readme
https://acervolima.com/o-que-e-o-arquivo-readme-md/