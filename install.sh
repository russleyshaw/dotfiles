#/bin/bash

ISEFI=[ -d /sys/firmware/efi/efivars ]

echo "#### $(date) - Selecting timezone..."
select region in $(timedatectl list-timezones | grep -o -E '^[[:alpha:]]*' | sort | uniq); do
    select timezone in $(timedatectl list-timezones | grep -E "^${region}/.*" | grep -o '[[:alpha:]]*$' | sort | uniq); do
        timedatectl set-timezone ${region}/${timezone}
        break
    done
    break
done

timedatectl set-ntp true

echo "#### $(date) - Installing the base packages..."
pacstrap /mnt baase

