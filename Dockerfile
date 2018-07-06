FROM ubuntu

MAINTAINER Deivid Sanches <deividsanches542@gmail.com>


#ADD REPOSITORY CRAN RSTUDIO
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
RUN add-apt-repository 'deb [arch=amd64,i386] https://cran.rstudio.com/bin/linux/ubuntu xenial/'

#install required packages
RUN apt-get update
RUN apt-get -y install python-pip
RUN apt-get -y install r-cran-rjava
RUN apt-get -y install r-base
RUN apt-get -y install gdebi-core
RUN apt-get -y build-dep libcurl4-gnutls-dev
RUN apt-get -y install libcurl4-gnutls-dev
RUN apt-get -y install apache2
RUN pip install awscli --upgrade --user
RUN wget https://download3.rstudio.org/ubuntu-12.04/x86_64/shiny-server-1.5.5.872-amd64.deb
RUN md5sum shiny-server-1.5.5.872-amd64.deb
RUN gdebi shiny-server-1.5.5.872-amd64.deb -n

# Install required packages for Dashboard
RUN su - -c "R -e \"install.packages('shiny', repos='http://cran.rstudio.com/')\""
RUN su - -c "R -e \"install.packages('shinydashboard', repos = 'http://cran.rstudio.com/')\""
RUN su - -c "R -e \"install.packages('scales', repos = 'http://cran.rstudio.com/')\""
RUN su - -c "R -e \"install.packages('ggthemes', repos = 'http://cran.rstudio.com/')\""
RUN su - -c "R -e \"install.packages('googleVis', repos = 'http://cran.rstudio.com/')\""
RUN su - -c "R -e \"install.packages('rJava', repos = 'http://cran.rstudio.com/')\""
RUN su - -c "R -e \"install.packages('RJDBC', repos = 'http://cran.rstudio.com/')\""
RUN su - -c "R -e \"install.packages('here', repos = 'http://cran.rstudio.com/')\""
RUN su - -c "R -e \"install.packages('magrittr', repos = 'http://cran.rstudio.com/')\""
RUN su - -c "R -e \"install.packages('dply', repos = 'http://cran.rstudio.com/')\""
RUN su - -c "R -e \"install.packages('lubridate', repos = 'http://cran.rstudio.com/')\""
RUN su - -c "R -e \"install.packages('plotly', repos = 'http://cran.rstudio.com/')\""
RUN su - -c "R -e \"install.packages('devtools', repos = 'http://cran.rstudio.com/')\""
RUN su - -c "R -e \"devtools::install_github('tidyverse/ggplot2')\""

EXPOSE 3838

#ADD ./configs/shyni-server.conf /etc/shyni-server/

#Dashboard Port Configurator
#echo "Informe qual porta deseja instalar o Dashboard" 
#read port
#  if [ "$port" ] ; then
#         echo "Porta $port Escolhida " 
#    else
#sudo sed  -i "s/3838/$port/g" /etc/shiny-server/shiny-server.conf
#  fi
#sudo sed  -i "s/3838/$port/g" /etc/shiny-server/shiny-server.conf

# Clone Dashboard Repository
#cd /srv/shiny-server/
#sudo git clone https://git-codecommit.sa-east-1.amazonaws.com/v1/repos/sharecare-rshiny-dashboard
#sudo systemctl restart shiny-server

#Configure Apache Server
#sudo a2enmod proxy
#sudo a2enmod proxy_http

#sudo egrep -v "^#|^$"  /etc/apache2/sites-available/000-default.conf >  /etc/apache2/sites-available/000-default.conf
#sudo mkdir passwd
#sudo touch /etc/apache2/passwd/.htpasswd
#sudo service apache2 restart
