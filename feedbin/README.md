<!--
.. title: Self-hosting Feedbin with Docker and OpenShift
.. slug: feedbin
.. date: 2018-05-25 12:32:49 UTC-05:00
.. tags: feed, atom, rss, docker, openshift
.. description:
.. type: text
-->

[Feedbin](https://feedbin.com) is an excellent RSS feed reader. You can sign up for its service and support its development. The company is gracious enough to offer its [source code](https://github.com/feedbin/feedbin) for DIYers to play with.

## Prerequisites
API keys for [Stripe](https://stripe.com/) and [Skylight](https://www.skylight.io) are required for running Feedbin. In addition, you need to pick a password for the PostgreSQL database. Populate the information in these two files:

`db.env`:
~~~
POSTGRES_PASSWORD=ChangeMe!
POSTGRES_DB=feedbin
POSTGRES_USER=feedbin
~~~

`secrets.env`:
~~~
PUSH_URL=http://feedbin.yourdomain.tls
SECRET_KEY_BASE=48_bit_secret
SKYLIGHT_AUTHENTICATION=
STRIPE_API_KEY=
STRIPE_PUBLIC_KEY=
~~~

## Running Feedbin with Docker

You can find two Docker images [here](https://hub.docker.com/r/rocwhite/feedbin/) and [here](https://hub.docker.com/r/rocwhite/feedbin-aio/). The first image has to be used together with postgres, redis, memcached, elasticsearch, and nginx. The second image is all-in-one, minus postgres.

For the all-in-one image, you just need [docker-compose.yml](https://raw.githubusercontent.com/rocwhite123/Dockerfile/master/feedbin/docker-compose.yml) in the same directory as the two files above. Then, run `docker-compose up -d`, and your Feedbin instance can be found at http://localhost:3000

With the other image, use [aio.yml](https://raw.githubusercontent.com/rocwhite123/Dockerfile/master/feedbin/aio.yml) instead, along with a `nginx.conf` [file](https://raw.githubusercontent.com/rocwhite123/Dockerfile/master/feedbin/nginx.conf).

## Running Feedbin on OpenShift
You probably need a Pro instance with > 1GB memory to run Feedbin. Once you create a new project, import `db.env` and `secrets.env` (see above) as secrets:

~~~
oc create secret generic feedbin-db --from-env-file=./db.env --type=opaque
oc create secret generic feedbin-secrets --from-env-file=./secrets.env --type=opaque
~~~

Then create a new app using the template [file](https://raw.githubusercontent.com/rocwhite123/Dockerfile/master/feedbin/openshift-aio.yml).
~~~
oc new-app -f ./openshift-aio.yml
~~~
