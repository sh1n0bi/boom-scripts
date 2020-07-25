#!/bin/bash


# Moarenum...added to subdom-boom in /root/bin


if [ ! -d "output" ];then
	mkdir output
fi

# Use tomnomnom's waybackurl go script to find more urls to target....
# make sure waybackurls is in the path...
# This will often create a huge file.
echo "Using waybackurls to find moar urls to target"
cat probed.txt |waybackurls |tee -a output/urls.txt
echo "Finished with waybacurls"

# also try gau to find more: gau can be installed with :
# go get -u github.com/lc/gau
echo "Using gau to find even moar!"
for x in $(cat probed.txt);do
        gau $x |tee -a output/moreurls.txt
done
echo "Finished with gau"

###################
# archivefuzz.py for finding more stuff...follow instructions from ... https://github.com/devanshbatham/ArchiveFuzz
echo "Using archivefuzz to find yet moar!!!"
for x in $(cat probed.txt);do
        python3 /opt/Archive-Fuzz/ArchiveFuzz/archivefuzz.py $x |tee -a archivefuzzed.txt
done

mv /root/.archivefuzz/* output/
echo "Finished with all of that business! - now go check the output folder."
#################

