# OpenStack, CoreOS, BoatLoad.

## Follow the official guide (for the most part):
https://coreos.com/os/docs/latest/booting-on-openstack.html

## Obtain the image.
`wget http://stable.release.core-os.net/amd64-usr/current/coreos_production_openstack_image.img.bz2`

## Check the hash.
`wget http://stable.release.core-os.net/amd64-usr/current/coreos_production_openstack_image.img.bz2.DIGESTS`

`sha512sum coreos_production_openstack_image.img.bz2`

## Decompress.
`bunzip2 coreos_production_openstack_image.img.bz2`

## Use glance to upload the image.
`glance image-create --name CoreOS --container-format bare --disk-format qcow2 --file coreos_production_openstack_image.img --progress`

*Note*: You can try adding `--is-public True`, if your client supports it (mine didn't at the time).

## Edit the cloud-config.yaml file.
Change `<token>` to what you obtain from visiting https://discovery.etcd.io/new?size=X ,
where X is the initial size of your cluster (ex.: 3).

Change <your-public-key-here> to the SSH public key(s) you want attached to the instances.

## Create a security group on OpenStack.
The security group should include the following ports:

	Ingress: 22
	Ingress and Egress: 80, 443, 2379, 2380, 4001, 8080

## Launch the cluster.
Update and run the create-coreos-openstack-instances.sh script.
The script needs to be updated with the correct IDs (image, flavor, network),
user-data file (in this case, cloud-config.yaml), ssh key name,
cluster/instance name, and number of instances.

*Note*: It seems that the CoreOS image wants a flavor with at least 10GB disk space.

After running the script and receiving successful output from the nova client,
run `nova list` to see that the instances are being created (or are already
running).

## Attach to an instance.
`ssh -i <ssh-key> -A core@<ip-address>`

## Setup BoatLoad.
Reference the following document, if necessary:

https://bitbucket.org/keyz182/boatload/src/master/README-VAGRANT.TXT

### Clone the repository, start up services, and list units.

    git clone https://bitbucket.org/keyz182/boatload
    cd boatload/Docker/units

    fleetctl submit api.service satellite.service satellite-discovery.service
    fleetctl load api.service satellite.service satellite-discovery.service
    fleetctl start api.service satellite.service satellite-discovery.service

`fleetctl list-units`

to list the units, then you should be able to browse the API machine:

> api.service			9eb658f8.../<ip>	active	running

Visit the following to (hopefully) see the api/framework in place.

http://<ip>:8080/v1/container

*Note*: `<ip>` will be whatever shows up on your instance.

If on the instance running the api, run

`docker exec -i -t api /bin/sh`

to login to the docker container.
