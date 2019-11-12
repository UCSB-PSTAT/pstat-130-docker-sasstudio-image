# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.

FROM jupyter/scipy-notebook

LABEL maintainer="Patrick Windmiller <sysadmin@pstat.ucsb.edu>"

USER root

# Original environment variables (Only works with standalone SAS Studio)
# included for persepective, incase your looking at the SAS Studio build notes and get lost.
#ENV NB_USER sas
#ENV NB_GRP sasstaff
#ENV NB_PASS mypass
#
#To allow it to work in JupyterHub/Jupyter Notebook environment we needed to change the above to these new environment variables
#
ENV NB_USER jovyan
ENV NB_GRP users
ENV NB_PASS mypass

#Install required libs for SAS
RUN echo "deb http://security.ubuntu.com/ubuntu xenial-security main" >> /etc/apt/sources.list
RUN apt-get update && \
    apt-get install -y libpng12-0 \
    libjpeg62-dev \
    libmagic-dev \
    default-jre-headless

# Add jovyan and jovyan's sas password
# NOTE: needed to add '; exit 0' to several commands to catch the error of the user existing in 
# the JupyterHub/Notebook environment and to allow for setting a password for SAS Studio Login 

RUN useradd -m $NB_USER -p $NB_PASS; exit 0
# Set default password by pointing to /etc/passwd
RUN echo $NB_USER:$NB_PASS | chpasswd; exit 0


# Make the SASHome directory and add the TAR file
RUN mkdir -p /usr/local/SASHome
ADD SASHomeTar.tar /
RUN chown -R $NB_USER:$NB_GRP /usr/local/SASHome

# Install jupyterserverproxy
RUN pip install jupyter-server-proxy

EXPOSE 38080

# Add startup script to start SAS Studio
ADD startup.sh /

ENTRYPOINT ["/startup.sh"]
