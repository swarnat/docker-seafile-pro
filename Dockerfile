FROM swarnat/ubuntu_dumb-init_gosu:22.04
MAINTAINER Stefan Warnat <ich@stefanwarnat.de>

ARG SEAFILE_VERSION=11.0.16

ARG TZ=Etc/UTC
ARG DEBIAN_FRONTEND=noninteractive

# Security
RUN mkdir -p /etc/container_environment && \
    echo -n no > /etc/container_environment/INITRD && \
    apt-get update --fix-missing && apt-get upgrade -y && \
    export DEBIAN_FRONTEND=noninteractive && apt install -y language-pack-en vim htop net-tools psmisc wget curl git unzip && \
    locale-gen en_US && update-locale LANG=en_US.UTF-8 LC_CTYPE=en_US.UTF-8 && \
    echo -n en_US.UTF-8 > /etc/container_environment/LANG && \
    echo -n en_US.UTF-8 > /etc/container_environment/LC_CTYPE && \
    apt-get install -y tzdata \
    nginx \
    libmysqlclient-dev \
    libmemcached11 libmemcached-dev \
    libxmlsec1 xmlsec1 \
    zlib1g-dev pwgen openssl poppler-utils \
    fuse \
    ldap-utils libldap2-dev ca-certificates dnsutils \
    clamdscan iputils-ping \
    ttf-wqy-microhei ttf-wqy-zenhei xfonts-wqy && \
    apt-get install -y python3 python3-pip python3-setuptools python3-ldap python3-rados && \
    rm -f /usr/bin/python && ln -s /usr/bin/python3 /usr/bin/python && \
    python3 -m pip install --upgrade pip -i https://pypi.tuna.tsinghua.edu.cn/simple/ && rm -r /root/.cache/pip && \
    apt clean && rm -rf /var/lib/apt/lists/*

RUN pip3 install --timeout=3600 click termcolor colorlog pymysql django==4.2.* \
    future==0.18.* mysqlclient==2.1.* pillow==10.2.* pylibmc captcha==0.5.* markupsafe==2.0.1 jinja2 \
    sqlalchemy==2.0.18 django-pylibmc django_simple_captcha==0.6.* pyjwt==2.6.* djangosaml2==1.5.* pysaml2==7.2.* pycryptodome==3.16.* cffi==1.15.1 \
    boto3 oss2 twilio python-ldap==3.4.3 configparser psd-tools lxml \
    -i https://pypi.tuna.tsinghua.edu.cn/simple/ && rm -r /root/.cache/pip


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
