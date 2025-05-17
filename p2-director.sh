#!/bin/bash
set -e

POSITIONAL=()
while [[ $# -gt 0 ]]; do
  key="$1"

  case $key in
    -e|--eclipse-exe)
      eclipse_exe="$2"
      shift # past argument
      shift # past value
      ;;
    -r|--repositories-file)
      repositories_file="$2"
      shift # past argument
      shift # past value
      ;;
    -i|--installable-units-file)
      installable_units_file="$2"
      shift # past argument
      shift # past value
      ;;
    -d|--destination-directory)
      destination_directory="$2"
      shift # past argument
      shift # past value
      ;;
    -o|--os)
      os="$2"
      shift # past argument
      shift # past value
      ;;
    -w|--ws)
      ws="$2"
      shift # past argument
      shift # past value
      ;;
    -a|--arch)
      arch="$2"
      shift # past argument
      shift # past value
      ;;
    *)
  esac
done

cmd="${eclipse_exe}"

cmd="${cmd} -application org.eclipse.equinox.p2.director"

cmd="${cmd} -repository \""
readarray -t repositories < "${repositories_file}"
for repository in "${repositories[@]}"
do
	repository=$(echo "${repository}" | xargs)
	[[ $repository =~ ^#.* ]] && continue
	if [ -n "${repository}" ]; then
		cmd="${cmd}${repository},"
	fi
done
cmd="${cmd::-1}\""

cmd="${cmd} -installIU \""
readarray -t installable_units < "${installable_units_file}"
for installable_unit in "${installable_units[@]}"
do
	installable_unit=$(echo "${installable_unit}" | xargs)
	[[ $installable_unit =~ ^#.* ]] && continue
	if [ -n "${installable_unit}" ]; then
		cmd="${cmd}${installable_unit},"
	fi
done
cmd="${cmd::-1}\""

cmd="${cmd} -tag InitialState"

cmd="${cmd} -profile SDKProfile"
cmd="${cmd} -profileProperties org.eclipse.update.install.features=true"

cmd="${cmd} -destination \"${destination_directory}\""

cmd="${cmd} -p2.os ${os} -p2.ws ${ws} -p2.arch ${arch}"

cmd="${cmd} -roaming"

echo "exec ${cmd}"

eval "${cmd}"
