FROM container-registry.phenomenal-h2020.eu/phnmnl/xcms:latest

MAINTAINER PhenoMeNal-H2020 Project (phenomenal-h2020-users@googlegroups.com)

LABEL software=CAMERA
LABEL software.version=1.30.0
LABEL version=0.2
LABEL Description="CAMERA: Collection of annotation related methods for mass spectrometry data."

# Install packages for compilation
RUN apt-get -y update
RUN apt-get -y --no-install-recommends install make gcc gfortran g++ libnetcdf-dev libblas-dev liblapack-dev

# Install dependencies
RUN R -e 'install.packages(c("irlba","igraph"), repos="https://mirrors.ebi.ac.uk/CRAN/")'

# Install XML package Test
RUN R -e 'install.packages(c("XML"), repos="http://cran.rstudio.com")'

# Install CAMERA
RUN R -e 'source("https://bioconductor.org/biocLite.R"); biocLite("CAMERA")'

# De-install not needed packages
RUN apt-get -y --purge --auto-remove remove make gcc gfortran g++

# Clean-up
RUN apt-get -y clean && apt-get -y autoremove && rm -rf /var/lib/{cache,log}/ /tmp/* /var/tmp/*

# Add scripts folder to container
ADD scripts/*.r /usr/local/bin/
RUN chmod +x /usr/local/bin/*.r

# Define Entry point script
#ENTRYPOINT [ "Rscript" ]
#CMD [ "/usr/local/bin/show_chromatogram.r" ]

