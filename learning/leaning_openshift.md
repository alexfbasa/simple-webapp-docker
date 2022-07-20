# About okd

Openshift templates example

https://github.com/openshift/origin/tree/master/examples

conectar no console by token

Openshift uses Projects

oc project - check with project you are using
oc new-project myproject - to create a new project
oc project otherproject - swich the project
oc projects - list all the projects available

## Common commands

oc status
oc get pods - Show every pods running in a project

oc rsh - connect inside the pod
oc rsh podname-service-65-xpj72
oc get pods --watch - keeps watching the pods
oc create -f pods/pod.yaml - from file
oc delete pod/name
oc delete pod/hello-world-pod

## Get Pod Documentation

```commandline
oc explain
```

### Get built-in documentation for Pods

oc explain pod

# Get details on the pod's spec

oc explain pod.spec

# Get details on the pod's containers

oc explain pod.spec.containers

# Creating Pods from files

Create a Pod on OpenShift based on a file

```commandline
cd labs/
oc create -f pods/pod.yaml
oc get pods // checar pods rodando
oc rhs hello-world-po // Acesso shell a pod
```

[pod_heello_world](../images/img9.png)

Show all currently running Pods

oc get pods

Watch live updates to pods

oc get pods --watch

## Port forwarding for Pods

Open a local port that forwards traffic to a pod

oc port-forward <pod name> <local port>:<pod port>

Example of 8080 to 8080 for hello world
Crie duas pods:

oc create -f pods/pod.yaml && oc create -f pods/pod2.yaml

Create a pod based on a file (just like the Pods section)
oc create -f pods/pod.yaml

## Services - Create a service for the pod

## Isso ira expor o servico para conexao entre as pods

oc expose --port 8080 pod/hello-world-pod

Check that the service and pod are connected properly
oc status

Create another pod
oc create -f pods/pod2.yaml

Shell into the second pod
oc rsh hello-world-pod-2

Get the service IP and Port
oc status - Para mostrar enderecos de IP e Portas internas

In the shell, you can make a request to the service (because you are inside the OpenShift cluster)
wget -qO- <service IP / Port>

env -- Mostrar as variaveis de uma POD

Use the environment variables with wget
wget -qO- $VARIABLE     
wget -qO- $HELLO_WORLD_POD_PORT_8080_TCP_ADDR:$HELLO_WORLD_POD_PORT_8080_TCP_PORT

svc/hello-world-pod - 172.30.215.212:8080
svc/hello-world-pod-2 - 172.30.133.110:8080

# Exposing a Route

Para criar suas proprias entrandas para exposicao externa suas aplicacoes

oc new-app quay.io/practicalopenshift/hello-world --as-deployment-config
oc status

oc new-app pode ser usado para muitas coisas:
oc new-app --help

Criar aplicacoes pelo docker, buscar imagens, passar variaveis e parametros

```text
svc/hello-world - 172.30.217.68:8080
  dc/hello-world deploys istag/hello-world:latest
    deployment #1 running for 6 seconds - 1 pod
```

oc expose svc/hello-world

```text
route.route.openshift.io/hello-world exposed
```

oc status

```text
http://hello-world-myproject.192.168.99.123.nip.io to pod port 8080-tcp (svc/hello-world)
dc/hello-world deploys istag/hello-world:latest
deployment #1 deployed 3 minutes ago - 1 pod
```

```text
$ curl http://hello-world-myproject.192.168.99.123.nip.io
Welcome! You can change this message by editing the MESSAGE environment variable.
```

## Para pegar o arquivo YAML

oc get -o yaml route

"" Usar para pegar as rotas do servidor ""

```text
  spec:
    host: hello-world-myproject.192.168.99.123.nip.io  -- DNS Externo
    port:
```

oc get -o yaml service
oc get -o yaml pod/hello-world-pod

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

- Deploy Images
- Deploy from Git
- Replication Controllers
- Basic Configuration

### Documentacao

oc explain deploymentconfig.spec

#### Deploy an existing image based on its tag

oc new-app <image tag>
oc new-app quay.io/practicalopenshift/hello-world

