FROM node

VOLUME /host_shared

WORKDIR /host_shared

RUN npm install -g grunt-cli
RUN npm install -g coffee-script

ENTRYPOINT ["grunt"]
