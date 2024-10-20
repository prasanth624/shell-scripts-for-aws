#!/bin/bash

display_region_options() {
    echo "Select the AWS region to find unattached Elastic IPs:"
    echo "1) us-east-1"
    echo "2) us-east-2"
    echo "3) us-west-1"
    echo "4) us-west-2"
    echo "5) Enter a custom region"
    echo "6) Exit"
}

while true; do
    display_region_options
    read -p "Enter the number for your choice: " choice

    case $choice in
        1) region="us-east-1"; break ;;
        2) region="us-east-2"; break ;;
        3) region="us-west-1"; break ;;
        4) region="us-west-2"; break ;;
        5) read -p "Enter the custom region (e.g., eu-west-1): " region; break ;;
        6) echo "Exiting."; exit 0 ;;
        *) echo "Invalid choice. Please select a valid option." ;;
    esac
done

echo "Finding unattached Elastic IPs in region $region..."

unattached_eips=$(aws ec2 describe-addresses --query "Addresses[?InstanceId==null].{PublicIp:PublicIp}" --output table --region "$region" 2>&1)

if [[ $? -ne 0 ]]; then
    echo "Error: $unattached_eips"
else
    if [[ -z "$unattached_eips" ]]; then
        echo "No unattached Elastic IPs found in region $region."
    else
        echo "Unattached Elastic IPs in region $region:"
        echo "$unattached_eips"
    fi
fi

