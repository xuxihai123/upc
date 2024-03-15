#!/usr/bin/env bash

# config===start
zip_prefix=upc
output_dir="./release"
output_bin=upc
# config===end

APP_VERSION=`git describe --tags --abbrev=0`
GIT_HASH=`git rev-parse --short HEAD`
echo $APP_VERSION'-'$GIT_HASH

cwd=`pwd`



rm -rf $output_dir
mkdir -p $output_dir

# os_all='linux windows darwin freebsd'
# arch_all='386 amd64 arm arm64'

platforms=("windows/amd64" "linux/amd64" "linux/386" "linux/arm64" "darwin/amd64" "darwin/arm64" )

for platform in "${platforms[@]}"
do
    platform_split=(${platform//\// })
    os=${platform_split[0]}
    arch=${platform_split[1]}

    targetzip_name="${zip_prefix}_${APP_VERSION}_${os}_${arch}"
    build_outdir="${output_dir}/${targetzip_name}"
    mkdir -p $build_outdir
    platform_bin=$output_bin
    if [ $os = "windows" ]; then
        platform_bin+='.exe'
    fi
    echo "Build ${build_outdir}...";\
    env CGO_ENABLED=0 GOOS=${os} GOARCH=${arch} go build -trimpath -ldflags "-X main.Version=$APP_VERSION -X main.GitCommitHash=$GIT_HASH" -o ${build_outdir}/${platform_bin} ./main.go
    echo "Build ${build_outdir} done";

    # packages
    cd $output_dir
    if [ $os = "windows" ]; then
        zip -rq ${targetzip_name}.zip ${targetzip_name}
    else
        tar -zcf ${targetzip_name}.tar.gz ${targetzip_name}
    fi  
    # rm -rf ${targetzip_name}
    cd ..
done

cd -