#!/bin/bash

display_region_options() {
    echo "Select the AWS region to find unattached EBS volumes:"
    echo "1) us-east-1"
    echo "2) us-west-1"
    echo "3) eu-west-1"
    echo "4) ap-southeast-1"
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
        5) read -p "Enter the custom region (e.g., us-east-2): " region; break ;;
        6) echo "Exiting."; exit 0 ;;
        *) echo "Invalid choice. Please select a valid option." ;;
    esac
done

echo "Finding unattached EBS volumes in region $region..."

unattached_volumes=$(aws ec2 describe-volumes --filters Name=status,Values=available --query "Volumes[*].[VolumeId,Size,State,CreateTime]" --output table --region "$region")

if [[ -z "$unattached_volumes" ]]; then
    echo "No unattached EBS volumes found in region $region."
else
    echo "Unattached EBS Volumes in region $region:"
    echo "$unattached_volumes"
fi

