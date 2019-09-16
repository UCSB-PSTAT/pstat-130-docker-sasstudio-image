FROM centos

MAINTAINER Patrick Windmiller <sysadmin@pstat.ucsb.edu>

# Install libraries and clean all
RUN yum -y install numactl-libs.x86_64 \
  passwd \
  libXp \
  libpng12 \
  libXmu.x86_64 \
  && yum clean all

# Add group
RUN useradd -m sas
RUN groupadd -g 1001 sasstaff

# Add sas user
RUN usermod -a -G sasstaff sas

# Set default password by pointing to /etc/passwd
RUN echo -e "mypassword" | /usr/bin/passwd --stdin sas

# Make the SASHome directory and add the TAR file
RUN mkdir -p /usr/local/SASHome
ADD SASHomeTar.tar /
RUN chown -R sas:sasstaff /usr/local/SASHome
EXPOSE 38080

# Add startup script to start SAS Studio
ADD startup.sh /
ENTRYPOINT ["/startup.sh"]
