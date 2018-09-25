# Deploying nuppu on an Ubuntu machine

Before we begin, there are a few steps that need to be done for first-time use.

### Installing Docker in Ubuntu (first use)

The deployment relies entirely on docker. If the machine doesn't have docker, then you need to install it.

```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update && sudo apt-get install -y docker-ce
```

### Setting up letsencrypt certificates (first use)

Getting certs from letsencrypt is as simple as running:

```bash
docker run -it --name certbot \
    -v "$(pwd)/certbot:/etc/letsencrypt" \
    certbot/certbot certonly --manual --preferred-challenges dns-01 \
    -m hello@naamio.cloud --cert-name naamio.cloud \
    -d naamio.cloud,www.naamio.cloud,staging.naamio.cloud
```

... and following the steps to verify your ownership. If it was successful, your private key and cert will be available in `certbot/live/naamio.cloud`.

## Preparing nuppu

1. Build the image locally using `make build-container`, and then tag it using:

```
docker tag naamio/nuppu:nightly registry.gitlab.com/naamio/nuppu:nightly
```

2. `docker login registry.gitlab.com` (if you haven't already) and push the image.

> **NOTE:** You need an access token with the `api` scope.

3. Push the image:

```bash
docker push registry.gitlab.com/naamio/nuppu:nightly
```

## Deploying nuppu

1. In your droplet, `docker login registry.gitlab.com`

> **NOTE:** Here, it's fine if you have an access token with `read_registry` scope.

2. Create a network (if there isn't one already).

``` bash
docker network create naamio-net
```

3. `scp` the content and rasters to the machine:

```bash
scp -r ${path-to-content-dir} root@${MACHINE_IP}:~/
scp -r ${path-to-rasters-dir} root@${MACHINE_IP}:~/
```

4. Now, run the container:

```bash
docker run -it -d --name nuppu --network naamio-net \
    -v "~/content:/usr/share/naamio/nuppu/content" \
    -v "~/rasters:/usr/share/naamio/nuppu/assets/images/rasters" \
    registry.gitlab.com/naamio/nuppu:nightly
```

## Deploying nginx

Nginx should be deployed only after its dependencies are deployed.

1. `scp` the `deploy/nginx` directory from the repository:

```bash
scp -r deploy/nginx root@${MACHINE_IP}:~/
```

2. Now, run the nginx container:

```bash
docker run -it -d -p 80:80 -p 443:443 \
    --network naamio-net --name nginx \
    -v ~/nginx/nginx.conf:/etc/nginx/nginx.conf:ro \
    -v ~/nginx/default.conf:/etc/nginx/conf.d/default.conf:ro \
    -v ~/certbot:/etc/certs nginx:alpine
```

## Updating the images/containers

In order to update nuppu:

 - The new image should be pulled with: `docker pull registry.gitlab.com/naamio/nuppu:nightly`
 - The existing container should be removed with: `docker rm -f nuppu`
 - Launch the new container as shown above.
 - Nginx doesn't have to touched during this process. But, if the nginx config is modified, then the container needs to be removed and re-launched (**do not restart**).

There are some useful commands to keep things clean.

- For removing all existing containers, run `docker rm -f $(docker ps -a | awk '{print $1}')`
- To remove all images, run `docker rmi $(docker images | awk '{print $3}')`
