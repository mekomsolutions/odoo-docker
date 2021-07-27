# odoo-docker
Resources files to build custom Docker image for Odoo

## Evironment variables

- **HOST**: Database hostname (default: `db`)
- **PORT**: Database port (default: `5432`)
- **USER**: Database username (default: `odoo`)
- **PASSWORD**: Database password (default: `odoo`)
- **DB_NAME**: Database name

## Volumes

- **/mnt/extra-addons**: Additional addons path
- **/var/lib/odoo**: Data files path
