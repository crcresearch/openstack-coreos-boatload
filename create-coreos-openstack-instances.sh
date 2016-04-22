IMAGE_ID=""
FLAVOR_ID=""
USER_DATA="./cloud-config.yaml"
KEY_NAME=""
NUM_INSTANCES=3
SECURITY_GROUPS="default"
NETWORK_ID=""
NAME=""

nova boot \
	--user-data $USER_DATA \
	--image $IMAGE_ID \
	--key-name $KEY_NAME \
	--flavor $FLAVOR_ID \
	--num-instances $NUM_INSTANCES \
	--security-groups $SECURITY_GROUPS \
	--nic net-id=$NETWORK_ID \
	$NAME
# num-instances is deprecated.
#  update to use min-count and max-count.
