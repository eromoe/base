# ubuntu 16.04, https://github.com/phusion/baseimage-docker
FROM phusion/baseimage

MAINTAINER eromoe|mithril

ARG PYTHON_VERSION="3.6"
ARG DARK_THEME=0

SHELL ["/bin/bash", "-c"]

# Install build tools & lib dependencies
RUN apt-get update && \
    apt-get install -y build-essential libcurl4-openssl-dev libxml2-dev libxslt1-dev libpq-dev

# Set the locale
RUN apt-get install -y locales && locale-gen "en_US.UTF-8" && dpkg-reconfigure -f noninteractive locales
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV PYTHONIOENCODING utf-8

RUN echo \
    && echo 'LANG=en_US.UTF-8' >> /etc/environment \
    && echo 'LANGUAGE=en_US:en' >> /etc/environment \
    && echo 'LC_ALL=en_US.UTF-8' >> /etc/environment \
    && echo 'PYTHONIOENCODING=utf-8' >> /etc/environment

# Allow `docker logs` show python app logs
ENV PYTHONUNBUFFERED 0

# Install python

RUN apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:deadsnakes/ppa && \
    apt-get update

RUN apt-get install -y python${PYTHON_VERSION}-dev wget git vim curl

# Set new installed python as default
RUN ln -sf /usr/bin/python${PYTHON_VERSION} /usr/bin/python

# Because download is very slow in some place, so bundle get-pip.py
COPY get-pip.py /tmp/get-pip.py
RUN python /tmp/get-pip.py

RUN pip install -U pip setuptools

# Enable python notebooks
RUN pip install \
    ipython \
    jupyter \
    jupyterthemes

# Set up notebook config
RUN mkdir -p /root/.jupyter/
COPY jupyter_notebook_config.py /root/.jupyter/

# Set notebook dark theme
# jt -t chesterish -T -N

COPY run_jupyter.sh /run_jupyter.sh


# China Customize at last for dockerhub
COPY update_source.sh /tmp/update_source.sh
RUN bash /tmp/update_source.sh

RUN echo \
  && echo '[global]' >> /etc/pip.conf \
  && echo 'index-url = https://mirrors.aliyun.com/pypi/simple' >> /etc/pip.conf \
  && echo "registry = https://registry.npm.taobao.org" >> /etc/npmrc

ENV PIP_INDEX_URL "https://mirrors.aliyun.com/pypi/simple"


ENTRYPOINT ["/bin/bash"]

# CMD ["/run_jupyter.sh"]
