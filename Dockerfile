# ubuntu 16.04, https://github.com/phusion/baseimage-docker
FROM phusion/baseimage

MAINTAINER eromoe|mithril

SHELL ["/bin/bash", "-c"]

# China Customize
COPY update_source.sh /tmp/update_source.sh
RUN bash /tmp/update_source.sh

RUN echo \
  && echo '[global]' >> /etc/pip.conf \
  && echo 'index-url = https://mirrors.aliyun.com/pypi/simple' >> /etc/pip.conf \
  && echo "registry = https://registry.npm.taobao.org" >> /etc/npmrc

# Set the locale

RUN locale-gen "en_US.UTF-8"
RUN dpkg-reconfigure locales
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# allow `docker logs` show python app logs
ENV PYTHONUNBUFFERED 0

# install build tools & lib dependencies

RUN apt-get update && \
    apt-get install -y build-essential libcurl4-openssl-dev libxml2-dev libxslt1-dev libpq-dev

# install python 3.5

RUN apt-get install -y software-properties-common && \
    add-apt-repository ppa:fkrull/deadsnakes && \
    apt-get update

RUN apt-get install -y python3.5-dev
RUN apt-get install -y wget git vim curl

# set python 3.5 as default
RUN ln -sf /usr/bin/python3.5 /usr/bin/python

# because download is very slow in some place, so bundle get-pip.py
COPY get-pip.py /tmp/get-pip.py
RUN python /tmp/get-pip.py

RUN pip install -U pip setuptools

# enable notebooks
RUN pip install \
    ipython \
    jupyter \
    jupyterthemes

# Set up notebook config
RUN mkdir -p /root/.jupyter/
COPY jupyter_notebook_config.py /root/.jupyter/

# set dark theme
# RUN jt -t onedork -tf georgiaserif -nf droidsans -T -N

ENTRYPOINT ["/bin/bash"]