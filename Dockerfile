FROM swarnat/ubuntu_dumb-init_gosu:22.04
MAINTAINER Stefan Warnat <ich@stefanwarnat.de>

ARG SEAFILE_VERSION=11.0.7

ARG TZ=Etc/UTC 
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && apt-get install -y tzdata python3.10 libpython3.10 python3-mysqldb openjdk-8-jre poppler-utils wget git \
      python3-setuptools python3-pil python3-ldap sqlite3 locales \
      python3-memcache curl ffmpeg python3-pip libmysqlclient-dev \
  && ln -s /usr/bin/python3 /usr/bin/python \
  && pip3 install --upgrade pip \
  && pip3 install lxml moviepy iniparse pysaml2==7.2.* djangosaml2==1.5.* pillow==9.3.* captcha==0.4 django-pylibmc django_simple_captcha==0.5.* setuptools_rust future==0.18.* mysqlclient==2.1.* sqlalchemy==1.4.3 \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /root/.cache/pip


RUN pip3 install --timeout=3600 Pillow pylibmc jinja2 \
    sqlalchemy django-pylibmc && \
    rm -r /root/.cache/pip

RUN pip3 install --timeout=3600 boto oss2 pycryptodome==3.16.* twilio python-ldap configparser cffi==1.15.1 && \
    rm -r /root/.cache/pip

RUN useradd -d /seafile -M -s /bin/bash -c "Seafile User" seafile && \
  mkdir -p /opt/haiwen /seafile/ && \
  wget -O seafile-pro-server_${SEAFILE_VERSION}_x86-64_Ubuntu.tar.gz \
    "https://download.seafile.com/d/6e5297246c/files/?p=/pro/seafile-pro-server_${SEAFILE_VERSION}_x86-64_Ubuntu.tar.gz&dl=1" && \
  tar -C /opt/haiwen -xzf seafile-pro-server_${SEAFILE_VERSION}_x86-64_Ubuntu.tar.gz &&\
  rm -f seafile-pro-server_${SEAFILE_VERSION}_x86-64_Ubuntu.tar.gz && \
  chown -R seafile:seafile /seafile /opt/haiwen && \
  dpkg-reconfigure locales


ENV OBJECT_LIST_FILE_PATH=/seafile/listfilepath/

COPY ["seafile-entrypoint.sh", "/usr/local/bin/"]

EXPOSE 8000 8082

ENTRYPOINT ["/usr/bin/dumb-init", "/usr/local/bin/seafile-entrypoint.sh"]
