# Docker image
```text
# FROM - use container with APP pre-installed
# COPY - copy our source file into the container
# ENV - set the default environment variables
# RUN - Set permission 
# EXPOSE - Define with port will be running
# LABEL - Openshift picks up this label and creates a services
```
[container_definition](/images/img_2.png)

Rodando um container de teste
docker run -it quay.io/practicalopenshift/hello-world

Esse container vai travar a sessao
