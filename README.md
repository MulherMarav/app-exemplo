# Docker - Containers

* Por que são mais leves? 
    * Porque o sistema SO é dividido em processos que são containers e não uma virtualização completa de um SO.
* Como garantem o isolamento?
    * Porque são processos isolados, com namespaces, garantem o isolamento em determinados níveis/diversas camadas.
    * PID = isolamento de nível dentro dos processos 
    * NET = isolamento de rede de cada processo
    * IPC = intercomunicação entre cada um dos processos 
    * MNT = que são sistema de arquivos, montagem, volumes e afins, devidamente isolado.
    * UTS = faz compartilhamento e isolamento ao mesmo tempo dos containers com o nosso kernel (SO principal ou host)
* Como funcionam sem “instalar um SO”?
    * Por conta dos namespaces
    * UTS = faz compartilhamento e isolamento ao mesmo tempo dos containers com o nosso kernel (SO principal ou host)
* Como fica a divisão de recursos do sistema?
    * Por conta dos Cgroups
    * De maneira automática ou manual podemos definir o consumo máximo de memória, de CPU e afins de cada um dos processos/containers

* Máquinas virtuais possuem camadas adicionais de virtualização em relação a um container;
* Containers funcionam como processos no host;
* Containers atingem isolamento através de namespaces;
* Os recursos dos containers são gerenciados através de cgroups.
* Para consultar imagens existentes, consultar: https://hub.docker.com/

## CONTAINER

* docker run [imagem] = baixa e roda a imagem do host
* docker pull [imagem] = apenas baixa a imagem do host
* docker ps = lista os containers em execução
* docker container ls = lista os containers em execução de forma mais verbosa
* docker ps -a = para saber os containers que já executaram 
* docker container ls -a = para saber os containers que já executaram  de forma mais verbosa
* docker run [imagem] [comando] = rodar o container com um comando, exemplo ‘docker run ubuntu sleep 1d’
* docker stop [id_container ou name] = para a execução do container 
* docker start [id_container ou name] = voltar a execução do container
* docker exec -it [id_container ou name] bash = para executar o terminal do container
* top = para mostrar os processos em execução dentro do ubuntu
* Ctrl + L e Ctrl + D = para execução e do terminal do container 
* docker pause [id_container ou name] = para pausar o container 
* docker unpause [id_container ou name] = para despausar o container 
* docker stop -t=0 [id_container ou name] = para a execução do container de imediato, sem o tempo padrão de 10s
* docker rm [id_container ou name] = para remover o container
* docker run -it [imagem] bash = executar o container de modo interativo sem precisar do comando ‘sleep’

Comando Linux para criar arquivo
- touch eu-sou-um-arquivo.txt
Para listar e update ou install
- ls
- apt-get update/install

## PORTA

* docker run dockersamples/static-site = não é uma imagem oficial do docker, é mais visual para vermos todo o fluxo do container. Esse comando trava o terminal igual o comando sleep
* docker run -d dockersamples/static-site = para manter o comando em background no terminal e manter o terminal em execução sem travar, usamos o comando -d de detached.
* /bin/sh -c ‘cd/usr…” = mantem o terminal em execução. Ocorre um isolamento das interfaces de rede por conta do Namespace NET, o comando localhost:8080 não funciona na rede local do nosso host
* docker rm [id_container ou name] —force = parar e remover o container de uma vez só
* docker run -d -P dockersamples/static-site = ele não faz o download porque já houve anteriormente e ele faz um mapeamento de port, que pode ser confirmado pelo comando docker ps
* docker port [id_container ou name] = mostra o mapeamento de portas deste container em relação ao host. O comando mostra que que a porta 8080 foi mapeada para 49154 do host, que no caso é o localhost. Podemos acessar no browser porque fizemos o mapeamento do host do container para o nosso host local
* docker run -d -p 8080:80 dockersamples/static-site = com este comando conseguimos fazer um mapeamento de uma porta especifica do host local, que deve refletir em uma porta específica do container

- Este cenário é muito interessante quando queremos testar o funcionamento e como uma aplicação está interagindo com outras

