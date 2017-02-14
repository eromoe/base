FROM ubuntu:14.04
MAINTAINER eromoe|mithril

SHELL ["/bin/bash", "-c"]

# China Customize
COPY update_source.sh /tmp/update_source.sh
RUN bash /tmp/update_source.sh

COPY pip.conf /etc/pip.conf

# Set the locale

RUN locale-gen "en_US.UTF-8"
RUN dpkg-reconfigure locales
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# install build tools & lib dependencies

RUN apt-get update && \
    apt-get install -y build-essential libcurl4-openssl-dev libxml2-dev libxslt1-dev libpq-dev

RUN apt-get install -y wget git vim

# install python 2.7
# ubuntu:14.04 default has 2.7.5 installed
RUN apt-get install -y python-dev

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
RUN jt -t onedork -tf georgiaserif -nf droidsans -T -N

ENTRYPOINT ["/bin/bash"]