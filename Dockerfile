FROM ubuntu:18.04
LABEL maintainer="David <david@cninone.com>"

# Get noninteractive frontend for Debian to avoid some problems:
#    debconf: unable to initialize frontend: Dialog
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y && apt-get install -y \
    openssh-server curl gitolite3 libltdl-dev locales \
    && locale-gen en_US.UTF-8
ENV LANG       en_US.UTF-8
ENV LC_ALL	   "C.UTF-8"
ENV LANGUAGE   en_US:en

RUN useradd -ms /bin/bash david && usermod -aG sudo david
RUN echo 'david:freego' | chpasswd
RUN echo 'root:freego_2019' | chpasswd
# RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV TZ=Asia/Chongqing
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY init.sh /


EXPOSE 22

ENTRYPOINT ["/init.sh"]
