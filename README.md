# Gadgetbridge to InfluxDB

This script was originally written to fetch a [Gadgetbridge](https://www.gadgetbridge.org/) database export from a WebDAV server (in my case, [Nextcloud](https://nextcloud.com/)) and then query it to extract stats from Huami devices such as the Amznfit Bip.

Original design and build notes are in [MISC#34](https://projects.bentasker.co.uk/gils_projects/issue/jira-projects/MISC/34.html), however when first written it turned out that the Bip 3 was not Gadgetbridge compatible, so I had to [take another route](https://www.bentasker.co.uk/posts/blog/software-development/extracting-data-from-zepp-app-for-local-storage-in-influxdb.html). However, it has since [become possible](https://projects.bentasker.co.uk/gils_projects/issue/jira-projects/MISC/34.html#comment5397) to use the Bip with Gadgetbridge.


----

### GadgetBridge configuration

See [this comment](https://projects.bentasker.co.uk/gils_projects/issue/jira-projects/MISC/34.html#comment5064) for details on how to configure Gadgetbridge to periodically export its database.

----

### Configuration

The script is designed to be run in an ephemeral container, so pulls configuration from environment variables

- `WEBDAV_URL`: The webdav server URL. If you're using nextcloud, this will be `https://[nextcloud domain]/remote.php/dav/`
- `WEBDAV_USER`: WebDAV username
- `WEBDAV_PASS`: WebDAV Password
- `WEBDAV_PATH`: Path to the export directory on the webdav server (in my case it was `files/service_user/GadgetBridge/`
- `EXPORT_FILE`: The filename of the export file on the webdav server (I called mine `gadgetbridge`)
- `QUERY_DURATION`: What time period (in seconds) should we query? Default is `86400`
- `INFLUXDB_URL`: URL of your InfluxDB server
- `INFLUXDB_TOKEN`: Your influxDB token (or `user:pass` if you're on 1.x)
- `INFLUXDB_ORG`: Your InfluxDB org name or ID
- `INFLUXDB_BUCKET`: The bucket/database to write into
- `INFLUXDB_MEASUREMENT`: The measurement to write into (Default `gadgetbridge`)
- `SLEEP_HOURS`: Comma seperated list of hours to consider as sleeping hours for stress averaging purposes (default `0,1,2,3,4,5,6`)


----

### Running

The script is designed to be run from a container, so the easiest invocation route is
```sh 
docker run --rm \
-e WEBDAV_URL=https://nextcloud.example.invalid/remote.php/dav \
.. etc .. \
bentasker12/gadgetbridge_to_influxdb:latest
```

However, if you want to run directly, install the dependencies
```sh 
pip install webdavclient3 influxdb-client
```

Then, having exported the necessary env vars, simply invoke the script
```sh 
./app/gadgetbridge_to_influxdb.py
```

If, instead, you want to schedule runs in Kubernetes see [the example config](https://projects.bentasker.co.uk/gils_projects/issue/jira-projects/MISC/34.html#comment5083)

----

### License

Copyright (c) 2023 B Tasker
Released under [BSD 3-Clause License](https://www.bentasker.co.uk/pages/licenses/bsd-3-clause.html)
