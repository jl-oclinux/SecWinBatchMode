
.PHONY: all clean start

all: start

start: /tmp/swmh/etc/hooks.json
	mkdir -p /tmp/swmh/run
	webhook -hooks /tmp/swmh/etc/hooks.json -verbose

/tmp/swmh/etc/hooks.json: hooks.json
	mkdir -p /tmp/swmh/etc
	sed -e 's#__PWD__#$(PWD)#;' hooks.json > $@

clean:
	rm -rf /tmp/swmh
