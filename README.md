#######################
### fluentd_sandbox ###
#######################

Playing around with fluentd and linking with grafana.

#########################################################
### Running fluentd with Docker (default config file) ###
#########################################################

Pull the image from dockerhub:
```
$ docker pull fluent/fluentd
```
Run the image [source: https://hub.docker.com/r/fluent/fluentd/]:
```
$ docker run -d -p 24224:24224 -p 24224:24224/udp -v $(pwd)/log:/fluentd/log fluent/fluentd
```
This will initiate and run fluentd in a docker container, using the config file located
inside the container here:

/fluentd/etc/fluent.conf

You can view this file by initiating a 'sh' shell in the docker container:

```
$ docker exec -it <container_name> sh
# cat /fluentd/etc/fluent.conf
```


```
-----------------------------------------------------------
<source>
  @type  forward
  @id    input1
  @label @mainstream
  port  24224
</source>

<filter **>
  @type stdout
</filter>

<label @mainstream>
  <match docker.**>
    @type file
    @id   output_docker1
    path         /fluentd/log/docker.*.log
    symlink_path /fluentd/log/docker.log
    append       true
    time_slice_format %Y%m%d
    time_slice_wait   1m
    time_format       %Y%m%dT%H%M%S%z
  </match>
  <match **>
    @type file
    @id   output1
    path         /fluentd/log/data.*.log
    symlink_path /fluentd/log/data.log
    append       true
    time_slice_format %Y%m%d
    time_slice_wait   10m
    time_format       %Y%m%dT%H%M%S%z
  </match>
</label>
----------------------------------------------------------
```

#################################################
### Running fluentd with a custom config file ###
#################################################

This repo contains a config file at the root:   in_http_out_stdout.conf
[source:  https://docs.fluentd.org/quickstart/life-of-a-fluentd-event]
Note: I changed the source port 8888 in the config to 24224 to match the port exposures above.

To run fluentd with this config file, mount the root directory into the container,
and tell fluentd to use this config file with the '-c' option:
```
$ docker run -p 24224:24224 -p 24224:24224/udp -v $(pwd):/fluentd/etc -v $(pwd)/log:/fluentd/log fluent/fluentd fluentd -c /fluentd/etc/in_http_out_stdout.conf
```
Send a HTTP POST request to fluentd with a JSON data attachment:
```
$ curl -i -X POST -d 'json={"action":"login","user":2}' http://localhost:24224/test.cycle
```
fluentd's console output will happily acknowledge receipt of this json:
```
> 2022-10-20 15:16:11.745130390 +0000 test.cycle: {"action":"login","user":2}
```

####################################
### Using the file output plugin ###
####################################

The config file 'in_http_out_file.conf' output logs to a file, instead of
'stdout' like above example.

[Source: https://docs.fluentd.org/output/file]

```
<match test.file>
  @type file
  path /fluentd/log
  <buffer>
    timekey 5s
    timekey_use_utc true
    timekey_wait 10m
  </buffer>
</match>
```
```
$ docker run -p 24224:24224 -p 24224:24224/udp -v $(pwd):/fluentd/etc -v $(pwd)/log:/fluentd/log fluent/fluentd fluentd -c /fluentd/etc/in_http_out_file.conf
```

The logs will appear under the log/ directory.



############
### Loki ###
############

Run loki and promtail:
https://grafana.com/docs/loki/latest/installation/docker/


Run grafana:
https://grafana.com/docs/grafana/latest/setup-grafana/installation/docker/

Access grafana web app:
http://localhost:3000/login

