# ubuntu 16.04, https://github.com/phusion/baseimage-docker
FROM phusion/baseimage

MAINTAINER eromoe|mithril

# China Customize, update sources
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
ENV PYTHONIOENCODING utf-8

# allow `docker logs` show python app logs
ENV PYTHONUNBUFFERED 0

# Install build tools & lib dependencies
RUN apt-get update && \
    apt-get install -y build-essential libcurl4-openssl-dev libxml2-dev libxslt1-dev libpq-dev

# Install some useful tools for further modification and testing
RUN apt-get install -y wget git vim curl

# Install python 2.7
# Ubuntu:14.04 docker image doesn't contain python 2.7
RUN apt-get install -y python-dev

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
# RUN jt -t onedork -tf georgiaserif -nf droidsans -T -N

COPY run_jupyter.sh /run_jupyter.sh

ENTRYPOINT ["/bin/bash"]

# CMD ["/run_jupyter.sh"]