IMAGEM

* docker images ou docker image ls = ver as imagens baixadas, quando foi criada e o tamanho 
* docker inspect [id_container ou name] = diversas informações sobre a imagem 
* docker history [id_container ou name] = para visualizar as canadas da imagem que forma a imagem final, 

- As imagens finais são read only, isso significa que não conseguimos modificar as camadas dessa imagem depois que ela foi criada, pois são imutáveis. O container nada mais é do que uma imagem com uma camada adicional de read-write, de leitura e escrita. Então quando criamos um container nós criamos uma camada temporária em cima da imagem, onde conseguimos escrever informações. E no momento em que esse container é deletado, essa camada extra também é deletada. Como por exemplo o terminal do Ubuntu no container, que é possível criar arquivos dentro dele. 
- Entendemos porque efetivamente o container é tão leve e otimizado. Porque ele consegue reaproveitar as camadas das imagens prévias que já temos. E quando criamos novos containers ele simplesmente só reutiliza as mesmas imagens e camadas, consequentemente, e utiliza a camada de read-write para utilizar de maneira mais performática o que ele já tem no ecossistema do Docker.
- Porque como a imagem é apenas de leitura, nós podemos ter um, dois, 100 ou 10 mil containers baseados na mesma imagem. A diferença é que cada um desses containers vai ter só uma camada diferente de um para o outro de read-write.

* docker build -t [etiqueta]/[nome da aplicação]:[versão] . = build e criação de uma imagem a partir de um arquivo Dockerfile, dentro do diretório da aplicação
* Referencia para criação de imagens no Dockerfile: https://docs.docker.com/engine/reference/builder/
* docker run -d -p 8080:3000 [etiqueta]/[nome da aplicação]:[versão] . = expor a aplicação em uma porta de rede no host local
* docker stop $(docker container ls -q) = parar todos containers de uma vez. A flag –q, de quiet, pega somente o ID dos containers
* docker run -p 8080:3000 -d danielartine/app-node:1.0 = mostrando o mapeamento de portas que estamos fazendo graças à flag -p. Mas e se eu executar esse mesmo container sem fazer o -p e colocar só o -d, não será nada exibido na coluna de portas ao dar o comando docker ps.
* docker login -u [nome do usuário no DockerHub] = fazer login no dockerhub para fazer deploy de imagens
* docker tag [etiqueta]/[nome da aplicação]:[versão] [etiqueta nova]/[nome da imagem nova]:[versão] = copiar uma imagem existente, e  a partir dessa imagem criar uma nova tag e imagem para enviar ao dockerhub. O ID das imagens serão os mesmos, mas terão repositórios diferentes
*  docker push [etiqueta nova]/[nome da imagem nova]:[versão] 
* Se fizemos um novo push de uma versão mais recente da imagem, o docker saberá que houve envio anteriormente e irá reaproveitar algumas camadas já existentes. Docker Hub é capaz de reutilizar as camadas já existentes também no nosso repositório remoto.


Fluxo do docker run
- procura a imagem localmente -> Baixa a imagem caso não encontre localmente -> Valida o hash da imagem -> Executa o container

##  PERSISTÊNCIA DE DADOS / VOLUMES

* docker container rm $(docker container ls –aq) = para remover todos os containers de uma vez. Na flag -aq, o q é para pegarmos somente os IDs e o -a é para pegar todos os containers, inclusive os que estão parados
* docker rmi $(docker image ls –aq) = para remover todas as imagens, inclusive as paradas. Haverá conflito se a imagem estiver sendo utilizada em múltiplos repositórios. 
* docker rmi $(docker image ls –aq) --force = necessário para remover todas as imagens, incluindo as paradas e as que estão sendo utilizadas em múltiplos repositórios. 
* docker run –it ubuntu = iniciar um container do Ubuntu em modo interativo
* docker container ls –s =  irá surgir uma coluna extra. Nessa coluna ele fala que o tamanho desse container é 0B, mas o tamanho virtual dele é 72.8 MB
* docker history ubuntu = irá mostrar que a imagem é composta por duas camadas, uma de 0B e outra de 72.8MB
* apt-get update = dentro do terminal do Ubuntu, rodar esse comando. Para fazer algumas operações dentro do container para ver o que vai começar a acontecer com aquele tamanho inicialmente. 
* docker ps –s = ao fazer este comando de novo o size do container já está em 32.1MB. O tamanho virtual do container é o mesmo anteriormente, mudou apenas o tamanho do size. Então essa informação na coluna de size nada mais é do que as informações que estão agora na camada de read-write. São informações a princípio temporárias. Essa camada não é persistente, sempre que criar um novo container, as informações na camada read-write irão sumir.
 
