The docker compose yaml in this directory is based on the
one from this github repo:

https://github.com/Coac/fluentd-influxdb-grafana

To run:

$ docker compose up

However, there are problems getting grafana to add
influxdb as a data source.  I suspect the docker compose 
yaml above is based on the older influxdb v1.8, while the
latest release is 2.0+.

I've sought inspiration from the offical dockerhub:

[https://hub.docker.com/_/influxdb]_

Especially the docker run example for influxdb 2.0+ there:

```
$ docker run -d -p 8086:8086 \
      -v $PWD/data:/var/lib/influxdb2 \
      -v $PWD/config:/etc/influxdb2 \
      -e DOCKER_INFLUXDB_INIT_MODE=setup \
      -e DOCKER_INFLUXDB_INIT_USERNAME=my-user \
      -e DOCKER_INFLUXDB_INIT_PASSWORD=my-password \
      -e DOCKER_INFLUXDB_INIT_ORG=my-org \
      -e DOCKER_INFLUXDB_INIT_BUCKET=my-bucket \
      -e DOCKER_INFLUXDB_INIT_RETENTION=1w \
      -e DOCKER_INFLUXDB_INIT_ADMIN_TOKEN=my-super-secret-auth-token \
      influxdb:2.0
```

In grafana, add a new data source and use the 'Flux' query
language and match the settings to the environmental variables
set in the docker compose file.

This seems to get a bit further but I still can't be a successful 
addition of influxdb data source into grafana.  Very frustrating.

