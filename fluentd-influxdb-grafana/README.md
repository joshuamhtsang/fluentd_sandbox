# fluentd-influxdb2-grafana stack docker compose implementation

The docker compose yaml in this directory is based on the
one from this github repo:

https://github.com/Coac/fluentd-influxdb-grafana

To run, in this directory run:
```
$ docker compose up --build
```

To stop:
```
$ docker compose down
```

Many changes were needed (relative to Coac's exmaple) to make it work:
  1.  influxdb 2.0 has new set of env vars to initialize (see docker-compose.yml)
  2.  Need to install fluentd output plugin 'fluent-plugin-influxdb-v2' (see fluentd/Dockerfile)
  3.  Need to understand fluentd output plugin:  [https://github.com/influxdata/influxdb-plugin-fluent]
      (see fluentd/fluent.conf)
  4.  Flux requests instead of InfluxQL

Once running, it looks like this:
![Alt text](grafana_ss_1.png?raw=true "Optional Title")


I've sought inspiration from the offical dockerhub:

[https://hub.docker.com/_/influxdb]

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
```
Query Language : Flux
URL : http://influxdb:8086
Auth : Basic Auth (On)
Basic Auth Details: User (admin), PW (adminadmin)
InFluxDB Details: 
      Organisation : soundmouse
      Token : hahajaja
      Default Bucket : demo2
```

Click 'Save and Test' and you should see a green tick with: 
```
datasource is working. 3 buckets found
```

Now make a new Dashboard with a new panel.  The Flux query is:
```
from(bucket: "demo2")
  |> range(start: v.timeRangeStart, stop:v.timeRangeStop)
  |> filter(fn: (r) =>
    r._measurement == "flows" and
    r._field == "bar"
  )
```

Click 'Apply'.

To actually create data for fluentd to push to influxdb, run the
shell script which appends JSONs to the log file 'logs/logs.json':
```
$ bash generate_logs.sh
```


###############################
### Troubleshooting Journal ###
###############################

Update 26/10/2022: I noticed from 'docker ps' that it was only spinning up
2/3 containers: the grafana and fluentd containers, and not the influxdb container.  
To isolate the problem, I created another docker compose yaml file with just
the influxdb container, and noticed an error:  'password too short'.  So I 
now set a longer password for DOCKER_INFLUXDB_INIT_PASSWORD.  'docker ps'
now yields 3 containers running, and grafana can now add the influxdb
data source.  WOOHOO!


