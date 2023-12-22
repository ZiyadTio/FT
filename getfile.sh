#!/bin/bash

print_help() {
  cat <<EOL
Usage: $0 [-u|-d] -f <filelocation> -H <host>

Options:
  -u <user>         Specify the username for the operation (upload)
  -d <user>         Specify the username for the operation (download)
  -f <filelocation> Specify the local (for upload) or remote (for download) file location
  -H <host>         Specify the hostname

Operations:
  -u                Upload the specified file to the remote host
  -d                Download the specified file from the remote host

Help:
  -h | -help        Display this help message

Example:
  Upload:
    $0 -u username -f /local/path/to/file -H hostname

  Download:
    $0 -d username -f /remote/path/to/file -H hostname

EOL
}

operation=""
user=""
host=""
filelocation=""

while getopts ":hu:d:f:H:" opt; do
  case $opt in
    h | help)
      print_help
      exit 0
      ;;
    u)
      operation="upload"
      user="$OPTARG"
      ;;
    d)
      operation="download"
      user="$OPTARG"
      ;;
    f)
      filelocation="$OPTARG"
      ;;
    H)
      host="$OPTARG"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      print_help
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      print_help
      exit 1
      ;;
  esac
done

if [ -z "$operation" ] || [ -z "$user" ] || [ -z "$filelocation" ] || [ -z "$host" ]; then
  echo "Usage: $0 [-u|-d] -f <filelocation> -H <host>"
  print_help
  exit 1
fi

case "$operation" in
  "upload")
    scp "${filelocation}" "${user}"@"${host}":~
    echo "File ${filelocation} uploaded to ${host} in the home folder for ${user} "
    ;;
  "download")
    scp "${user}"@"${host}":"${filelocation}" ~
    echo "File ${filelocation} downloaded to your home folder"
    ;;
esac
