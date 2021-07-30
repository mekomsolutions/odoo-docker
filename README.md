# Odoo Docker
<p align="left">
  <img src="readme/odoo_logo.png" width="200" title="Odoo">
  <img src="readme/plus.png" width="50" title="Docker">
  <img src="readme/docker_logo.png" width="100" title="Docker">
</p>

Resources to build custom Docker image for Odoo

## Run the project

```
docker-compose up
```

### Evironment variables

Additionnaly, the image will accept the following environment variable when run:

| Variable name                  | Default |                                    Description                                   |
|--------------------------------|---------|:--------------------------------------------------------------------------------:|
| `HOST`                         | db      | Database hostname                                                                |
| `PORT`                         | 5432    | Database port                                                                    |
| `USER`                         | odoo    | Database username                                                                |
| `PASSWORD`                     | odoo    | Database password                                                                |
| `DB_NAME`                      | odoo    | Database name                                                                    |
| `ADDONS`                       |         | List of addons to be pre-installed                                               |
| `INITIALIZER_CONFIG_FILE_PATH` |         | Odoo Intializer configuration path (only if Odoo Initializer addon is installed) |
| `INITIALIZER_DATA_FILES_PATH`  |         | Odoo Intializer data files path (only if Odoo Initializer addon is installed)    |


### Volumes

#### Data volumes
`/var/lib/odoo`: Odoo data files path

#### Other:
`/mnt/extra-addons`: Additional addons path. Any addon provided in this folder will be automatically installed on first start of the image.

`/etc/properties`: Path to provide alternative `odoo.conf` file
