# checkTorURL
This bash script is use to read tor link for a file and sort valid link using curl through the tor network\n
The output file provide valid tor link and title of the page when it's possible\n
don't worry if you see anything in stdout, the script echo only if it find a valid link\n
 
##requierement
this script is build to run in linux system only (sorry windows users) 
you need to install the following package to make it work
```
sudo apt-get install curl
sudo apt-get install usewithtor
```
you need to edit your /etc/tor/torrc file in order to use the sock5 through tor
```
uncomment #ControlPort 9051
uncomment #CookieAuthentication 1  and change it  CookieAuthentication 0
```

##usage
checkTorURL.sh [input FILE][output FILE]

##input file format

you need to provide a simple txt file with onion link on it like this
```
aaabbbcccdddeee.onion random text here http://aaabbbcccdddeee.onion  everything you want here
randomtexthttp://aaabbbcccdddeee.onion  everything you want
```
##output file format
constain all the valid link tested by the script and the title of the main page when it's possible (exclude 404 error, Alert!, ngix welcome, ubuntu starter page) 

```
Example:
azertyuiopqsdf.onion - title link example 1
qsdfghjkllmwxc.onion - title link example 2
```

#Disclaimer
I'am not responsive of the usage you can do with my script and I don't provide union Link
