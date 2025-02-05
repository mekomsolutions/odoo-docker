from python:3.9-slim

# Generate locale C.UTF-8 for postgres and general locale data
ENV LANG C.UTF-8
ARG ODOO_BRANCH=14.0

# Install dependencies
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    git npm postgresql-client python3-dev libxml2-dev libxslt1-dev libldap2-dev libsasl2-dev \
    libtiff5-dev zlib1g-dev libfreetype6-dev wait-for-it xvfb libfontconfig moreutils fontconfig wget \
    liblcms2-dev libwebp-dev libharfbuzz-dev libfribidi-dev libxcb1-dev libpq-dev gettext-base unzip \
    xfonts-75dpi xfonts-base \
    && rm -rf /var/lib/apt/lists/*
RUN  arch=$(arch | sed s/aarch64/arm64/ | sed s/x86_64/amd64/) && \
    wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-3/wkhtmltox_0.12.6.1-3.bookworm_${arch}.deb && \
    dpkg -i wkhtmltox_0.12.6.1-3.bookworm_${arch}.deb &&  cp /usr/local/bin/wkhtmltopdf /usr/bin && cp /usr/local/bin/wkhtmltoimage /usr/bin
RUN pip3 install --upgrade pip
RUN pip3 install phonenumbers
RUN pip3 install python-jose
RUN pip install pip setuptools wheel Cython==3.0.0a10
RUN pip install gevent==20.9.0 --no-build-isolation
RUN npm install -g rtlcss

RUN mkdir -p /opt/odoo
RUN cd /tmp/ && wget https://github.com/mekomsolutions/odoo/archive/refs/heads/${ODOO_BRANCH}.zip \
    && unzip /tmp/${ODOO_BRANCH}.zip && mv /tmp/odoo-${ODOO_BRANCH}/* /opt/odoo/ && rm /tmp/${ODOO_BRANCH}.zip
RUN cd /opt/odoo && pip3 install -r requirements.txt

# Expose Odoo services
EXPOSE 8069 8071 8072
VOLUME ["/var/lib/odoo"]

# Set the default config file
RUN mkdir -p /etc/odoo /mnt/extra-addons
COPY resources/odoo.conf /etc/properties/odoo.conf
ENV ODOO_RC /etc/odoo/odoo.conf

# Copy entrypoint script
COPY resources/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["odoo"]
