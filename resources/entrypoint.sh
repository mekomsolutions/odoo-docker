#!/bin/bash

set -e

# set the postgres database host, port, user and password according to the environment
# and pass them as arguments to the odoo process if not present in the config file
: ${HOST:=${DB_PORT_5432_TCP_ADDR:='db'}}
: ${PORT:=${DB_PORT_5432_TCP_PORT:=5432}}
: ${USER:=${DB_ENV_POSTGRES_USER:=${POSTGRES_USER:='odoo'}}}
: ${PASSWORD:=${DB_ENV_POSTGRES_PASSWORD:=${POSTGRES_PASSWORD:='odoo'}}}

: ${ODOO_ADDONS_PATH='/mnt/extra-addons/'}
: ${INSTALL_ADDONS_LIST:=$INSTALL_ADDONS}
DB_ARGS=()
function check_config() {
    param="$1"
    value="$2"
    if ! grep -q -E "^\s*\b${param}\b\s*=" "$ODOO_RC" ; then
        DB_ARGS+=("--${param}")
        DB_ARGS+=("${value}")
   fi;
}
check_config "db_host" "$HOST"
check_config "db_port" "$PORT"
check_config "db_user" "$USER"
check_config "db_password" "$PASSWORD"

if [ -f /etc/properties ]; then
    for file in /etc/properties/*; do
        name=$(basename "${file}")
        envsubst < ${file} > /etc/odoo/${name}
    done
fi

extra_addons=""
if [ ! -z "$INSTALL_ADDONS_LIST" ]; then
    extra_addons="-i $INSTALL_ADDONS_LIST"
elif [ -f "${ODOO_ADDONS_PATH}/addons.txt" ]; then
    extra_addons="-i $INSTALL_ADDONS_LIST"
fi

wait-for-it --timeout=3600 ${HOST}:${PORT}

case "$1" in
    -- | odoo)
        shift
        if [[ "$1" == "scaffold" ]] ; then
            exec python3 "/opt/odoo/odoo-bin --config /etc/odoo/odoo.conf $@"
        else
            exec `python3 /opt/odoo/odoo-bin --config /etc/odoo/odoo.conf --without-demo=all $extra_addons -d ${DB_NAME} ${DB_ARGS[@]}`
            exit
        fi
        ;;
    -*)
        exec `python3 /opt/odoo/odoo-bin --config /etc/odoo/odoo.conf --without-demo=all $extra_addons -d ${DB_NAME} $@ ${DB_ARGS[@]}`
        exit
        ;;
    *)
        exec "$@"
esac

exit 1