FROM fluent/fluentd
USER root
RUN ["apk", "update"]
RUN ["apk", "add", "--no-cache", "build-base"]
RUN ["apk", "add", "ruby-dev"]
RUN ["gem", "install", "fluent-plugin-influxdb"]
RUN ["gem", "install", "fluent-plugin-influxdb-v2"]
RUN ["gem", "list"]
