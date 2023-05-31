#!/bin/bash
arch=`go env GOARCH`
os=`go env GOOS`
path=`pwd`
version=$1
if [ "$version" == "" ]
then
  echo "error,must set version"
  exit
fi
path="$path"/tf_install_template/
provider=$2
if [ "$provider" == "" ]
then
   wget https://github.com/volcengine/terraform-provider-volcengine/releases/download/v"$version"/terraform-provider-volcengine_"$version"_"$os"_"$arch".zip
   unzip terraform-provider-volcengine_"$version"_"$os"_"$arch".zip -d $path
else
   unzip $provider -d $path
fi
gopath=`echo $GOPATH`

if [ "$gopath" == "" ]
then
    temp1=`whereis terraform`
    temp2=`echo ${temp1#*terraform: }`
    gopath=`echo ${temp2%%terraform*}`
fi


tf_version=`terraform -version | head -n 1`
tf_version=`echo ${tf_version#*v}`
if [ x"$tf_version" \< x"0.13" ];then
	mv "$path"terraform-provider-volcengine_v"$version" "$gopath"/terraform-provider-volcengine
else
	mkdir -p ~/.terraform.d/plugins/registry.terraform.io/volcengine/volcengine/"$version"/"$os"_"$arch"/
        mv "$path"terraform-provider-volcengine_v"$version" ~/.terraform.d/plugins/registry.terraform.io/volcengine/volcengine/"$version"/"$os"_"$arch"/terraform-provider-volcengine_v"$version"
fi
rm -rf terraform-provider-volcengine*
rm -rf tf_install_template
echo "install completed"