#!/bin/bash

display_region_options() {
    echo "Select the AWS region to find stopped EC2 instances:"
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

echo "Finding stopped EC2 instances in region $region..."

stopped_instances=$(aws ec2 describe-instances --filters Name=instance-state-name,Values=stopped --query "Reservations[*].Instances[*].[InstanceId,InstanceType,State.Name,LaunchTime]" --output table --region "$region" 2>&1)

if [[ $? -ne 0 ]]; then
    echo "Error: $stopped_instances"
else
    if [[ -z "$stopped_instances" ]]; then
        echo "No stopped EC2 instances found in region $region."
    else
        echo "Stopped EC2 Instances in region $region:"
        echo "$stopped_instances"
    fi
fi

