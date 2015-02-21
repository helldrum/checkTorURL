#o!/bin/bash
set -x
#set -x #uncomment to unable debug mode
function testArg {

    local readonly usage="usage : checkTorURL [input FILE] [output FILE] \n Example: checkTorURL inputOnionFile.txt result.txt "
    
    if [[ $# != 2 ]]
    then
        echo "ERROR : with the number of arguments"
        echo "$usage"
        exit -1
    fi
    
    if [ ! -f $1 ]
    then
        echo "ERROR : input File $1 doesn't exist."
        echo "$usage"
         exit -1
    fi
}

function extractAndSortUnionLink {

    local  readonly inputFile="$1"
    local unsortOnionLink=$(tempfile)
    local onionLink=$(tempfile)
    
    grep -oE "[http:\/\/]*?[[:alnum:]]*.onion" $inputFile > $unsortOnionLink
    
    sort -u $unsortOnionLink >$onionLink
    
    while read line
    do
        testURL "$line" "$2" &
        NPROC=$(($NPROC+1))
        if [ "$NPROC" -ge 4 ]; then
            wait
            NPROC=0
        fi
    done < $onionLink
    rm $unsortOnionLink $onionLink
}

# remove error or default pages
function testURL {
    local readonly outputFile="$2"
    siteAvailable=1
    tabError=("1.jpg" "502 Bad Gateway" "503 Service Unavailable" "THIS SITE HAS BEEN SEIZED" "There is no site here!" "404" "403" "302" "Welcome to nginx" "It works" "Alert")
    local readonly URL="$1"
    local message=$(curl --max-redirs 5 --connect-timeout 10 --socks5-hostname localhost:9050 "$URL" 2> /dev/null)
     
    if [ ! -z "$message" ]
    then
        for error in "${tabError[@]}"
        do
	    if [[  ! -z "$(echo "$message" | grep -Eo "$error" )" ]]
            then
                 siteAvailable=0
            fi
        done
    else
        siteAvailable=0
    fi
  
    if [  $siteAvailable -eq 1 ]
    then
        title=$(echo "$message"|sed -n 's/.*<title>\(.*\)<\/title>.*/\1/ip;T;q')
        echo "$URL - $title" >> "$2"
        echo "$URL -$title valide"
    fi

}

testArg "$@"
extractAndSortUnionLink "$@"
