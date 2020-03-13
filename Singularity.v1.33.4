Bootstrap: docker
From: metaboigniter/container-xcms:v1.53.1
%files
scripts/*.r /usr/local/bin/
runTest1.sh /usr/local/bin/runTest1.sh
%labels
MAINTAINER PhenoMeNal-H2020 Project (phenomenal-h2020-users@googlegroups.com)
software="CAMERA"
software.version="1.33.4"
version="0.12"
description="CAMERA: Collection of annotation related methods for mass spectrometry data."
website="https://github.com/sneumann/CAMERA"
documentation="https://github.com/phnmnl/container-camera/blob/master/README.md"
license="https://github.com/phnmnl/container-camera/blob/develop/License.txt"
tags="Metabolomics"
%post


# Install packages for compilation
# R -e 'source("https://bioconductor.org/biocLite.R"); biocLite("CAMERA")' && \
apt-get -y update && apt-get -y --no-install-recommends install make gcc gfortran g++ libnetcdf-dev libxml2-dev libblas-dev liblapack-dev libssl-dev r-base-dev pkg-config git && \
R -e 'source("https://bioconductor.org/biocLite.R");biocLite(c("irlba","igraph","XML","intervals","devtools"))' && \
R -e 'library(devtools); install_github(repo="sneumann/CAMERA", ref="cbc9cdb2eba6438434c27fec5fa13c9e6fdda785")' && \
apt-get -y --purge --auto-remove remove make gcc gfortran g++ libblas-dev liblapack-dev r-base-dev libssl-dev pkg-config && \
apt-get -y clean && apt-get -y autoremove && rm -rf /var/lib/{cache,log}/ /tmp/* /var/tmp/*

# Install zip package
apt-get -y update && apt-get -y --no-install-recommends install make gcc gfortran g++ && \
R -e 'source("https://bioconductor.org/biocLite.R");biocLite(c("zip"))'

# Add scripts folder to container
# Add files for testing

chmod +x /usr/local/bin/*.r
chmod +x /usr/local/bin/runTest1.sh

%runscript
exec /bin/bash "$@"
%startscript
exec /bin/bash "$@"
