FROM alpine:3.14

RUN sed -i 's/https/http/' /etc/apk/repositories

RUN apk add curl bash ca-certificates openssh

# nodejs
RUN apk add --update curl
RUN apk add --update nodejs npm
# RUN npm install -g npm@7.24.2

# Java and Maven
RUN apk add --update openjdk11 maven

# python
ENV PYTHONUNBUFFERED=1
RUN apk add --update --no-cache python3 && ln -sf python3 /usr/bin/python
RUN python3 -m ensurepip
RUN pip3 install --no-cache --upgrade pip setuptools

# go
RUN apk add --no-cache git make musl-dev go
ENV GOROOT /usr/lig/go
ENV GOPATH /go
ENV PATH /go/bin:$PATH

RUN mkdir -p ${GOPATH}/src ${GOPATH}/bin

# git
ENV email user@some.com
ENV user user
RUN mkdir -p /root/.ssh
COPY id_rsa /root/.ssh/
RUN echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config && echo "UserKnownHostsFile /dev/null" >> /etc/ssh/ssh_config
RUN git config --global user.email ${email} && git config --global user.name ${user}
RUN chown 1000:1000 /root/.ssh/id_rsa

# Command prompt
CMD /bin/bash
