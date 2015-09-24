#!/bin/bash
#
# -works on Mac OS X, bsdtar + gpg
# -compress + encrypt in one pass

# params
base_dir=/Users/username
sub_dirs=(Desktop Documents Dropbox git go keepass OneDrive Pictures .atom .ssh .chef .gnupg)
timestamp=$(date +"%m%d%y")
out_file_prefix="my-backup"
key_id="my@email.com"

# script
echo "Starting backup on these dirs under $base_dir :"
echo "${sub_dirs[@]}"
ls /Applications > $base_dir/Documents/Applications_$timestamp.txt

echo "===== Size of dirs ====="
for ((i = 0; i < ${#sub_dirs[@]}; i++)); do
  cur_dir="$base_dir/${sub_dirs[$i]}/"
  echo "$cur_dir : $(du -hcs $cur_dir | grep -i total | awk '{print $1}')"
done

echo "===== Compressing and encrypting dirs ====="
echo "..."
cd $base_dir
tar -c -z -f - -C $base_dir ${sub_dirs[@]} | \
  gpg -e -o "$out_file_prefix-$timestamp.tar.gz.gpg" \
    -r $key_id

if [ $? ]; then
  echo "Done!"
else
  echo "Error."
  exit 1
fi
