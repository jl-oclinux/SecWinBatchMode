# Webhook server example / SWMH

We use the webhook server written in the go language https://github.com/adnanh/webhook.
This folder containing a server configuration and two hooks is just a proof-of-concept of a webhook server for SWMB.
The aim is to send a special tweak to a computer.
In reality, you need an https server like Apache or Nginx acting as a reverse proxy upstream of the webhook server, and a real TLS certificate.

We use the acronym SWMH for Secure Windows Mode Hook.

Install the server
```bash
apt install webhook
```

Run it by
```bash
make start
```

Some test
```bash
# simple hello test
curl -X POST -H 'Content-Type: application/json' --data '{"swmb": {"msg": "Hello The World"}}' http://localhost:9000/hooks/hello

# variable test
curl -X POST -H 'Content-Type: application/json' --data '{"token": 432, "swmb": {"hostname":"mywin", "hostid":"fjjkfhjkj", "osversion": "10.0.45", "username":"toto", "isadmin": false, "version":"3.6.9"}}' http://localhost:9000/hooks/swmh?status=boot

# token in URL test
curl -X POST -H 'Content-Type: application/json' --data '{"swmb": {"msg": "Hello The World"}}' http://localhost:9000/hooks/swmh?token=432&status=logon

# logon test
curl -X POST -H 'Content-Type: application/json' --data '{"token": 432, "swmb": {"hostname":"abcmywin", "hostid":"fjjkfhjkj", "osversion": "10.0.45", "username":"toto", "isadmin": false, "version":"3.6.9"}}' http://localhost:9000/hooks/swmh?status=logon
```

Have a nice hook JSON configuration file
```
cat hooks.json | jq --color-output  # with jq / better
cat hooks.json | json_pp            # use Perl JSON
```
