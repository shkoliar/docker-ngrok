# Docker Ngrok

A Docker image for <a href="https://ngrok.com" target="_blank" rel="noopener">ngrok</a> service to expose a local docker environment or any other local server to the public internet over secure tunnels. The image is built using official <a href="https://hub.docker.com/_/busybox" target="_blank" rel="noopener">busybox:glibc</a> docker image, so no third party libraries are used, only official busybox and ngrok binary.  

## Usage  

### Command-line

**Using ngrok parameters:** 
```
$ docker run --rm -it --link <web_container_name> [--net <docker_netowrk_name>] shkoliar/ngrok ngrok <ngrok parameters> <web_container_name>:<port>
``` 
For information about ngrok parameters, please refer to <a href="https://ngrok.com/docs" target="_blank" rel="noopener">ngrok documentation</a>.

**Passing parameters to ngrok via env variables:**   
```
$ docker run --rm -it --link <web_container_name> [--net <docker_netowrk_name>] --env DOMAIN=<web_container_name> --env PORT=<port> shkoliar/ngrok
``` 
Available env variables can be found below, at [environment variables](#environment-variables) section.

**Example:**
  
The example below assumes that you have running web server docker container named `dev_web_1` with exposed port 80.
```bash
$ docker run --rm -it --link dev_web_1 shkoliar/ngrok ngrok http dev_web_1:80
```

With command line usage, ngrok session is active until it won't be terminated by `Control+C` combination.

### As part of docker-compose.yml file 

```yaml
ngrok:
    image: shkoliar/ngrok:latest
    ports:
      - 4551:4551
    links:
      - web
    environment:
      - DOMAIN=web
      - PORT=80
```

Where `web` in example above is a web server service name of this docker-compose.yml file.

If ngrok container is created as part of docker-compose.yml file, ngrok session is active while container is running. To restart or stop session, you will need to restart or stop container respectively.
Ngrok web interface available at `http://localhost:4551`.

 
## Environment variables

List of available environment variables to configure ngrok in command line usage or as part of docker-compose.yml file.

Name|Values|Default|Information
:---|:---|:---|:---
PROTOCOL|http, tls, tcp|http|Ngrok tunneling protocol.
DOMAIN|*|localhost|Hostname or docker container, service name which is referred to by ngrok.
PORT|*|80|Port which is referred to by ngrok.
REGION|us, eu, ap, au, sa, jp, in|us|Region where the ngrok client will connect to host its tunnels.
HOST_HEADER|*| |Optional, rewrite incoming HTTP requests with a modified Host header. e.g. `HOST_HEADER=localdev.test`
BIND_TLS|true, false| |Optional, forward only HTTP or HTTPS traffic, but not both. By default, when ngrok runs an HTTP tunnel, it opens endpoints for both HTTP and HTTPS traffic. 
DEBUG|true| |Optional, write logs to stdout.
PARAMS|*| |Pass all ngrok parameters by one string. When specified, any other env variables are skipped.

For more information about ngrok parameters, please refer to <a href="https://ngrok.com/docs" target="_blank" rel="noopener">ngrok documentation</a>.

## License

[MIT](../../blob/master/LICENSE)
