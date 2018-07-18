FROM ubuntu

MAINTAINER Deivid Sanches <deividsanches@gmail.com>

ENV DEBIAN_FRONTEND=noninteractive

#INSTALL REQUIREDS PACKAGES
		RUN apt-get update && \
			apt-get -y install python-pip && \
			apt-get -y install	r-cran-rjava && \
			apt-get -y install	r-base && \
			apt-get -y install	gdebi-core && \
			apt-get -y install	libcurl4-gnutls-dev && \
			apt-get -y install	libssl-dev && \
			apt-get -y install	wget && \
			apt-get -y install	openjdk-8-jdk && \
			apt-get -y install	git && \
			apt-get -y install	vim

#INSTALL NODE.JS
		RUN apt-get install -y nodejs && \
			apt-get install -y npm && \
			npm cache clean -f && \
			npm install -g n && \
			n stable && \
			npm install pm2 -g
			

#INSTALL SHINY-SERVER:
		RUN wget https://download3.rstudio.org/ubuntu-12.04/x86_64/shiny-server-1.5.5.872-amd64.deb && \
			md5sum shiny-server-1.5.5.872-amd64.deb && \
			gdebi shiny-server-1.5.5.872-amd64.deb -n && \
			apt-get clean && \
			rm -f md5sum shiny-server-1.5.5.872-amd64.deb 

#PREPARE JAVA TO CLEAN INSTALL OF SHINY-SERVER
		RUN mkdir /usr/lib/jvm/default-java && \
				ln -s /usr/lib/jvm/java-8-openjdk-amd64/bin/ /usr/lib/jvm/default-java/ && \
				R CMD javareconf

				ADD ./configs/javaconf /usr/lib/R/etc/javaconf

# Install required packages for SHINY-SERVER Dashboard
		RUN su - -c "R -e \"install.packages('shiny', repos='http://cran.rstudio.com/')\"" && \
				su - -c "R -e \"install.packages('shinydashboard', repos = 'http://cran.rstudio.com/')\"" && \
				su - -c "R -e \"install.packages('scales', repos = 'http://cran.rstudio.com/')\"" && \
				su - -c "R -e \"install.packages('ggthemes', repos = 'http://cran.rstudio.com/')\"" && \
				su - -c "R -e \"install.packages('googleVis', repos = 'http://cran.rstudio.com/')\"" && \
				su - -c "R -e \"install.packages('rJava', repos = 'http://cran.rstudio.com/')\"" && \
				su - -c "R -e \"install.packages('RJDBC', repos = 'http://cran.rstudio.com/')\"" && \
				su - -c "R -e \"install.packages('here', repos = 'http://cran.rstudio.com/')\"" && \
				su - -c "R -e \"install.packages('magrittr', repos = 'http://cran.rstudio.com/')\"" && \
				su - -c "R -e \"install.packages('dply', repos = 'http://cran.rstudio.com/')\"" && \
				su - -c "R -e \"install.packages('lubridate', repos = 'http://cran.rstudio.com/')\"" && \
				su - -c "R -e \"install.packages('plotly', repos = 'http://cran.rstudio.com/')\"" && \
				su - -c "R -e \"install.packages('devtools', repos = 'http://cran.rstudio.com/')\"" && \
				su - -c "R -e \"devtools::install_github('tidyverse/ggplot2')\""

		ADD ./configs/shiny-server.conf /etc/shiny-server/shiny-server.conf

EXPOSE 3838
EXPOSE 8081
EXPOSE 8080
