#!/bin/bash

# Set the resource group name
RESOURCE_GROUP_NAME="vsprod-dns-rg"

# Prompt the user for the Public IP address
read -p "Enter the Public IP address: " public_ip

# Prompt the user for the child zone name (e.g., stu01)
read -p "Enter the child zone name (e.g., stu01): " child_zone_prefix

# Construct the full child zone name
child_zone_name="$child_zone_prefix.trainocate.cloud"

# Create the Azure child DNS zone
az network dns zone create --name $child_zone_name --resource-group $RESOURCE_GROUP_NAME

# Wait for 35 seconds
echo "Waiting for 35 seconds for the child zone to be fully created..."
sleep 35

# Check if the child zone has been created
zone_check=$(az network dns zone show --name $child_zone_name --resource-group $RESOURCE_GROUP_NAME --query "name" -o tsv)

# If the child zone is created, proceed with the rest of the operations
if [ "$zone_check" == "$child_zone_name" ]; then
    # Get the NS records of the child zone
    ns_records=$(az network dns record-set ns show --name "@" --resource-group $RESOURCE_GROUP_NAME --zone-name $child_zone_name --query "NSRecords[*].nsdname" -o tsv)

    # Add NS records to the parent domain (trainocate.cloud) for delegation to the child zone
    for ns_record in $ns_records; do
        az network dns record-set ns add-record --resource-group $RESOURCE_GROUP_NAME --zone-name "trainocate.cloud" --record-set-name $child_zone_prefix --nsdname $ns_record
    done

    # Loop to create 25 A records in the range app1 - app25 for the child domain
    for i in $(seq 1 2); do
        record_name="app$i"
        az network dns record-set a add-record --resource-group $RESOURCE_GROUP_NAME --zone-name $child_zone_name --record-set-name $record_name --ipv4-address $public_ip
        echo "Created A record: $record_name.$child_zone_name with IP: $public_ip"
    done

    echo "All A records created successfully and NS records added to parent domain for delegation!"
else
    echo "Child zone creation failed or took longer than expected. Please check and try again."
fi

