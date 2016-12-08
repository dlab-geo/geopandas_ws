# Base image of the IPython/Jupyter notebook, with conda
# Intended to be used in a tmpnb installation
# Customized from https://github.com/jupyter/docker-demo-images/tree/master/common
FROM debian:jessie

MAINTAINER Drew Hart <drew.hart@berkeley.edu>

ENV DEBIAN_FRONTEND noninteractive

#From https://github.com/ctb/2016-mybinder-irkernel/blob/master/Dockerfile, 
#and from the errors I've been getting, it looks like perhaps I have to insert the next line
#to get the apt-get commands to run

USER root

RUN apt-get update -y &&\
    apt-get install -y curl git vim wget build-essential python-dev ca-certificates bzip2 libsm6\
      nodejs-legacy npm python-virtualenv python-pip gcc gfortran libglib2.0-0 python-qt4 &&\
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*tmp

# We run our docker images with a non-root user as a security precaution.
# main is our user
#RUN useradd -m -s /bin/bash main

EXPOSE 8888

USER main
ENV HOME /home/main
ENV SHELL /bin/bash
ENV USER main
WORKDIR $HOME

# Add helper scripts
#ADD start-notebook.sh /home/main/

#USER main

# Install Anaconda and Jupyter
RUN wget https://3230d63b5fc54e62148e-c95ac804525aac4b6dba79b00b39d1d3.ssl.cf1.rackcdn.com/Anaconda3-4.0.0-Linux-x86_64.sh
RUN bash Anaconda3-4.0.0-Linux-x86_64.sh -b &&\
    rm Anaconda3-4.0.0-Linux-x86_64.sh
ENV PATH $HOME/anaconda3/bin:$PATH

RUN /home/main/anaconda3/bin/pip install --upgrade pip


#DEH ADD: Install Python pacakges
RUN pip install geopandas geopy Fiona Shapely osmnx GDAL

ENV SHELL /bin/bash
