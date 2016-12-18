select region in $(timedatectl list-timezones | grep -o -E '^[[:alpha:]]*' | sort | uniq);
do
    echo "you chose ${region}"
    select timezone in $(timedatectl list-timezones | grep -E "^${region}/.*" | grep -o '[[:alpha:]]*$' | sort | uniq);
    do
        echo "you chose ${timezone}"
        timedatectl set-timezone ${region}/${timezone}
        break
    done
    break
done