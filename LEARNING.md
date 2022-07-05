# About okd

Openshift templates example

https://github.com/openshift/origin/tree/master/examples

conectar no console by token

## Common commands

oc status

# Get Pod Documentation

# Get built-in documentation for Pods

oc explain pod

# Get details on the pod's spec

oc explain pod.spec

# Get details on the pod's containers

oc explain pod.spec.containers

# Creating Pods from files

# Create a Pod on OpenShift based on a file

cd labs/
oc create -f pods/pod.yaml
oc get pods // checar pods rodando
oc rhs hello-world-po // Acesso shell a pod
[pod_heello_world](images/img9.png)

# Show all currently running Pods

oc get pods

# Watch live updates to pods

oc get pods --watch

# Port forwarding for Pods

# Open a local port that forwards traffic to a pod

oc port-forward <pod name> <local port>:<pod port>

# Example of 8080 to 8080 for hello world

oc port-forward hello-world-pod 8080:8080

# Shell into Pods

# oc rsh will work with any Pod name from oc get pods

oc rsh <pod name>

# In the shell, check the API on port 8080

wget localhost:8080

# Exit the rsh session

exit

# Watch live updates to pods

oc get pods --watch

# Delete (stop) Pods

# Delete any OpenShift resource

oc delete <resource type> <resource name>

# Delete the pod for this section

oc delete pod hello-world-pod

Login

```commandline
oc login -u system:admin
curl -k https://192.168.99.118:8443/oapi/v1/projects -H "Authorization: Bearer
{{TOKEN}}}}"
```

oc new-project
oc new-app
oc

# Get built-in documentation for Pods

oc explain pod

# Get details on the pod's spec

oc explain pod.spec

# Get details on the pod's containers

oc explain pod.spec.containers

# You can use this oc explain command to get info about any of the other fields in a Pod

Esse usuario nao tem permissao no console, ele nao loga
Para criar um usuario adm, voce tem que logar no console web do Openshift com esse usuario
Assim ele sera criado
'''
oc login -u system:admin
oc get users
'''

Agora de permissao

'''
oc adm policy add-cluster-role-to-user cluster-admin "usuario"

oc adm policy add-cluster-role-to-user cluster-admin admin
Saida = clusterrole.rbac.authorization.k8s.io/cluster-admin added: "admin"

'''

# Criar uma configuracao de build

## Deploymentconfig
Define um template para uma pod e gerencia o deploymente de novas imagens ou mudancas de configuracoes.
Uma simples configuracao de deploymente eh normalmente uma analogia a um micro-service.
Pode suportar muitos diferente deploymentes, completa reinicializacao, customizacao de rolling updates,
and completa customizacao de comportamento e tambem pre and post deploymente hooks.
Um deploymente eh engatilhado quando uma configuracao, tag ou ImageStream eh mudada.

### Criar um deployment config vindo de uma inagem
#### Deploy an existing image based on its tag
oc new-app <image tag>

#### Criando o template
oc new-app quay.io/practicalopenshift/hello-world

oc new-app quay.io/practicalopenshift/hello-world --as-deployment-config

Criando um template nomeado 
Set the name using the --name flag

oc new-app <image tag> --name <desired name>

oc new-app quay.io/practicalopenshift/hello-world --name demo-app

The specifier will match your desired name (dc/demo-app in this case)

oc describe dc/demo-app

Agora para rodar essa nova configuracao

oc new-app quay.io/practicalopenshift/hello-world --name demo-app --as-deployment-config
oc new-app quay.io/practicalopenshift/hello-world --name demo-app2 --as-deployment-config

[dois_deployments](/images/img12.png)

oc delete all -l app=name demo-app


##### Check running resources
oc status
[status_container](/images/img11.png)
##### Check pods
oc get pods
[image_pod](/images/img10.png)

oc get svc - service
oc get dc - deploymente config
oc get istag - ImageStream tag

Para apagar tem que usar o comando completo 

oc delete svc/hello-world - servico
oc delete dc/hello-world
oc delete istag/hello-world

oc describe dc/hello-world

Apagando tudo

oc delete all -l app=hello-world 

Primeiro tem que criar a configuracao de build.
A build construira a imagem e carregara o codigo dentro da imagem

Siga o exemplo em

[ngix_example](/yaml-files/new-build-configuration-example.yaml)

Va em build e importe essa configuracao.
Voce pode rodar essa build manualmente.

S2I pegara o codigo e jogara dentro da imagem

O Status ficara invalid-output-reference - Porque estamos usamo a new-image-stream-tag

E a imagem-stream-tag ainda nao foi criada

Va no arquivo de configuracao de build

[ngix_example](/yaml-files/new-build-configuration-example.yaml)

```yaml
  output:
    to:
      kind: ImageStreamTag
      name: 'simple-nginx-docker:latest'
```

Criar uma new Image-stream-tag - copie no nginx (aplicacao) criado:

Builds -> Image Streams - Clique na imagem -> editar YAML, example:

```yaml
apiVersion: image.openshift.io/v1
kind: ImageStream
metadata:
  name: simple-nginx-docker

```