Criando um template nomeado
Set the name using the --name flag
oc new-app <image tag> --name <desired name>
oc new-app quay.io/practicalopenshift/hello-world --as-deployment-config --> Isso criara uma imagem de deploy

### Delete deployment configs

oc status
oc get svc --> check os resources rodando, mostra o IP interno e Portas
oc get dc --> mostra os deployment configs
oc get istag --> mostra as ImageStream
oc delete --> voce precisa do nome completo para deletar, use o oc status
oc delete svc/hello-world
oc delete dc/hello-world
oc delete pod/hello-world
Para checar
oc get dc/svc ou pod

```text
Veja a semelhanca, para criar o container no Docker
```

```commandline
docker run -it quay.io/practicalopenshift/hello-world  {mesma imagem}
```

oc status --> Ira mostrar todos os recursos rodando
oc get pods --> Checar as pods rodando
oc get pods -o wide --> Checar IP da POD
oc logs -f pod-name-d9thm container-name INFORMA O NOME DO NO nome.interno.ab

oc describe pod/pod-name-294-cghzc -n cp-projeto === MUITO UTIL

oc get route -n cp-project

### Cleaning UP DeploymentConfig

Use label selector para fazer o clean UP sem precisar deleter um recurso por vez
** Recomendado para fazer clean UP depois de feito o test

Crie uma novo deployment config -- linha 248
Agora cheque a descricao dos servicos
oc status --> pegar o nome correto do DC
oc describe dc/hello-world --> Ira descrever o DeploymentConfig check Labels:

```text
Labels:       deploymentconfig=hello-world
```

Agora delete

```text
$ oc delete all -l app=hello-world
replicationcontroller "hello-world-1" deleted
service "hello-world" deleted
deploymentconfig.apps.openshift.io "hello-world" deleted
route.route.openshift.io "hello-world" deleted

oc status       --> Checar 
```

### Naming Deployments

Criando por uma image existente {quay.io/practicalopenshift/hello-world -- imagem tag}

oc new-app quay.io/practicalopenshift/hello-world --name my-demo-app --as-deployment-config
oc status --> Checar os recursos
oc describe dc/my-demo-app
oc new-app quay.io/practicalopenshift/hello-world --name my-second-demo-app --as-deployment-config
oc delete all -l app=my-demo-app
oc delete all -l app=my-second-demo-app

[dois_deployments](/images/img12.png)

Rodando container direto repositorio

### Deploy from Git using oc new-app

Estamos criando um DeploymentConfig por uma pre deploy build, agora vamos criar
pelo nosso repositorio e criar a nova POD

oc new-app <git repo URL>
oc new-app https://gitlab.com/practical-openshift/hello-world.git --as-deployment-config

Verificar o progresso na construcao da Imagem e POD
oc logs -f bc/hello-world -- bc = build config
oc status --> checar o novo Deploy
oc get pods
oc describe dc/hello-world
oc delete all -l app=hello-world

### Replication controler

oc new-app quay.io/practicalopenshift/hello-world --as-deployment-config
oc get -o yaml dc/hello-world --> Para ter o YAML do Deploy

oc get -o yaml dc/hello-world - Checar o YAML da pod

oc get rc -- checar replica das pods

## Rollou and Roolback version das aplicacoes

Cria p deploy da POD
oc new-app quay.io/practicalopenshift/hello-world -- iniciar a pod
oc get pods --watch -- para monitorar

Sem ter atualizado a imagem
oc rollout latest dc/hello-world

# Roll back to the previous version of the application

Caso voce tenha encontrado um erro e precisa voltar a versao anterior
oc rollback dc/hello-world

##### Check running resources

oc status
[status_container](/images/img11.png)

##### Check pods

oc get pods
[image_pod](/images/img10.png)

### Services

Services prove acesso interno para conexao das pods

Crie duas pods para testar a conexao
oc create -f pod/pod.yaml
oc status -- Pegar o IP interno da POD
oc expose --port 8080 pod/hello-world-pod -- Expose, expoe a porta da pod para conexao Interna
oc create -f pod/pod2.yaml
oc rsh pod/hello-world-2 -- SSH na pod
wget -qO- IP:PORTA_POD

