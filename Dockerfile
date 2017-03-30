FROM ubuntu:xenial

# install latest python and nodejs
RUN dpkg --add-architecture i386
RUN apt-get -y update
RUN apt-get install -y software-properties-common curl git ca-certificates \
    software-properties-common
RUN add-apt-repository ppa:voronov84/andreyv
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -

# add yarn ppa
RUN add-apt-repository ppa:ubuntu-wine/ppa 
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get -y update
RUN apt-get install -y python2.7 python3.6 python-pip git nodejs yarn \
    gettext python-sphinx wine1.8 winetricks
COPY . /kolibri

VOLUME /kolibridist/  # for mounting the whl files into other docker containers
CMD cd /kolibri && pip install -r requirements/dev.txt && pip install -r requirements/build.txt && yarn install && make dist && cp /kolibri/dist/* /kolibridist/


# Build kolibri windows installer.
RUN cd / && git clone https://github.com/learningequality/kolibri-installers.git 
CMD cd kolibri-installers \
    && git checkout develop \
    && cd windows \
    && cp /kolibridist/*.whl ./ \
    && export KOLIBRI_BUILD_VERSION="$$(cat /kolibri/kolibri/VERSION)" \
    && wine inno-compiler/ISCC.exe installer-source/KolibriSetupScript.iss \
    && cp ./*.exe /kolibridist/
