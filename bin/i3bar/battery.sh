#!/bin/bash

percent=$(acpi --battery | grep -Eo "([0-9]+)%," | grep -Eo "[0-9]+")

if [ "${percent}" -lt "20" ]
then
    echo -e "<span color='red'>\uf244</span>  ${percent}%"
    exit 0
fi

if [ "${percent}" -lt "40" ]
then
    echo -e "<span color='yellow'>\uf243</span>  ${percent}%"
    exit 0
fi

if [ "${percent}" -lt "60" ]
then
    echo -e "\uf242  ${percent}%"
    exit 0
fi

if [ "${percent}" -lt "80" ]
then
    echo -e "\uf241  ${percent}%"
    exit 0
fi

echo -e "<span color='green'>\uf240</span>  ${percent}%"
exit 0