oc status

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
[img.png](../images/img.png)

# Trigger Build

Webhook - Tecnica de notificacao de eventos usando o requests http.
Toda vez que alguma alteracao for feita, o git notifica e o openshift roda o deploy

![img_1.png](../images/img_1.png)
Criar o link

![img2.png](../images/img2.png)

Atencao se o github for local, tem que adicionar o regra no git local para aceitar conexao

# Deployment

Imagem Docker criada + codigo integrado
Deployment pega a imagem criar junto com o codigo da aplicacao e publica no cluster
Siga o exemplo:

[deploy-configuratio](../yaml-files/new-nginx-deploy-configuratio.yaml)

Edite - copie - importe as configuracoes
![img4.png](../images/img4.png)

# Openshift SDN

Openshift utiliza o SND para prover e gerenciar as conexoes/comunicacao de rede das podes

![img5.png](../images/img5.png)

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

![img.png](../images/img6.png)

Como o Service e lincado com a POD -> Usando selector
Selector sao criados atraves do Docker deployment.
"=nome-do-docker"
![img.png](../images/img7.png)
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
![img.png](../images/img8.png)

# Expondo a aplicacao para os Usuario

Criaremos um Service - como no exemplo [service-conf](../yaml-files/new-nginx-service-configuration.yaml)

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

## ConfigMap

Quando voce deploy sua aplicacao em diferente ambientes
Para ambiente local voce deveria usar

```text
                 Environments
                    Development     Production
REST API SERVER     localhost       example-api.com
Database            locahost        db-host.internal.com
```

Creating ConfigMaps

Voce pode criar um ConfigMap usando:

- Argumentos e linhas de comando
- Arquivos com valores de chaves - Nao armazene dados sensiveis no ConfigMap use Secret
- Diretorios e arquivos.
  -- LAB

```commandline
$ oc get configmap --- get all the configMaps
$ oc get -o yaml cm/message-map    -- cm = configmap

```

oc create {type=configmap} {name_resource=message-map} --from-literal MESSAGE="Hello From configMap"
oc create configmap <configmap-name> --from-literal KEY="VALUE"
oc get configmap -- mostra o config map criado --
oc get -o yaml cm/message-map

```text
apiVersion: v1
data:
  MESSAGE: Hello From configMap
kind: ConfigMap
metadata:
  creationTimestamp: "2022-07-06T10:23:37Z"
  name: message-map
  namespace: myproject
  resourceVersion: "31499"
  selfLink: /api/v1/namespaces/myproject/configmaps/message-map
  uid: b2ccc62d-fd15-11ec-9ac2-0800277dfd8f
```

-- LAB - Alterando o configMap por um mapa ja criado
Tenha o mapa da mensagem criado
$ oc new-app quay.io/practicalopenshift/hello-world --as-deployment-config -- criar um app e pod
$ oc expose svc/hello-world -- criar rota para acesso externo
$ oc status -- checar URL

```text
In project My Project (myproject) on server https://192.168.99.125:8443

http://hello-world-myproject.192.168.99.125.nip.io to pod port 8080-tcp (svc/hello-world)

```

curl IP

$ curl http://hello-world-myproject.192.168.99.125.nip.io
Welcome! You can change this message by editing the MESSAGE environment variable -- Valor veio da Imagem

Agora comsumir um configMap do que ja foi criado

$ oc set env dc/hello-world --from cm/message-map -- Isso defini env criado no mapa anterior dentro da imagem
hello-world
$ curl http://hello-world-myproject.192.168.99.125.nip.io  -- Messagem foi alterado por o que vc criou
$ oc get -o yaml dc/hello-world // pegar o deployment configuracao

```text
  - env:
        - name: MESSAGE
          valueFrom:
            configMapKeyRef: 
              key: MESSAGE
              name: message-map  --> Qual o configmap usado

```

-- LAB - Carregar configMap por um arquivo

```commandline
echo "Hello from configMap file" > MESSAGE.txt
oc create configmap file-map --from-file=MESSAGE.txt
---> configmap/file-map created
oc get -o yaml configmap/file-map
```

