FROM container-registry.phenomenal-h2020.eu/phnmnl/xcms:dev_v3.0.0_cv0.1.72

MAINTAINER PhenoMeNal-H2020 Project (phenomenal-h2020-users@googlegroups.com)

LABEL software="CAMERA"
LABEL software.version="1.33.3"
LABEL version="0.10"
LABEL description="CAMERA: Collection of annotation related methods for mass spectrometry data."
LABEL website="https://github.com/sneumann/CAMERA"
LABEL documentation="https://github.com/phnmnl/container-camera/blob/master/README.md"
LABEL license="https://github.com/phnmnl/container-camera/blob/develop/License.txt"
LABEL tags="Metabolomics"

# Install packages for compilation
# R -e 'source("https://bioconductor.org/biocLite.R"); biocLite("CAMERA")' && \
RUN apt-get -y update && apt-get -y --no-install-recommends install make gcc gfortran g++ libnetcdf-dev libxml2-dev libblas-dev liblapack-dev libssl-dev r-base-dev pkg-config git && \
    R -e 'install.packages(c("irlba","igraph","XML","intervals"), repos="https://mirrors.ebi.ac.uk/CRAN/")' && \
    R -e 'install.packages("devtools", repos="https://mirrors.ebi.ac.uk/CRAN/")' && \
    R -e 'library(devtools); install_github(repo="sneumann/CAMERA", ref="cbc9cdb2eba6438434c27fec5fa13c9e6fdda785")' && \
    apt-get -y --purge --auto-remove remove make gcc gfortran g++ libblas-dev liblapack-dev r-base-dev libssl-dev pkg-config && \
    apt-get -y clean && apt-get -y autoremove && rm -rf /var/lib/{cache,log}/ /tmp/* /var/tmp/*

# Add scripts folder to container
ADD scripts/*.r /usr/local/bin/
# Add files for testing
ADD runTest1.sh /usr/local/bin/runTest1.sh

RUN chmod +x /usr/local/bin/*.r
RUN chmod +x /usr/local/bin/runTest1.sh

