#curl -X POST -d 'json={"time":1667149355,"foo":"foo","bar":1270}' http://localhost:24224/default.logs -v


for i in {1..2000}; do time_now=$(date +%s); curl -X POST -d 'json={"time":'${time_now}',"foo":"foo","bar":'${RANDOM}'}' http://localhost:24224/default.logs -v; sleep 1; done