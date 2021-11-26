#!/bin/bash
function adds() {
    if [ $# -lt 2 ]; then
        echo '参数不够'
    else
        return $(($1 + $2))
    fi

}
function addx() {
    return $(($1 * $2))
}
function Test() {
    echo >OutPutFile
    for line in $(ps -al); do
       echo $line >>OutPutFile
    done
    rm OutPutFile
    mkdir Out
}
