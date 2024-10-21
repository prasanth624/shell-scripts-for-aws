#The script checks a list of AWS IAM users from a file, determining if each user has multi-factor authentication (MFA) devices and access keys. 
#If a user lacks both or hasn't logged in for over 180 days, it disables their login profile.

#!/bin/bash
current_date=$(date -u '+%s')
user_file="users.txt"

if [ ! -f "$user_file" ]; then
  echo "User file not found: $user_file"
  exit 1
fi

for test_user in $(cat "$user_file"); do
  if aws iam list-users --query "Users[?UserName=='$test_user'].UserName" --output text | grep -q "$test_user"; then  
    echo "Testing user: $test_user"
    if [ "$(aws iam list-mfa-devices --user $test_user | jq '.MFADevices | length')" -eq 0 ]; then
      if [ "$(aws iam list-access-keys --user-name $test_user | jq '.AccessKeyMetadata | length')" -eq 0 ]; then      
        echo "$test_user does not have MFA or access keys and will be disabled."      
        aws iam delete-login-profile --user-name $test_user
      else      
        echo "$test_user has access keys, so it won't be disabled."
      fi
    else    
      if [ "$(aws iam list-access-keys --user-name $test_user | jq '.AccessKeyMetadata | length')" -eq 0 ]; then      
        last_login=$(aws iam get-user --user-name $test_user --query 'User.PasswordLastUsed')
        if [ "$last_login" != "null" ]; then
          last_login_date=$(date -d "$(echo $last_login | tr -d '"' | sed 's/T/ /; s/+[0-9][0-9]:[0-9][0-9]$//')" -u '+%s')        
          echo "Last Login Date for $test_user: $last_login_date"
          days_since_last_login=$(( (current_date - last_login_date) / 86400 ))
          if [ $days_since_last_login -gt 180 ]; then
            echo "$test_user has not logged in for $days_since_last_login days"
            echo "Disabling $test_user as the user has not logged in for 180 days"          
            aws iam delete-login-profile --user-name $test_user
          fi
        else
          echo "$test_user has never logged in."
        fi
      fi
    fi
  else
    echo "Test user $test_user not found."
  fi
done
