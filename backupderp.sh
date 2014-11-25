#!/bin/sh

# derpbackup.sh
# -compress, encrypt, and copy home dir contents to backup location
# -uses tar, gnupg, and rsync

bkpdirs=("/Users/adpatter/Documentstemp1" "/Users/adpatter/Documentstemp2");

timestamp() {
  date +"%Y%m%d%H%M%S"
}

# execution
echo
echo "Backing up the following directories..."
printf "%s\n" "${bkpdirs[@]}"
echo

for curdir in ${bkpdirs[@]}; do
  echo "Processing $curdir ..."
  echo
  tar --exclude "*.DS_Store" -czf "$(basename $curdir)-$(timestamp).tar.gz" -C $curdir .
done

# gpg -o Documents.zip.gpg -e -r adpatter@starbucks.com Documents.zip
