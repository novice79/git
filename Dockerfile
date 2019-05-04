FROM ubuntu:18.04
LABEL maintainer="David <david@cninone.com>"

# Get noninteractive frontend for Debian to avoid some problems:
#    debconf: unable to initialize frontend: Dialog
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y && apt-get install -y \
    openssh-server curl gitolite3 libltdl-dev locales tzdata sudo ssmtp python3-pip
     
RUN locale-gen en_US.UTF-8 zh_CN.UTF-8 ; mkdir -p /var/run/sshd
RUN curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
        && chmod +x /usr/local/bin/docker-compose
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
RUN { \
        echo "LANG=$LANG"; \
        echo "LANGUAGE=$LANG"; \
        echo "LC_ALL=$LANG"; \
} > /etc/default/locale
# or adduser --system --shell /bin/bash --uid 777 --gid 65534 --disabled-password --home /home/git git
# or adduser --system --shell /bin/bash --uid 777 --group --disabled-password --home /home/git git
RUN useradd -ms /bin/bash david && usermod -aG sudo david \
    && adduser --system --shell /bin/bash --uid 777 --group --disabled-password --home /home/git git
RUN echo 'david:freego' | chpasswd ; echo 'root:freego_2019' | chpasswd ; \
    groupadd docker -g 999 && usermod -aG docker git
# RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
RUN pip3 install Jinja2 pyyaml
ENV TZ=Asia/Chongqing
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY init.sh /
COPY id_rsa.pub /david.pub

EXPOSE 22

# USER git
RUN sudo -u git mkdir /home/git/publish
ENTRYPOINT ["/init.sh"]
