FROM ubuntu:22.04

SHELL ["/bin/bash", "-c"]

RUN apt update && \
  apt install python3.10 \
  python3.10-venv \
  systemctl \
  curl \
  nano \
  zip \
  unzip \
  tzdata \
  sudo -y 



RUN useradd -ms /bin/bash nifi -G sudo && \
  passwd -d nifi && \
  mkdir -p /home/nifi/ 

WORKDIR /home/nifi

ADD https://download.oracle.com/java/21/latest/jdk-21_linux-x64_bin.deb .

RUN sudo apt install ./jdk-21_linux-x64_bin.deb -y

#ADD https://dlcdn.apache.org/nifi/2.0.0-M2/nifi-2.0.0-M2-bin.zip .

ADD ./deploy/nifi-2.0/nifi-2.0.0-M2-bin.zip .

RUN unzip ./nifi-2.0.0-M2-bin.zip

RUN rm -f ./nifi-2.0.0-M2-bin.zip && \
  rm -f ./jdk-21_linux-x64_bin.deb

RUN echo "JAVA_HOME=/usr/lib/jvm/jdk-21-oracle-x64" >> \
  /home/nifi/nifi-2.0.0-M2/bin/nifi-env.sh

RUN chmod +x /home/nifi/nifi-2.0.0-M2/bin/nifi.sh

RUN /home/nifi/nifi-2.0.0-M2/bin/nifi.sh install nifi-2.0

RUN chown -R nifi:nifi /home/nifi

VOLUME ["/home/nifi/nifi-2.0.0-M2/bin", "/home/nifi/nifi-2.0.0-M2/conf", "/home/nifi/nifi-2.0.0-M2/extensions", "/home/nifi/nifi-2.0.0-M2/python"]

USER nifi

ENTRYPOINT tail -f /dev/null 


# docker compose -p nifi_2_0 -f docker-compose.yaml down && docker system prune --all -f && docker volume prune --all -f

# docker build -f dockerfile -t renatoelho/nifi:2.0.0 .

# sudo su && cd /var/lib/docker/volumes/<meu_volume>/_data

# docker compose -p nifi_2_0 -f docker-compose.yaml up -d --build
