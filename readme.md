docker build -t novice/git .
docker run -it --rm -p 2222:22 -v /var/run/docker.sock:/var/run/docker.sock -v /usr/bin/docker:/usr/bin/docker --entrypoint=bash novice/git:latest
<!-- chmod +r $HOME/.kube/config -->
docker run -d --name git -p 2222:22 \
-e SSMTP_HOST=yoursmtpserver:port \
-e SSMTP_USER=smtpusername \
-e SSMTP_PASSWORD=smtppassword \
-v /var/run/docker.sock:/var/run/docker.sock \
-v /usr/bin/docker:/usr/bin/docker \
-v /usr/bin/kubectl:/usr/bin/kubectl \
-v $HOME/.kube/config:/home/git/.kube/config \
-v $PWD/id_rsa.pub:/id_rsa.pub \
-v git-repo:/home/git \
novice/git:latest