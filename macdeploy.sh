#!/bin/bash
##  macdeploy.sh
##  openimageio.lrplugin
##
##  Copyright (c) 2023 - present Mikael Sundell.
##  All Rights Reserved.
##
## openimageio.lrplugin is a lightroom plugin to post-process Lightroom exports
## using openimageio image processing tools.

# usage

usage()
{
cat << EOF
macdeploy.sh -- Deploy mac executable to path including depedencies 

usage: $0 [options]

Options:
   -h, --help              Print help message
   -v, --verbose           Print verbose
   -e, --executable        Path to executable
   -d, --dependencies      Path to dependencies
   -p, --path              Path to deploy
   -o, --overwrite         Overwrite files
EOF
}

# parse arguments

i=0; argv=()
for ARG in "$@"; do
    argv[$i]="${ARG}"
    i=$((i + 1))
done

i=0; findex=0
while test $i -lt $# ; do
    ARG="${argv[$i]}"
    case "${ARG}" in
        -h|--help) 
            usage;
            exit;;
        -v|--verbose)
            verbose=1;;
        -e|--executable) 
            i=$((i + 1)); 
            executable=${argv[$i]};;
        -d|--dependencies) 
            i=$((i + 1)); 
            dependencies=${argv[$i]};;
        -p|--path) 
            i=$((i + 1)); 
            path=${argv[$i]};;
        -o|--overwrite)
            overwrite=1;;
        *) 
            if ! test -e "${ARG}" ; then
                echo "Unknown argument or file '${ARG}'"
            fi;;
    esac
    i=$((i + 1))
done

# test arguments

if [ -z "${executable}" ] || [ -z "${path}" ]; then
    usage
    exit 1
fi

# copy deploy
function copy_deploy() {

    # files
    local copy_path=${1}
    local deploy_path=${2}

    # copy
    if [ $overwrite ]; then
        echo "Copy and overwrite file '${copy_path}' to '${deploy_path}'"
        cp -f "${copy_path}" "${deploy_path}"
    else
        if ! [ -f "$deploy_path" ]; then
            echo "Copy file '${copy_path}' to '${deploy_path}'"
            # copy
            cp "${copy_path}" "${deploy_path}"
        else
            echo "Skip copy file '${copy_path}' to '${deploy_path}', already exists"
        fi            
    fi

    # install name
    if [[ `file "${deploy_path}" | grep 'shared library'` ]]; then

        local deploy_base=`basename "${deploy_path}"`
        local deploy_id="@executable_path/${deploy_base}"

        # install name
        echo "Change install name id to '${deploy_id}' for '${deploy_path}'"
        install_name_tool -id "${deploy_id}" "${deploy_path}"
    fi

    # dependencies
    copy_dependency ${deploy_path}
}

# copy dependency
function copy_dependency() {

    # files
    local copy_path=${1}
    local copy_dir=`dirName "${copy_path}"`

    # dependencies
    local dependency_paths=`otool -L "${copy_path}" | tail -n+2 | awk '{print $1}'`
    local dependency_path
    for dependency_path in ${dependency_paths[@]}
    do
        if [[ `echo ${dependency_path} | grep "${dependencies}"` ]]; then

            if [ $copy_path != $dependency_path ]; then

                local dependency_base=`basename "${dependency_path}"`
                local deploy_path="${copy_dir}/${dependency_base}"

                # copy deployo
                echo "Copy dependency '${dependency_path}' to '${deploy_path}'"
                copy_deploy ${dependency_path} ${deploy_path}

                # install name
                local deploy_base=`basename "${deploy_path}"`
                local deploy_id="@executable_path/${deploy_base}"

                # install name
                echo "Change install dependency id to '${deploy_id}' from '${dependency_path}' for '${copy_path}'"
                install_name_tool -change ${dependency_path} "${deploy_id}" "${copy_path}"
            fi
        else
            echo "Skip copy dependency '${dependency_path}', not in dependency path"
        fi

    done
}

# main
function main {

    if [[ `file "${executable}" | grep 'executable'` ]]; then
        
        echo "Start to deploy executable: ${executable}"

        # files
        local copy_path=${executable}
        local copy_name=`basename "${executable}"`
        local deploy_path="${path}/${copy_name}"

        # copy deploy
        copy_deploy ${copy_path} ${deploy_path}

    else
        echo "File is not an executable '${executable}'"

    fi
}

main
