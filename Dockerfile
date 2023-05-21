# versão do node.js (servidor), que é suportado pelo docker
FROM node:14 
# local de trabalho para gerar imagem e o container
WORKDIR /app-node
# no momento de build informando qual será a porta
ARG PORT_BUILD=6000
# dentro do container informando qual será a porta
ENV PORT=${PORT_BUILD}
# informando em qual porta será exposta o container
EXPOSE $PORT
# copiando o node.js do host para local de trabalho 
COPY . .
# qual comando deverá rodar enquanto a imagem está sendo executada
# dentro do diretório local
RUN npm install
# após criação do container, executar esse comando
ENTRYPOINT npm start