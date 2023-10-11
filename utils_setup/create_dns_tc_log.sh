#!/bin/bash

# Check if the correct number of arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <Public IP address> <child zone prefix>"
    exit 1
fi

# Set the resource group name
RESOURCE_GROUP_NAME="vsprod-dns-rg"

# Get the Public IP address from the first argument
public_ip=$1

# Get the child zone name (e.g., stu01) from the second argument
child_zone_prefix=$2

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
        echo "Adding NS record $ns_record to parent domain..."
        result=$(az network dns record-set ns add-record --resource-group $RESOURCE_GROUP_NAME --zone-name "trainocate.cloud" --record-set-name $child_zone_prefix --nsdname $ns_record)
        if [ $? -eq 0 ]; then
            echo "Successfully added NS record $ns_record to parent domain."
        else
            echo "Failed to add NS record $ns_record to parent domain. Error: $result"
        fi
    done

    # Loop to create 9 A records in the range app1 - app9 for the docker child domain
    for i in $(seq 1 9); do
        record_name="app$i"
        az network dns record-set a add-record --resource-group $RESOURCE_GROUP_NAME --zone-name $child_zone_name --record-set-name $record_name --ipv4-address $public_ip
        echo "Created A record: $record_name.$child_zone_name with IP: $public_ip"
    done

    # Loop to create 9 A records in the range kub1 - kub9 for the kubeneters child domain
    for i in $(seq 1 9); do
        record_name="kub$i"
        az network dns record-set a add-record --resource-group $RESOURCE_GROUP_NAME --zone-name $child_zone_name --record-set-name $record_name --ipv4-address $public_ip
        echo "Created A record: $record_name.$child_zone_name with IP: $public_ip"
    done

    # Create single ssh name for access
    for i in 1 ; do
        record_name="ssh"
        az network dns record-set a add-record --resource-group $RESOURCE_GROUP_NAME --zone-name $child_zone_name --record-set-name $record_name --ipv4-address $public_ip
        echo "Created A record: $record_name.$child_zone_name with IP: $public_ip"
    done


    echo "All A records created successfully!"
else
    echo "Child zone creation failed or took longer than expected. Please check and try again."
fi
