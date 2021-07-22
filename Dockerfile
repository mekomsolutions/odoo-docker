from python:3.9-slim

# Generate locale C.UTF-8 for postgres and general locale data
ENV LANG C.UTF-8

# Install dependencies
RUN apt update && apt install -y git npm postgresql-client python3-dev libxml2-dev libxslt1-dev libldap2-dev libsasl2-dev \
    libtiff5-dev zlib1g-dev libfreetype6-dev wait-for-it \
    liblcms2-dev libwebp-dev libharfbuzz-dev libfribidi-dev libxcb1-dev libpq-dev
RUN npm install -g rtlcss

RUN git clone https://github.com/mekomsolutions/odoo.git /opt
RUN cd /opt && pip install -r requirements.txt

# Expose Odoo services
EXPOSE 8069 8071 8072

# Set the default config file
COPY resources/odoo.conf /etc/odoo/odoo.conf
ENV ODOO_RC /etc/odoo/odoo.conf

# Copy entrypoint script
COPY resources/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["odoo"]
