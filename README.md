# odoo-docker
Resources files to build custom Docker image for Odoo

# Run the project

```
docker-compose up
```

## Evironment variables

- **HOST**: Database hostname (default: `db`)
- **PORT**: Database port (default: `5432`)
- **USER**: Database username (default: `odoo`)
- **PASSWORD**: Database password (default: `odoo`)
- **DB_NAME**: Database name (default: `odoo`)
- **ADDONS**: List of addons to be pre-installed
- **INITIALIZER_CONFIG_FILE_PATH**: odoo-intializer configuration path
- **INITIALIZER_DATA_FILES_PATH**: odoo-intializer data files path

## Volumes

Data volume
- **/var/lib/odoo**: Odoo data files path

Optional:
- **/mnt/extra-addons**: Additional addons path
- **/etc/properties**: Path to provide alternative `odoo.conf` file
