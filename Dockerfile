FROM ubuntu:14.04
MAINTAINER eromoe|mithril

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

# install python 3.5

RUN apt-get install -y software-properties-common && \
    add-apt-repository ppa:fkrull/deadsnakes && \
    apt-get update

RUN apt-get install -y python3.5-dev
RUN apt-get install -y wget git vim

# set python 3.5 as default
RUN ln -sf /usr/bin/python3.5 /usr/bin/python

COPY get-pip.py /tmp/get-pip.py
CMD python /tmp/get-pip.py

CMD pip install -U pip setuptools

# enable notebooks
CMD pip install \
    ipython \
    jupyter \
    jupyterthemes

# Set up notebook config
RUN mkdir -p /root/.jupyter/
COPY jupyter_notebook_config.py /root/.jupyter/

# set dark theme
CMD jt -t onedork -tf georgiaserif -nf droidsans -T -N


ENTRYPOINT ["/bin/bash"]