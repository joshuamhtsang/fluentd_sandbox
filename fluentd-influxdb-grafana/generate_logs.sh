for i in {1..1000}; do echo \{\"time\":$(($(date +"%s")+$i)),\"foo\":\"foo\",\"bar\":$RANDOM\} >> logs/logs.json; sleep 1; done
