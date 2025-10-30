# FROM registry.access.redhat.com/ubi9/python-39:1-1758500249
FROM eclipse/stack-base:ubuntu
RUN sudo apt-get purge -y python.* &&   sudo apt-get update &&   sudo apt-get install -y --no-install-recommends \
    autoconf \
    automake \
    bzip2 \
    file \
    g++ \
    gcc \
    imagemagick \
    libbz2-dev \
    libc6-dev \
    libcurl4-openssl-dev libdb-dev libevent-dev libffi-dev libgdbm-dev libgeoip-dev libglib2.0-dev libjpeg-dev \
    libkrb5-dev liblzma-dev libmagickcore-dev libmagickwand-dev libmysqlclient-dev libncurses-dev libpng-dev \
    libpq-dev libreadline-dev libsqlite3-dev libssl-dev libtool libwebp-dev libxml2-dev libxslt-dev libyaml-dev make patch xz-utils zlib1g-dev
ENV LANG=C.UTF-8
ENV GPG_KEY=97FC712E4C024BBEA48A61ED3A5CA953F73C700D
ENV PYTHON_VERSION=3.5.1
ENV PYTHON_PIP_VERSION=9.0.1
RUN set -ex && sudo curl -fSL "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz" -o python.tar.xz && sudo curl -fSL "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz.asc" -o python.tar.xz.asc && export GNUPGHOME="$(mktemp -d)" && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$GPG_KEY" && gpg --batch --verify python.tar.xz.asc python.tar.xz && sudo rm -r "$GNUPGHOME" python.tar.xz.asc && sudo mkdir -p /usr/src/python && sudo tar -xJC /usr/src/python --strip-components=1 -f python.tar.xz && sudo rm python.tar.xz && cd /usr/src/python && sudo ./configure --enable-shared --enable-unicode=ucs4 && sudo make -j$(nproc) && sudo make install && sudo ldconfig && sudo pip3 install --upgrade --ignore-installed pip==$PYTHON_PIP_VERSION && sudo find /usr/local \( -type d -a -name test -o -name tests \) -o \( -type f -a -name '*.pyc' -o -name '*.pyo' \) -exec rm -rf '{}' + && sudo rm -rf /usr/src/python
RUN cd /usr/local/bin && sudo ln -s easy_install-3.5 easy_install && sudo ln -s idle3 idle && sudo ln -s pydoc3 pydoc && sudo ln -s python3 python && sudo ln -s python-config3 python-config
RUN sudo pip install --upgrade pip && \
    sudo pip install --no-cache-dir virtualenv && \
    sudo pip install --upgrade setuptools && \
    sudo pip install 'python-language-server[all]'

# By default, listen on port 8081
#EXPOSE 8081/tcp
#ENV FLASK_PORT=8081

# Set the working directory in the container
WORKDIR /projects

# Copy the content of the local src directory to the working directory
COPY . .

# Install any dependencies
RUN sudo -H  pip install requirements.txt
  # if [ -f requirements.txt ]; \
    # then pip install -r requirements.txt; \
 # elif [ `ls -1q *.txt | wc -l` == 1 ]; \
   # then pip install -r *.txt; \
  # fi
EXPOSE 8080 
# Specify the command to run on container start
#CMD [ "python", "-m virtualenv .venv && source .venv/bin/activate && .venv/bin/pip install -r requirements.txt" ]