```text
apiVersion: v1                                              
data:                                                       
  MESSAGE.txt: |                --> WRONG KEY VALUE  -- Pegou o nome do arquivo como chave                                      
    Hello from configMap file   --> MESSAGE                            
kind: ConfigMap                                             
metadata:                                                   
  creationTimestamp: "2022-07-06T22:08:04Z"                 
  name: file-map                                            
  namespace: myproject                                      
  resourceVersion: "201819"                                 
  selfLink: /api/v1/namespaces/myproject/configmaps/file-map
  uid: 1bd72e17-fd78-11ec-9ac2-0800277dfd8f  
```

Passar um nome customizado para a chave

```commandline
oc create configmap file-map-2 --from-file=MESSAGE=MESSAGE.txt
```

```text
apiVersion: v1
data:
  MESSAGE: |                    --> RIGHT KEY VALUE
    Hello from configMap file
kind: ConfigMap
metadata:
  creationTimestamp: "2022-07-06T22:12:14Z"
  name: file-map-2
  namespace: myproject
  resourceVersion: "202825"
  selfLink: /api/v1/namespaces/myproject/configmaps/file-map-2
  uid: b09e2aa2-fd78-11ec-9ac2-0800277dfd8f

```

Definir essa novo mapa para a imagem Hello-World

```commandline
oc set env dc/hello-world --from cm/file-map-2
oc status  --> Pegar endereco da rota e acessar a pagina
curl IP
```

-- LAB - Criando configmap por diretorio

```commandline
cd labs
oc create configmap pods-example --from-file pods  --> todos os arquivo yaml de config e cria um map
oc get -o yaml configmap/pods-example
```

## Secrets

Armazenar privada informacoes

- Credenciais
- Certificados
- Keys
- Informacao de autenticacao
- Autorizacao
- Seguraca

-- LAB - Creating Secrets

Criar uma simples generic (Opaque) Secret - nao tem restricoes, pode ter qualquer valor

oc get secret -- Checar todos os secrets creados
oc create secret generic message-secret --from-literal MESSAGE="Secret Message"
oc create secret generic <secret-name> --from-literal KEY="VALUE"
oc get -o yaml secret/<secret-name>

```text
apiVersion: v1
data:
  MESSAGE: U2VjcmV0IE1lc3NhZ2U=     -- Secret nao eh encriptacao
kind: Secret
metadata:

```

Consume the Secret as Environment Variables
Tenha a POD hello-world rodando com --as-deployment-config
Tenha ela exposta para acesso externo

Almost the same as ConfigMaps
oc set env dc/<dc-name> --from secret/<secret-name>
oc set env dc/hello-world --from secret/message-secret
curl IP
Check the existing Secrets
oc get secret

Check our new Secret
oc get -o yaml secret/message-secret
oc get -o yaml dc/hello-world

oc create: ConfigMap vs. Secret

```text
                      Kind                      Name
ConfigMap = oc create configmap                 message-map --from-literal MESSAGE="Hello From ConfigMap"
                      Kind   Type of Secret     Name
Secret    = oc create secret    generic         message-secret --from-literal MESSAGE="Secret Text"
```

```commandline
oc get -o yaml secret/message-secret
```

```text
apiVersion: v1
data:
  MESSAGE: U2VjcmV0IFRleHQ=
kind: Secret
metadata:
  creationTimestamp: "2022-07-06T23:29:25Z"
  name: message-secret
  namespace: myproject
  resourceVersion: "221541"
  selfLink: /api/v1/namespaces/myproject/secrets/message-secret
  uid: 795006af-fd83-11ec-9ac2-0800277dfd8f
type: Opaque
```

## ImageStreams

ImagenStream - correspondem a nomes como Hello-World ou Goland
ImagenStreamTag - sao as correspondencia de versoes das imagens

