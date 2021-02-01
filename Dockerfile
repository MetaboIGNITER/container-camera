FROM metaboigniter/container-xcms:v3.0.2_ipo

MAINTAINER PhenoMeNal-H2020 Project (phenomenal-h2020-users@googlegroups.com)

LABEL software="CAMERA"
LABEL software.version="1.33.4"
LABEL version="0.12"
LABEL description="CAMERA: Collection of annotation related methods for mass spectrometry data."
LABEL website="https://github.com/sneumann/CAMERA"
LABEL documentation="https://github.com/phnmnl/container-camera/blob/master/README.md"
LABEL license="https://github.com/phnmnl/container-camera/blob/develop/License.txt"
LABEL tags="Metabolomics"


# Install zip package
RUN  apt-get -y update && apt-get -y --no-install-recommends install make gcc gfortran g++ && \
R -e 'source("https://bioconductor.org/biocLite.R");biocLite(c("zip"))'

# Add scripts folder to container
ADD scripts/*.r /usr/local/bin/
# Add files for testing
ADD runTest1.sh /usr/local/bin/runTest1.sh

RUN chmod +x /usr/local/bin/*.r
RUN chmod +x /usr/local/bin/runTest1.sh