Existem três possibilidades para persistência de dados 
* Bind Mounts = uma ligação entre um ponto de montagem do nosso sistema operacional e algum diretório dentro do container.
* docker run –it –v /[diretório]/volume-docker:/app ubuntu bash = dentro do container eu terei um diretório chamado “/app”, e tudo que for gravado dentro desse diretório será persistido nesse diretório no meu host no volume-docker. Conseguimos agora persistir informações entre containers. Caso um container pare de funcionar de alguma maneira e queiramos persistir os dados que estejam lá, já conseguimos fazer isso agora, e de maneira a princípio prática.
* Além da flag -v, é recomendado utilizar a flag --mount, como o exemplo a seguir.
* docker run –it --mount type=bind,source=/[diretório]/volume-docker,target=/app ubuntu bash
* docker volume ls = volumes é o mais recomendado pelo docker para ser utilizado na persistência de dados, a utilização de volumes é uma área gerenciada pelo Docker dentro do seu file system. As informações continuem dentro do nosso host original para ser persistidas, nós teremos uma área que o Docker vai gerenciar e é muito mais segura, porque será gerenciada pelo próprio Docker.
* docker volume create [nome do volume] = comando para criar um volume.
* docker run –it –v [nome do volume]:/app ubuntu bash = O volume, e ele será mapeado nesse diretório “/app” dentro do container.
*  sudo su = entrar super usuário 
* “/var/lib/docker/” = Este diretório é onde o Docker está realmente na nossa máquina. Não o Docker em si, mas diversas informações que ele armazena na nossa máquina.
* cd volumes/ = os volumes dos docker ficam neste diretório
* Gerenciar esses volumes agora através da interface do Docker. Não ficamos 100% dependentes do nosso sistema de arquivos do nosso sistema operacional. Isso é muito interessante, porque agora não dependemos diretamente de uma estrutura de pastas específicas do nosso sistema operacional. Ele estará sempre nesse diretório de volumes.
* docker run -it --mount source=[nome do volume] target=/app ubuntu bash = podemos criar um volume automaticamente apenas com este comando, sem precisar dar o create
* Os tmpfs só funcionam em ambientes host Linux
* docker run –it --tmpfs=/app ubuntu bash = a pasta “/app” é temporária. Então ela está sendo escrita na memória do nosso host.
*  A ideia do tmpfs é basicamente persistir dados na memória do seu host, mas esses dados não estão sendo escritos na camada de read-write. Eles estão sendo escritos diretamente na memória do host. Isso é importante, por exemplo, quando temos algum dado sensível que não queremos persistir na camada de read-write por questões de segurança talvez, mas queremos tê-los dentro de alguma maneira. Nesses casos podemos utilizar o tmpfs. Por exemplo, arquivos de senha ou algum arquivo que você não quer carregar durante a execução como um todo e manter na camada de escrita
* docker run –it --mount type=tmpfs,detination=/app ubuntu bash = outra forma de persistir dados

## COMUNICAÇÃO ENTRE REDES

* docker inspect [ID do container] = irá aparecer diversos detalhes. Dentro dessas diversas informações tem a parte de networks, de redes. E dentro desse conjunto de redes ele tem uma chamada bridge que tem diversas configurações. Se compararmos dois containers criados na mesma máquina, todos esses pontos dentro do nosso sistema no bridge, exceto o endpoint ID e o IP address, são iguais. Por quê? Isso significa então que esses containers no fim das contas estão na mesma rede.
* docker network ls = ele mostra três redes para nós, uma se chama bridge, que tem seu ID, o driver bridge, e um escopo local. Tem uma que se chama host, que usa o driver host e o escopo também é local. E no fim das contas também temos uma última, que se chama none, que poderíamos não colocar nenhuma rede dentro do nosso container.

