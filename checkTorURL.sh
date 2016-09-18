#o!/bin/bash
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

    local readonly inputFile="$1"
    local readonly onion_regex="[[[:alnum:]]*\.onion"
    local unsortOnionLink=$(tempfile)
    local onionLink=$(tempfile)
    
    grep -oE "$onion_regex" $inputFile > $unsortOnionLink
    
    sort -u $unsortOnionLink >$onionLink
    
    while read line
    do
        echo $(testURL "$line" "$2" &)
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
    local readonly http_header="Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36"
    siteAvailable=1
    tabError=("1.jpg" "502 Bad Gateway" "503 Service Unavailable" "THIS SITE HAS BEEN SEIZED" "There is no site here!" "404" "403" "302" "Welcome to nginx" "It works" "Alert")
    local readonly URL="$1"

    local message=$(curl -XPOST --max-redirs 5 --connect-timeout 3 --socks5-hostname localhost:9050 "$URL" "$http_header" 2> /dev/null)
     
    if [ ! -z "$message" ]
    then
        for error in "${tabError[@]}"
        do
	    if [[  ! -z "$(echo "$message" | grep -Eo "$error" )" ]]
            then
                 siteAvailable=0
                 echo "$URL - invalid"

            fi
        done
    else
        siteAvailable=0
        echo "$URL - invalid"
    fi
  
    if [  $siteAvailable -eq 1 ]
    then
        title=$(echo "$message"|sed -n 's/.*<title>\(.*\)<\/title>.*/\1/ip;T;q')
        echo "$URL - $title" >> "$2"
        echo "$URL - valid"
    fi

}

testArg "$@"
extractAndSortUnionLink "$@"
