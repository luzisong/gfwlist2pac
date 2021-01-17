#!/bin/sh
cd `dirname $0`
git reset --hard
git pull

git submodule update --init
for i in gfwlist genpac
do
	(cd $i;git pull origin master)
done

rm -rf env
virtualenv env
source env/bin/activate
(cd genpac;python3 setup.py install)

env/bin/genpac \
	--pac-proxy "PROXY pi.zisung.work:1081; PROXY 192.168.123.200:7890; PROXY 127.0.0.1:1080; DIRECT" \
	--gfwlist-url - \
	--user-rule-from /mnt/m1/spider-save/proxy/gfwlist_user-rules.txt \
	--gfwlist-local gfwlist/gfwlist.txt \
	-o gfwlist.pac
sed -e '5d' -i gfwlist.pac
deactivate

git add .
git commit -m "[$(LANG=C date)]auto update"
git push origin master

cp ./gfwlist.pac /mnt/m1/spider-save/proxy/
cp ./gfwlist.pac /mnt/m1/spider-save/proxy/gfwlist.pac.txt