* Isso significa que os nossos dois containers que criamos sem definir nenhuma rede foram colocados nessa rede padrão bridge, com esse nome e utilizando esse driver também de bridge.
* E o que isso significa? Significa que se, por exemplo, eu tentar acessar algum desses containers, como o container de ID 8ea67 e fizer um docker ps e um docker inspet, ele tem o IP address dele, que é 172.17.0.2.
* E se fizermos um docker ps no outro, que começa com b02, e fizermos um docker inspect, nós temos o IP address de 172.17.0.3.
* Então se eu tentar, por via das dúvidas, acessar o meu b02, cujo IP address termina com 03, e por algum motivo eu tentar comunicá-lo com o outro via IP, eu devo conseguir, já que eles estão na mesma interface de rede.
* Só que como é que isso vai funcionar? Como estamos usando uma imagem do Ubuntu, bem provavelmente, caso tentemos executar algum ping, ele não vai conseguir.
* Então é a velha etapa: nós precisaríamos usar uma imagem base que já contém o ping ou podemos simplesmente fazer apt-get update, e depois instalamos o ping para fazer esse experimento.
* Existem outras imagens voltadas para essa parte de teste de rede e afins que também você pode consultar no Docker Hub.

* docker run –it ubuntu bash (2x vezes)
* apt-get update
* apt-get install iputils-ping -y = para instalar o ping
* ping 172.17.0.2 = conseguimos fazer comunicação entre containers via IP. Mas quais são os problemas que isso pode levantar? Vimos que os containers estão suscetíveis a reiniciar, a serem recriados e afins. E isso não vai garantir que o contêiner vai ter sempre o mesmo IP. Então teremos uma conexão muito instável nesse sentido
*  Precisamos ter uma maneira mais certa de fazer isso, como, por exemplo, via um DNS, talvez um host name seria interessante

* As três redes padrão criadas pelo docker: Host, None e Bridge.
* docker network create --driver bridge [nome da bridge] = para criar minha própria rede bridge
* docker run -it --name [host name do container] --networking [nome da bridge888] ubuntu bash = para criar um name ao container, são mais estáveis que os IP Address.

* Exemplo de um segundo bridge
* docker run -d --name pong --network minha-bridge ubuntu sleep 1d = o sleep de um dia só para manter o container em execução. Sem iniciar o terminal
* ping pong = comunicação entre redes por host name do container

* Exemplo com uma rede none 
* docker run -d --network none ubuntu sleep 1d = manter o container em execução sem travar ele, após rodar o comando, é mostrado ID completo do container.
* docker inspect nesse ID = quando utilizamos o driver none, estamos simplesmente falando que esse container não terá qualquer interface de rede vinculada a ele. Ele ficou completamente isolado a nível de rede. Nós não conseguimos fazer nenhum tipo de operação envolvendo a rede desse container, porque o driver dele é none, ele utiliza o driver null.

* Exemplo com uma rede com interface em nosso host
* docker run -d --network host aluradocker/app-node:1.0 = esse container será executado na rede host
* a versão 1.0 da nossa aplicação app-node executa por padrão sempre na porta 3000, então se acessar localhost:3000, conseguimos ver aplicação.
* Porque utilizando o driver host nós estamos utilizando a mesma rede, a mesma interface do host que está hospedando esse container. Então caso tivesse alguma outra aplicação na minha porta 3000 com meu host em execução, eu não conseguiria fazer a utilização desse container dessa maneira, daria um problema de conflito de portas, porque a interface seria a mesma.
* Qual propósito de utilizar as duas redes? 
    * A rede host remove o isolamento entre o container e o sistema, enquanto a rede none remove a interface de rede.


