function oc::wait::object::availability() {
    local cmd=$1 # Command whose output we require
    local interval=$2 # How many seconds to sleep between tries
    local iterations=$3 # How many times we attempt to run the command

    ii=0

    while [ $ii -le $iterations ]
    do

        token=$($cmd) && returncode=$? || returncode=$?
        if [ $returncode -eq 0 ]; then
            break
        fi

        ((ii=ii+1))
        if [ $ii -eq 100 ]; then
            echo $cmd "did not return a value"
            exit 1
        fi
        sleep $interval
    done
    echo $token
}


oc apply -f catalogsource.yaml

oc::wait::object::availability "oc get project redhat-ods-monitoring" 2 30

oc create -f fakesecret.yaml
