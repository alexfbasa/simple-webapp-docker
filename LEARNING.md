# About okd

conectar no console by token
curl -k https://192.168.99.118:8443/oapi/v1/projects -H "Authorization: Bearer
kUG4As0n7mTx8yls9gQfR8tZUVqPgV8ny_Yy6_j3uYY"

oc login -u system:admin

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