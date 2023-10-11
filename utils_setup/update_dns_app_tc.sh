#!/bin/bash

# Check if the correct number of arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <New Public IP address> <Child zone prefix>"
    exit 1
fi

# Set the resource group name
RESOURCE_GROUP_NAME="vsprod-dns-rg"

# Get the new Public IP address from the first argument
new_public_ip=$1

# Get the child zone prefix from the second argument
child_zone_prefix=$2

# Construct the full child zone name
child_zone_name="$child_zone_prefix.trainocate.cloud"

# Loop to update 9 A records in the range app1 - app9 for the child domain
for i in $(seq 1 9); do
    record_name="app$i"
    # Check if the A record exists
    record_check=$(az network dns record-set a show --name $record_name --resource-group $RESOURCE_GROUP_NAME --zone-name $child_zone_name --query "name" -o tsv)
    if [ "$record_check" == "$record_name" ]; then
        # Update the A record with the new IP address
        az network dns record-set a remove-record --resource-group $RESOURCE_GROUP_NAME --zone-name $child_zone_name --record-set-name $record_name --ipv4-address $(az network dns record-set a show --name $record_name --resource-group $RESOURCE_GROUP_NAME --zone-name $child_zone_name --query "ARecords[0].ipv4Address" -o tsv)
        az network dns record-set a add-record --resource-group $RESOURCE_GROUP_NAME --zone-name $child_zone_name --record-set-name $record_name --ipv4-address $new_public_ip
        echo "Updated A record: $record_name.$child_zone_name with new IP: $new_public_ip"
    else
        echo "A record $record_name.$child_zone_name does not exist. Skipping."
    fi
done

echo "All specified A records updated successfully!"