ImagenStream prover similar funcionalidade para build docker registry
rodando em sua maquina local.
Image Story dentro do Openshift por que outro typos de recursos podem estar assistindo
ou inscritos nas ImagenStream ou ImageStreanTag para receber notificacoes eles pode agir quando
novas imagem se tornam disponiveis.
Voce pode configurar seu DeploymentConfig para deployar automaticamente a nova versao da imagem
por tag

-- LAB - criando ImagenStream
Tenha a POD hello-world rodando com --as-deployment-config

```text
--> Creating resources ...
    imagestream.image.openshift.io "hello-world" created
    deploymentconfig.apps.openshift.io "hello-world" created
```

oc get is --- Para pegar mais informacoes
oc get imagestream

```text
NAME          DOCKER REPO                             TAGS     UPDATED
hello-world   172.30.1.1:5000/myproject/hello-world   latest   About a minute ago

```

oc get imagestreamtag -- mostra o nome completo da TAG
oc get istag

-- LAB - Criando ImageStreams
Ate agora estamos criando image com o $ oc new-app
$oc import image -- Permite criar a ImagenStream and DeploymentConfig ou qualquer resorce tap

Verifique se nao existem nenhuma imagem rodando
$oc get is
Delete ImageStreams
$oc delete is/hello-world    
$oc get is
```text
No resources found in myproject namespace.
```
Crie ImageStreams mas nao depolya ainda.

oc import-image --confirm <image tag>
ex:                       {{Mesma imagem que estamos usando}}
oc import-image --confirm quay.io/practicalopenshift/hello-world 
Checar detalhes
oc get istag

Descrever uma image especifica   -- Muito util
oc describe istag/hello-world:latest
Rodando a Imagem Importada
oc new-app projectName/ImageName --as-deployment-config
oc new-app myproject/hello-world --as-deployment-config
oc get is

-- LAB - Importando extra ImageStreamTags para uma existente  ImageStream
Tenha uma imagen imprtada e rodando 
oc get is   -- Para checar
oc tag <original> <destino>

Example
oc tag quay.io/image-name:tag image-name:tag
$oc tag quay.io/practicalopenshift/hello-world:update-message hello-world:update-message
$oc get istag      -- Checar nova tag
Check the current ImageStreams and ImageStreamTags


## Importando imagens privadas para o projeto
Estamos rodando imagen publicas sem autenticacao

echo $REGISTRY_USERNAME
cd labs
source credentials.env --> popular as variaveis 
cd hello-world-go-private
echo $REGISTRY_USERNAME
Remote Tag syntax
<host name>/<your username>/<image name>

Load environment variables from credentials.env
source credentials.env

Building an image with a remote tag
docker build -t quay.io/$REGISTRY_USERNAME/private-repo .

Enviando a imagem para o repositorio
Log into a registry
docker login <hostname>

Log into quay.io
docker login quay.io

Push (send) an image to a remote registry
docker push <remote tag>

Push the image to Quay
docker push quay.io/$REGISTRY_USERNAME/private-repo

