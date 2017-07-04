#!/bin/bash

x=$(fail2ban-client status ssh | grep IP | sed 's/ /\n/g' |cut -d: -f2 | wc -l)  #conto a quantidade de IPS

for ((z=8;z<=x;z++))                                                             #1 numero comeca em 8
do
        k=$(fail2ban-client status ssh | grep IP | sed 's/ /\n/g' |cut -d: -f2 | sed -n $z'p') #imprimo cadeia de elementos
        echo -e "rastreando IP de número $(($z-7))\n"
        nmap -Pn -sn --script ip-geolocation-geoplugin.nse $k > logs1
        var1=$(cat logs1 | grep coordinates | cut -d" " -f6 | cut -d"," -f1)     #geolocalizacao lat
        var2=$(cat logs1 | grep coordinates | cut -d" " -f6 | cut -d"," -f2)     #geolocalizacao long
        var3=$(cat logs1 | grep state | cut -d" " -f5)           #estado
        var4=$(echo ",{\"title\": '$var3',\"lat\": '$var1',\"lng\": '$var2',\"description\": '$var3'}")
        sed -i "17s/$/$var4/" geo2.html
done
