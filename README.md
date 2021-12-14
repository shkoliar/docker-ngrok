# Docker Ngrok

A Docker image for [ngrok](https://ngrok.com) service to expose a local docker environment or any other local server to the public internet over secure tunnels. The image is built using official [busybox:glibc](https://hub.docker.com/_/busybox) docker image, so no third party libraries are used, only official busybox and ngrok binary.

## Usage

### Command-line

**Example**  
The example below assumes that you have running web server docker container named `dev_web_1` with exposed port `80`.

```bash
docker run --rm -it --link dev_web_1 shkoliar/ngrok http dev_web_1:80
```

With command line usage, ngrok session is active until it won't be terminated by `Ctrl+C` combination.

#### Command details

**Using ngrok parameters**

```bash
docker run --rm -it --link <web-container-name> [--net <default-netowrk-name>] shkoliar/ngrok <ngrok-parameters> <web-container-name>:<port>
```

For information about ngrok parameters, please refer to [ngrok documentation](https://ngrok.com/docs).

**Passing parameters to ngrok via env variables**

```bash
docker run --rm -it --link <web-container-name> [--net <default-netowrk-name>] --env DOMAIN=<web-container-name> --env PORT=<port> shkoliar/ngrok
```

Available env variables can be found below, at [environment variables](#environment-variables) section.

#### Troubleshooting

_If you are getting an error like_

```bash
docker: Error response from daemon: Cannot link to /dev_web_1, as it does not belong to the default network.
```

_You need to specify default docker network, for example_

```bash
docker run --rm -it --link dev_web_1 --net dev_default shkoliar/ngrok http dev_web_1:80
```

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

| Name        | Values                     | Default   | Information                                                                                                                                                 |
| :---------- | :------------------------- | :-------- | :---------------------------------------------------------------------------------------------------------------------------------------------------------- |
| PROTOCOL    | http, tls, tcp             | http      | Ngrok tunneling protocol.                                                                                                                                   |
| DOMAIN      | \*                         | localhost | Hostname or docker container, service name which is referred to by ngrok.                                                                                   |
| PORT        | \*                         | 80        | Port which is referred to by ngrok.                                                                                                                         |
| REGION      | us, eu, ap, au, sa, jp, in | us        | Region where the ngrok client will connect to host its tunnels.                                                                                             |
| HOST_HEADER | \*                         |           | Optional, rewrite incoming HTTP requests with a modified Host header. e.g. `HOST_HEADER=localdev.test`                                                      |
| BIND_TLS    | true, false                |           | Optional, forward only HTTP or HTTPS traffic, but not both. By default, when ngrok runs an HTTP tunnel, it opens endpoints for both HTTP and HTTPS traffic. |
| SUBDOMAIN   | \*                         |           | Optional, specifies the subdomain to use with ngrok, if unspecified ngrok with generate a unique subdomain on each start.                                   |
| AUTH_TOKEN  | \*                         |           | Optional, token used to authorise your subdomain with ngrok.                                                                                                 |
| DEBUG       | true                       |           | Optional, write logs to stdout.                                                                                                                             |
| PARAMS      | \*                         |           | Pass all ngrok parameters by one string. When specified, any other env variables are skipped (Except AUTH_TOKEN).|

For more information about ngrok parameters, please refer to [ngrok documentation](https://ngrok.com/docs).

## License

[MIT](../../blob/master/LICENSE)
