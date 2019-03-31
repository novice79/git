FROM ubuntu:18.04
LABEL maintainer="David <david@cninone.com>"

# Get noninteractive frontend for Debian to avoid some problems:
#    debconf: unable to initialize frontend: Dialog
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y && apt-get install -y \
    openssh-server curl gitolite3 libltdl-dev locales tzdata 
     
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
RUN useradd -ms /bin/bash david && usermod -aG sudo david \
    && adduser --system --shell /bin/bash --group --disabled-password --home /home/git git
RUN echo 'david:freego' | chpasswd ; echo 'root:freego_2019' | chpasswd
# RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV TZ=Asia/Chongqing
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN sed -i '/LOCAL_CODE.*GL_ADMIN_BASE/s/^\s*#//g' /home/git/.gitolite.rc ; \
    sed -i '/repo-specific-hooks/s/^\s*#//g' /home/git/.gitolite.rc
COPY init.sh /
COPY id_rsa.pub /david.pub

EXPOSE 22

ENTRYPOINT ["/init.sh"]
