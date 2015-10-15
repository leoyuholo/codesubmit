FROM node

RUN npm install -g grunt-cli
RUN npm install -g coffee-script

VOLUME /host_shared

WORKDIR /host_shared

ENTRYPOINT ["grunt"]
