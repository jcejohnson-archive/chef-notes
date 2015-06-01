#!/bin/bash

log=foo-$(date +%H%M%S)
building=false
extra_args=""

trap "rm -f $log" EXIT

args=""
while [ $# -gt 0 ]
do
    case $1 in
        build)
            args="$args $1"
            building=true
            ;;
        -)
            if [ $building != true ]
            then
                echo "FATAL - I can only handle stdin to 'docker build'"
                exit 100
            fi
            cat > $log
            args="build -f $log"
            extra_args="."
            ;;
        *)
            args="$args $1"
            ;;
    esac
    shift
done

docker $args $extra_args ; r=$?
rm -f $log
exit $r
