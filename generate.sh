
#!/usr/bin/env bash
#####################################################################
#   YAML file to standart "fstab" for use in Linux environment
#
#   Prepared by: Taulant Ngjelo
#   Created: 26/10/2021
#   Last update: 26/10/2021
#   Requirements: "yq" and "jq" tools in must be present in BASH
#                 It's available in all latest linux distributions.
#
#####################################################################
#Uncomment to enable debuging
#set -x

usage() {
        echo -e "`basename "$0"` -f <yaml file>"    #YAML input file - Output to stdout
        echo -e "`basename "$0"` -h"                #This will display the usage
}

read_yaml_file(){
#Every line of the fstab file will contain the following information
#See man page of fstab(5)for more info.
#1 - fs_spec - Block special device or remote filesystem to be mounted.
#2 - fs_file - For swap partitions, this field should be specified as "none".
#3 - fs_vfstype - Fileystem type
#4 - fs_mntops - Mount options associated with the filesystem
#5 - fs_freq - Field used by dump(8) to determine which filesystems to be dumped.Defaults "0" (don't dump) if not present.
#6 - fs_passno - This field is used by fsck(8) to determine the order in which filesystem checks are done at boot time.

for device in $(yq -e '.' $1 |jq -r '.fstab|keys[]'); do
      fs_spec=$device
      fs_file=$(yq -e '.' $1 |jq -cr ".fstab[\"$device\"].mount")
      fs_vfstype=$(yq -e '.' $1 |jq -cr ".fstab[\"$device\"].type")
      fs_mntops=$(yq -e '.' $1 |jq -cr ".fstab[\"${device}\"].options"|sed 's/ /,/g')
      fs_freq=$(yq -e '.' $1 |jq -cr ".fstab[\"$device\"].freq")
      fs_passno=$(yq -e '.' $1 |jq -cr ".fstab[\"$device\"].passno")

      #Testing the lines of the fstab file.
      if [ "$fs_spec" = "null" ] || [ -z "$fs_spec" ] ;then
        echo "Device or the remote filesystem not specified or null. Please check if YAML file is correct"
        #exit 0
      fi
      if [ "$fs_file" = "null" ] || [ -z "$fs_file" ];then
        echo "Mountpoint for device $fs_spec is not specified. Please check if YAML file is correct"
        #exit 0
      fi
      if [ "$fs_vfstype" = "null" ] || [ -z "$fs_vfstype" ];then
        echo "Filesystem type is required for filesystem $fs_file. Please check if YAML file is correct"
        #exit 0
      fi
      #If no mount options are found in the file, it will use the defaults of the Linux.
      if [ "$fs_mntops" = "null" ] || [ -z "$fs_mntops" ];then
        fs_mntops="defaults"
      fi
      #If fs_freq or fs_passno are not provided it will default to "0" - no dump, no filesystem check.
      if [ "$fs_freq" = "null" ] || [ -z "$fs_freq" ];then
        fs_freq="0"
      fi
      if [ "$fs_passno" = "null" ] || [ -z "$fs_passno" ];then
        fs_passno="0"
      fi
      #Displaying output in STDOUT
      echo -e "$fs_spec \t $fs_file \t $fs_vfstype \t $fs_mntops \t $fs_freq \t $fs_passno"
done
}


while getopts "hf:" opt
       do
       case $opt in
                f) YAML_INPUT=$OPTARG
                   #If the YAML file doesn't exist, the script will exit.
                   if [ ! -f "$OPTARG" ]
                   then
                       echo "Input file $OPTARG doesn't exist"
                       exit0
                   fi
                   read_yaml_file $YAML_INPUT
                ;;
                h) usage
                exit 0
                ;;
                \?) usage
                exit 0
                ;;
        esac
        done
