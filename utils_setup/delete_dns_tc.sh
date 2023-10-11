#!/bin/bash

# Check if the correct number of arguments are provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <Child zone prefix>"
    exit 1
fi

# Set the resource group name
RESOURCE_GROUP_NAME="vsprod-dns-rg"

# Get the child zone prefix from the first argument
child_zone_prefix=$1

# Construct the full child zone name
child_zone_name="$child_zone_prefix.trainocate.cloud"

# Retrieve the NS records of the child zone
ns_records=$(az network dns record-set ns show --name "@" --resource-group $RESOURCE_GROUP_NAME --zone-name $child_zone_name --query "NSRecords[*].nsdname" -o tsv)

# Delete the NS records from the parent domain (trainocate.cloud)
for ns_record in $ns_records; do
    echo "Deleting NS record $ns_record from parent domain..."
    az network dns record-set ns remove-record --resource-group $RESOURCE_GROUP_NAME --zone-name "trainocate.cloud" --record-set-name $child_zone_prefix --nsdname $ns_record
    echo "Deleted NS record $ns_record from parent domain."
done

# Delete the child zone
az network dns zone delete --name $child_zone_name --resource-group $RESOURCE_GROUP_NAME -y
echo "Deleted child zone: $child_zone_name."

echo "Operation completed successfully!"