Cheque se sua build esta rodando!
[img.png](images/img.png)

# Trigger Build

Webhook - Tecnica de notificacao de eventos usando o requests http.
Toda vez que alguma alteracao for feita, o git notifica e o openshift roda o deploy

![img_1.png](images/img_1.png)
Criar o link

![img2.png](images/img2.png)

Atencao se o github for local, tem que adicionar o regra no git local para aceitar conexao

# Deployment

Imagem Docker criada + codigo integrado
Deployment pega a imagem criar junto com o codigo da aplicacao e publica no cluster
Siga o exemplo:

[deploy-configuratio](yaml-files/new-nginx-deploy-configuratio.yaml)

Edite - copie - importe as configuracoes
![img4.png](images/img4.png)

# Openshift SDN

Openshift utiliza o SND para prover e gerenciar as conexoes/comunicacao de rede das podes

![img5.png](images/img5.png)

Criando Virtual Networks - Overlay Network -> Default IP range - 10.128.0.0/14
Todas as PODs nesses NODES - tem seu IP e Subrede

NODE 1 NODE 2 NODE 3
10.128.0.0/23 10.128.2.0/23 10.128.4.0/23
WEB APP POD1 DATABASE APP POD1 APP 3 POD1
10.128.0.6 10.128.2.2 10.128.4.?

Para checar o IP

```commandline
og get pods -o wide
```

Conectar via IP nao eh boa idea porque pode mudar

## Openshift DNS Service - SDN Plugins

Open vSwitch - Interconect virtual machin e Hypervisor

- VLAN Tagging
- Trunking
- LACP
- Port Mirroring

Ajudar o a utilizar POD name ou services Internos

- ovs-subnet - prove conectividade de rede entre as PODS
- ovs-multitenant - Previne POD se comunicarem, criando uma unico ID de Rede virtual

Outro Plugins de rede

- nuagenetworks
- Contiv
- flannel

## Openshift Comunicacao Externa

Services e Routes

Service - ajuda a conectar diferente aplicacoes ou grupos de PODs uma com as outras, ao inves de utilizar
IP ou DNS, eh recomendado utilizar services para se conectarem.
Service acessam o Load-Balancer
Front-end fala com o Back-end - Service
Back-end fala com o Banco de dados - Service
Front-end expoe os servicos para usuario finais - Service
Banco de Dados Interno - Banco de Dados Externo - Service

Cada Service tem seu IP e DNS
Cada service tem seu Interno IP assinado- 172.17.0.7 - chamado de Cluster IP

![img.png](images/img6.png)

Como o Service e lincado com a POD -> Usando selector
Selector sao criados atraves do Docker deployment.
"=nome-do-docker"
![img.png](images/img7.png)
Tambem especifica a porta para escutar
Service Porta
E a porta para requiscao -- Target Port

Mas essa porta so eh mapeada na comunicacao interna

Para usuario externo - usa o hostname www.somewebapp.com atraves de uma rota

Rotas:

- Load Balance
- Seguranca
- Split Traffic

Load Balance
Source - Tem a certeza o usuario sempre vai acessar o mesmo back-end service pela direcao
RoundRobin - Cada requisacao e enviada por um caminho diferente, mesmo sendo do mesmo IP e ao mesmo tempo
leastcoon - Escolhe o caminha mais rapido

Segurancao
Prove as definicoes de certificado, tambem definicoes para permitir conexao insegura ou redirect
Certificados e privados keys

Split Traffic
Permiti voce dividir o trafego em dois, supondo que voce tem um ambiente A e B.
![img.png](images/img8.png)

# Expondo a aplicacao para os Usuario

Criaremos um Service - como no exemplo [service-conf](yaml-files/new-nginx-service-configuration.yaml)

```yaml service
apiVersion: v1
kind: Service
metadata:
  name: simple-nginx-docker  //nome do container
spec:
  selector:
  ## Pegue o nome do deployment config label em service
    deploymentconfig: simple-nginx-docker
  ## IP sera adicionado automaticamente, remova linha a baixo
  {{{ clusterIP: 172.30.136.123  }}}
  ## Porta que esta configurado na aplicacao 
  ports:
  - name: 8080-tcp
    port: 8080
    protocol: TCP
    targetPort: 8080
```

Copie e cole criando um novo servico.
Lembre-se que isso eh acesso interno.
Na tela de Service da nova aplicacao, crie uma nota rota no Link.

Se deixar o nome em branco o proprio cluster criara um nome.
Nessa parte seria aonde voce colocaria seu DNS configurado externamente.
Aqui sao as configuracao de redirects, podem ser fonecidas por um YAML

Conceito muito importante que eh sobre multiplas PODS, mesmo com varias PODS a mesma instancia

ROUTE -> STICK - checar configuracao

Por padrao Openshift implemente seu balanceamento.
Para alterar isso:
Routes - Aplicacao - Action - Edit YAML:

adicione=

```yaml
...
metadata:
  annotations:
    haproxy.router.openshift.io/balance: roundrobin
    haproxy.router.openshift.io/disable_cookies: 'true'

```