-- LAB - Usando a imagem privada
The command to import the private image (won't work without extra auth steps)
oc new-app quay.io/$REGISTRY_USERNAME/private-repo --as-deployment-config

# You may need to run this command
source credentials.env

oc create secret docker-registry \
demo-image-pull-secret \
--docker-server=$REGISTRY_HOST \
--docker-username=$REGISTRY_USERNAME \
--docker-password=$REGISTRY_PASSWORD \
--docker-email=$REGISTRY_EMAIL

Create a Docker registry secret
oc secrets link default demo-image-pull-secret --for=pull 
oc describe serviceaccount/default

The same image from the start should work now
oc new-app quay.io/$REGISTRY_USERNAME/private-repo
oc expose service/private-repo
oc status -- checar route
curl IP

## Builds 
Build a Imagem - igual ao comando Docker Build 

-- LAB - Buildando nova imagem
$oc new-build https://gitlab.com/practical-openshift/hello-world.git
$oc get -o yaml buildconfig/hello-world
$oc get builds
$oc get pods    -- Builds rodam Pods tambem

-- LAB - Chegando log das Builds
$oc get build     -- checa a lista de builds
$oc logs -f build/hello-world-1
$oc get buildconfig
$oc logs -f buildconfig/hello-world 

-- LAB - Start builds manualmente por uma build config existente
$oc get pods --watch
$oc start-build bc/hello-world
$oc describe is/hello-world

-- lAB - Cancelar a build manualmente
$oc get pods --watch
$oc start-build bc/hello-world
$oc cancel-build bc/hello-world

## Build Webhooks
Openshift - Expoe HTTPS endpoints que iniciam a build quando sao chamados
Git Repoistory - Chamam o endpoint quando o dev push o codigo

\o/ Dev --> Push cod --> Git Repo --> HTTP --> Webhook listener --> Trigger --> BuildConfig --> Create --> Build

-- LAB - Configurando o Webhook
$oc get -o yaml buildconfig/hello-world
```text
    type: GitHub
  - generic:
      secret: w1akkDcyoiym2C1Ocjj2
```
$export GENERIC_SECRET={{Secret}}
$echo $GENERIC_SECRET
$oc describe bc/hello-world
```text
Webhook Generic:
        URL:            https://192.168.99.125:8443/apis/build.openshi
ft.io/v1/namespaces/myproject/buildconfigs/hello-world/webhooks/<secre
t>/generic
```
$curl -X POST -k URL  --> Curl ira dispara a build
$curl -X POST -k https://192.168.99.125:8443/apis/build.openshift.io/v1/namespaces/myproject/buildconfigs/hello-world/webhooks/$GENERIC_SECRET/generic
$oc get pods --watch

## Building Branches
-- LAB - 

$oc new-build https://gitlab.com/practical-openshift/hello-world.git#update-message
$oc logs -f bc/hello-world

## Buiding Subdirectorios
Quando o repositorio possue multiplos projetos
-- LAB -
$oc get pods --watch
$oc new-build https://gitlab.com/practical-openshift/labs.git --context-dir hello-world-go
$oc logs bc/labs

-- LAB -- 
$oc new-build https://gitlab.com/practical-openshift/hello-world.git
oc status
oc set build-hook bc/hello-world --post-commit --script="echo Hello from build hook"
oc describe dc/hello-world
oc get pods --watch
```text
Post Commit Hook:       ["/bin/sh", "-ic", "echo Hello from build hook
"]
```
oc start-build bc/hello-world
oc logs -f buildconfig/hello-world
```text
Running post commit hook ...
Hello from build hook
```
oc set build-hook bc/hello-world --post-commit --script="exit 1"
oc start-build bc/hello-world
oc logs -f buildconfig/hello-world

removendo a build que falha
oc set build-hook bc/hello-world --post-commit --remove
oc describe bc/hello-world

## Source-to-Image Builds
S2i transforma o codigo fonte da sua aplicacao em container image
Basic S2I Script
Dockerfile Instruction      S2I Script
RUN   <-------------------> Assemble
CMD   <-------------------> RUN
-- LAB - Buildando usando S2I
$cd labs/s2i/ruby 
Nao existe Dockerfile
oc new-app labs --context-dir s2i/ruby --as-deployment-config
oc logs bc/labs
oc get pods
oc status
oc expose svc/labs
oc get route
curl IP

## S2I Auto-deteccao
Como Openshift sabe?
QUando vc start a build Openshift procuro por um Dockerfile
```text
Start ---> Dockerfile? --YES--> Docker Strategy
               |
               NO
       Try to Source Strategy     
```
Source Strategy -- Tenta associar essa imagem por auto-deteccao
![img_s2i_strategy.png](../images/img14.png)

Em nosso caso ele detectou o config.ru e Gemfile

## Explicit Builder Image
-- LAB
oc delete all --all
oc new-app ruby~labs --context-dir s2i/ruby --as-deployment-config  -- LOCAL
oc new-app ruby~https://gitlab.com/practical-openshift/labs.git --context-dir s2i/ruby --as-deployment-config
oc logs bc/labs
oc delete all --all

Rodando errada build
oc new-app python~labs --context-dir s2i/ruby --as-deployment-config
oc new-app python~https://gitlab.com/practical-openshift/labs.git --context-dir s2i/ruby --as-deployment-config
oc logs bc/labs