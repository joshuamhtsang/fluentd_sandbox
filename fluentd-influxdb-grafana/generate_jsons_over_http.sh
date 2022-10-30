for i in {1..1000}; do echo \{\"time\":$(($(date +"%s")+$i)),\"foo\":\"foo\",\"bar\":$RANDOM\} >> logs/logs.json; sleep 1; done

curl -X POST -d 'json={"time":1667149355,"foo":"foo","bar":1270}' http://localhost:24224/default.logs -v