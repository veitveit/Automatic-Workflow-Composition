# Base Image
FROM biocontainers/biocontainers:latest

# Metadata (tpp)
LABEL base.image="biocontainers:latest"
LABEL version="3"
LABEL software="TPP"
LABEL software.version="5.0"
LABEL description="a collection of integrated tools for MS/MS proteomics"
LABEL website="http://tools.proteomecenter.org/wiki/index.php?title=Software:TPP"
LABEL documentation="http://tools.proteomecenter.org/wiki/index.php?title=Software:TPP"
LABEL license="http://tools.proteomecenter.org/wiki/index.php?title=Software:TPP"
LABEL tags="Proteomics"

# Maintainer MAINTAINER Felipe da Veiga Leprevost <felipe@leprevost.com.br>
USER root
WORKDIR /usr/local/
RUN apt-get update && apt-get install -y libfindbin-libs-perl && apt-get clean all
RUN wget https://github.com/BioContainers/software-archive/releases/download/TPP/tpp-5.0.zip && unzip tpp-5.0.zip
ENV PATH /usr/local/tpp/bin/:$PATH USER biodocker
WORKDIR /data/

## PeptideShaker
# Metadata
LABEL base.image="biocontainers:latest"
LABEL version="1"
LABEL software="PeptideShaker"
LABEL software.version="1.10.3"
LABEL description="interpretation of proteomics identification results"
LABEL website="http://compomics.github.io/projects/peptide-shaker.html"
LABEL documentation="http://compomics.github.io/projects/peptide-shaker.html"
LABEL license="http://compomics.github.io/projects/peptide-shaker.html"
LABEL tags="Proteomics"

RUN ZIP=PeptideShaker-1.13.6.zip &&     wget  http://genesis.ugent.be/maven2/eu/isas/peptideshaker/PeptideShaker/1.13.6/$ZIP -O /tmp/$ZIP &&     unzip /tmp/$ZIP -d /home/biodocker/bin/ &&  rm /tmp/$ZIP &&  bash -c 'echo -e "#!/bin/bash\njava -jar /home/biodocker/bin/PeptideShaker-1.13.6/PeptideShaker-1.13.6.jar $@"' > /home/biodocker/bin/PeptideShaker &&  chmod +x /home/biodocker/bin/PeptideShaker
ENV PATH /home/biodocker/bin/PeptideShaker:$PATH 

WORKDIR /data/


## SEARCHGUI
# METADATA
LABEL version="1"
LABEL software="SearchGUI"
LABEL software.version="2.8.6"
LABEL description="graphical user interface for proteomics identification search engines"
LABEL website="https://code.google.com/p/searchgui/"
LABEL documentation="https://code.google.com/p/searchgui/"
LABEL license="https://code.google.com/p/searchgui/"
LABEL tags="Proteomics"

# Maintainer MAINTAINER Felipe da Veiga Leprevost <felipe@leprevost.com.br>
RUN ZIP=SearchGUI-3.0.2-mac_and_linux.tar.gz && wget http://genesis.ugent.be/maven2/eu/isas/searchgui/SearchGUI/3.0.2/$ZIP -O /tmp/$ZIP && tar xzf /tmp/$ZIP && mv SearchGUI* /home/biodocker/bin/ && rm /tmp/$ZIP && bash -c 'echo -e "#!/bin/bash\njava -jar /home/biodocker/bin/SearchGUI-3.0.2/SearchGUI-3.0.2.jar $@"' > /home/biodocker/bin/SearchGUI && chmod +x /home/biodocker/bin/SearchGUI

ENV PATH /home/biodocker/bin/SearchGUI:$PATH WORKDIR /data/

## R environment and packages
#ENV R_BASE_VERSION 3.2.3 ENV R_BASE_VERSION 3.3.1 # Install R RUN echo "deb http://cran.rstudio.com/bin/linux/ubuntu trusty/" >> /etc/apt/sources.list && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9 	&& apt-get -qq update 	&& apt-get upgrade -y && apt-get install -y --no-install-recommends littler 	r-base-core=${R_BASE_VERSION}* 	r-base-dev=${R_BASE_VERSION}* libcurl4-openssl-dev libxml2-dev libfftw3-dev git wget     && echo 'options(repos = c(CRAN = "https://cran.rstudio.com/"), download.file.method = "libcurl")' >> /etc/R/Rprofile.site   && echo 'source("/etc/R/Rprofile.site")' >> /etc/littler.r && ln -s /usr/share/doc/littler/examples/install.r /usr/local/bin/install.r && ln -s /usr/share/doc/littler/examples/install2.r /usr/local/bin/install2.r && ln -s /usr/share/doc/littler/examples/installGithub.r /usr/local/bin/installGithub.r && ln -s /usr/share/doc/littler/examples/testInstalled.r /usr/local/bin/testInstalled.r && install.r docopt 	&& rm -rf /tmp/downloaded_packages/ /tmp/*.rds 	&& rm -rf /var/lib/apt/lists/*
	
## install additional R packages using R RUN > rscript.R &&echo 'source("https://bioconductor.org/biocLite.R")' >> rscript.R &&echo 'biocLite(ask=FALSE)' >> rscript.R 	#&&echo 'biocLite("BiocUpgrade")' >> rscript.R &&echo 'biocLite("Biobase",ask=FALSE)' >> rscript.R &&echo 'biocLite("stringr",ask=FALSE)' >> rscript.R 	&&echo 'biocLite("isobar",ask=FALSE)' >> rscript.R &&echo 'biocLite("mzID",ask=FALSE)' >> rscript.R &&echo 'biocLite("XML",ask=FALSE)' >> rscript.R &&echo 'biocLite("venneuler",ask=FALSE)' >> rscript.R &&echo 'biocLite("svglite",ask=FALSE)' >> rscript.R &&echo 'biocLite("matrixStats",ask=FALSE)' >> rscript.R 	&&Rscript rscript.R

WORKDIR /data/

## Files for use cases
COPY ./ UseCases