* Comunicando aplicação e banco
* docker pull mongo:4.4.6 = baixar a imagem do banco 
* docker pull aluradocker/alura-books:1.0 = baixar a imagem da aplicação 
* docker network create --driver bridge minha-bridge = crie uma rede bridge
* docker run -d --network minha-bridge --name meu-mongo mongo:4.4.6 = rodar o container do banco na rede. Para não travar o terminal, então deve executar em modo detached com a flag -d. A aplicação está buscando pelo host name meu-mongo, então no momento em que essa imagem da aplicação foi construída, esse arquivo estava definido dessa maneira.
* docker run -d --network minha-bridge --name alurabooks -p 3000:8080 aluradocker/alura-books:1.0 = para aplicação é necessário fazer o mapeamento de portas e utilizar a mesma rede que o container do banco
    * No navegador ao acessar “localhost:3000”, que vai acessar a nossa aplicação. E ela tem um endpoint, o “/seed”, que vai popular o banco. E agora se atualizarmos a página, todos os dados do banco estão sendo carregados na nossa aplicação. Ao fazer docker stop meu-mongo, todos os dados da aplicação irão sumir
    * o papel da rede bridge é possibilitar a comunicação entre containers em um mesmo host.


## Coordenando containers com docker-compose

* O Docker Compose nada mais é do que uma ferramenta de coordenação de containers
* Então o Docker Compose vai nos auxiliar a executar, a compor, como o nome diz, diversos containers em um mesmo ambiente, através de um único arquivo.
* O Docker Compose irá resolver o problema de executar múltiplos containers de uma só vez e de maneira coordenada, evitando executar cada comando de execução individualmente

* mkdir ymls = para criar uma pasta chamada ymls
* cd ymls = para entrar dentro da pasta 
* code .  = para abrir o vscode
* E dentro do vscode, criar um arquivo docker-compose.yml
* Após configurar o arquivo xml, dar um docker-compose up
* É possível ver o resultado acessando localhost:3000 e localhost:3000/seed
* Com ctrl + c para de rodar os dois containers
* Outros comandos:
    * docker-compose up -d
    * docker-compose ps
    * docker-compose down = remove os containers e as redes

## O QUE FOI APRENDIDO?

* Máquinas virtuais possuem camadas adicionais de virtualização em relação a um container;
* Containers funcionam como processos no host;
* Containers atingem isolamento através de namespaces;
* Os recursos dos containers são gerenciados através de cgroups.
* O Docker Hub é um grande repositório de imagens que podemos utilizar;
* A base dos containers são as imagens;
* Como utilizar comandos acerca do ciclo de vida dos containers, como: docker start, para iniciar um container que esteja parado; docker stop, para parar um que esteja rodando; docker pause, para pausar um container e docker unpause para iniciar um container pausado; 
* Conseguimos mapear portas de um container com as flags -p e -P.
* Imagens são imutáveis, ou seja, depois de baixadas, múltiplos containers conseguirão reutilizar a mesma imagem;
* Imagens são compostas por uma ou mais camadas. Dessa forma, diferentes imagens são capazes de reutilizar uma ou mais camadas em comum entre si;
* Podemos criar nossas imagens através de Dockerfiles e do comando docker build;
* Para subir uma imagem no Docker Hub, utilizamos o comando docker push.
* Quando containers são removidos, nossos dados são perdidos;
* Podemos persistir dados em definitivo através de volumes e bind mounts;
* Bind mounts dependem da estrutura de pastas do host;
* Volumes são gerenciados pelo Docker;
* Tmpfs armazenam dados em memória volátil
* O docker dispõe por padrão de três redes: bridge, host e none;
* A rede bridge é usada para comunicar containers em um mesmo host;
* Redes bridges criadas manualmente permitem comunicação via hostname;
* A rede host remove o isolamento de rede entre o container e o host;
* A rede none remove a interface de rede do container;
* Podemos criar redes com o comando docker network create
* O Docker Compose é uma ferramenta de coordenação de containers;
* Como iniciar containers em conjunto com o comando docker-compose up;
* Como criar um arquivo de composição e definir instruções de containers, redes e serviços.



