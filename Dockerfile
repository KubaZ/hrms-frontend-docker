FROM ubuntu:latest

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN sudo apt-get update \
    && sudo apt-get install -y build-essential curl nginx

ENV NVM_DIR /root/.nvm

RUN curl https://raw.githubusercontent.com/creationix/nvm/v0.23.3/install.sh | bash \
    && source $NVM_DIR/nvm.sh \
    && nvm install stable \
    && nvm alias default stable \
    && nvm use default

RUN mkdir /data

COPY . /data/

EXPOSE  80

RUN cd /data/hrms-frontend \
    && source $NVM_DIR/nvm.sh \
    && npm i

COPY files/nginx/hrms.conf /data/hrms.conf

RUN service nginx stop

CMD /usr/sbin/nginx -c /data/hrms.conf
