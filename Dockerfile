FROM centos:7
RUN yum update -y &&\
    yum install yum-utils -y &&\
    yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
WORKDIR offline_docker
COPY ./assets/docker-dependencies-downloader.sh .
ENTRYPOINT ["sh", "docker-dependencies-downloader.sh"]
