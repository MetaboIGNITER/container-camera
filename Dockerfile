FROM container-registry.phenomenal-h2020.eu/phnmnl/xcms:v1.52.0_cv0.5.58

MAINTAINER PhenoMeNal-H2020 Project (phenomenal-h2020-users@googlegroups.com)

LABEL software=CAMERA
LABEL software.version=1.30.0
LABEL version=0.4
LABEL Description="CAMERA: Collection of annotation related methods for mass spectrometry data."

# Install packages for compilation
RUN apt-get -y update && apt-get -y --no-install-recommends install r-base-dev && \
    R -e 'install.packages(c("irlba","igraph","XML"), repos="https://mirrors.ebi.ac.uk/CRAN/")' && \
    R -e 'source("https://bioconductor.org/biocLite.R"); biocLite("CAMERA")' && \
    apt-get -y --purge --auto-remove remove r-base-dev && \
    apt-get -y clean && apt-get -y autoremove && rm -rf /var/lib/{cache,log}/ /tmp/* /var/tmp/*

# Add scripts folder to container
ADD scripts/*.r /usr/local/bin/
# Add files for testing
ADD runTest1.sh /usr/local/bin/runTest1.sh

RUN chmod +x /usr/local/bin/*.r
RUN chmod +x /usr/local/bin/runTest1.sh

# Define Entry point script
#ENTRYPOINT [ "Rscript" ]
#CMD [ "/usr/local/bin/show_chromatogram.r" ]

