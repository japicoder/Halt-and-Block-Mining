#!/bin/bash
DIR=`dirname $(readlink -f $0)`

echo "Adding an 'Anti mining section' to /etc/hosts"

if [[ ! -f $DIR/mining-sites.txt ]]; then
	echo "The mining-sites.txt file is missing, cannot continue. Exiting."
	exit
fi

if [[ ! `grep -F "# Anti mining" /etc/hosts`  ]]; then
	sudo cp -f /etc/hosts $DIR/hosts.origin
	echo "* Created backup of /etc/hosts into $DIR/hosts.origin."
	echo "" | sudo tee -a /etc/hosts
fi

grep -vF '# Anti mining' /etc/hosts > $DIR/hosts.tmp
#cp /etc/hosts $DIR/hosts.tmp
#sed -i -e 's/(#Anti-mining-section)/asd/g' $DIR/hosts.tmp

echo ""
tail -n+1 $DIR/mining-sites.txt | while read LINE;do
        echo "$LINE # Anti mining" | tee -a $DIR/hosts.tmp &> /dev/null
done

#echo "#Anti-mining-section" | tee -a $DIR/hosts.tmp &> /dev/null
#cat $DIR/mining-sites.txt | tee -a $DIR/hosts.tmp &> /dev/null
#echo "#Anti-mining-section-end" | tee -a $DIR/hosts.tmp &> /dev/null

sudo cp -f $DIR/hosts.tmp /etc/hosts
rm -f $DIR/hosts.tmp
echo "Done."
