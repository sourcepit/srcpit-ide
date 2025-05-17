#!/bin/bash
set -e

POSITIONAL=()
while [[ $# -gt 0 ]]; do
  key="$1"

  case $key in
    -i|--eclipse-ini-file)
      eclipse_ini_file="$2"
      shift # past argument
      shift # past value
      ;;
    -s|--xms)
      xms="$2"
      shift # past argument
      shift # past value
      ;;
    -x|--xmx)
      xmx="$2"
      shift # past argument
      shift # past value
      ;;
    -l|--lombok-filename)
      lombok_filename="$2"
      shift # past argument
      shift # past value
      ;;
    *)
  esac
done

sed -i '/^-Xms/d' "${eclipse_ini_file}"
echo "-Xms${xms}" >> "${eclipse_ini_file}"

sed -i '/^-Xmx/d' "${eclipse_ini_file}"
echo "-Xmx${xmx}" >> "${eclipse_ini_file}"

sed -i '/^-javaagent/d' "${eclipse_ini_file}"
echo "-javaagent:${lombok_filename}" >> "${eclipse_ini_file}"
