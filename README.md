# adjust
# To parse a yaml file on linux with bash script we can use  yq tool.
yq a lightweight and portable command-line YAML processor. yq uses jq like syntax but works with yaml files as well as json. 
 
# Install yq
Most of the new linux versios has yq installed,but if there is not installed,you can check : yq --version,if the output is null then:

1.$ sudo apt install python3-pip -y #yum for centos/red hat
#
2.$ sudo  pip3 install yq

# Verify :
$sudo  yq --version
yq 2.12.2
#
The path of yq should be at :
#
$ which yq
#
/usr/bin/yq

# Read a value from our .yaml with yq:
#
 $ sudo yq -e '.' file.yaml
 #
Output:
{
  "fstab": {
    "/dev/sda1": {
      "mount": "/boot",
      "type": "xfs"
    },
    "/dev/sda2": {
      "mount": "/",
      "type": "ext2"
    },
    "/dev/sdb1": {
      "mount": "/var/lib/postgresql",
      "type": "ext4",
      "root-reserve": "10%"
    },
    "192.168.4.5": {
      "mount": "/home",
      "export": "/var/nfs/home",
      "type": "nfs",
      "options": "noexec nosuid"
    }
  }
}


Use yq and pipe to jq .
#
The keys are the 
#
yq -e '.' file.yaml  | jq -r '.fstab|keys[]'
#
and the output:
#
/dev/sda1
#
/dev/sda2
#
/dev/sdb1
#
192.168.4.5

#
Note:In file.yaml is  a root-reserve filesystem which there is no mount point on fstab,if you want to add this,you can use tune2fs (tune2fs command in Linux is used to manipulate the filesystem parameters of a ext 2/3/4 type file system)
 
 
# jq is like sed for JSON data - you can use it to slice and filter and map and transform structured data with the same ease that sed, awk, grep  
jq is for files manipulation

# Installation of jq

sudo apt-get install jq #yum for centos/red hat
#
You will use jq -r to read in json format.because if we use yq withot jq we need to use a lot of regular expresions,on our script.

To run the script:
#
git clone https://github.com/tao-devops/adjust
#
cd adjust/
#
chmod +x #to make the script .sh executable

run the scipt:
 # ./generate.sh -f file.yaml
the output should be:
#
/dev/sda1        /boot   xfs     defaults        0       0 
#
/dev/sda2        /       ext2    defaults        0       0 
#
/dev/sdb1        /var/lib/postgresql     ext4    defaults        0       0
#
192.168.4.5      /home   nfs     noexec,nosuid   0       0
#
If you  want to add this to fstab we can run the command:

./generate.sh -f file.yaml >> /etc/fstab

# Authors
Taulant Ngjelo











