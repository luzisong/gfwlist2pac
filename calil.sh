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
virtualenv -p /usr/bin/python3.7 env
source env/bin/activate
(cd genpac;python setup.py install)

env/bin/genpac \
	--pac-proxy "PROXY pi.zisung.work:1081; PROXY 192.168.123.200:7890; PROXY 127.0.0.1:1080; DIRECT" \
	--gfwlist-url - \
	--gfwlist-local gfwlist/gfwlist.txt \
	-o gfwlist.pac
sed -e '5d' -e '3d' -i gfwlist.pac
deactivate

git add .
git commit -m "[$(LANG=C date)]auto update"
git push origin master
