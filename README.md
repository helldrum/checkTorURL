# pingTorURL
 this bash script is use to read tor link for a file and sort valid and invalid tor link by ping

##requierement
this script is build to run in linux system only (sorry windows users) 
you need to install the following package to make it work
curl
usewithtor
httping

##usage
checkTorURL [input text file]

##input file format

you need to provide a flat file with one link by line
```
http://aaabbbcccdddeee.onion  everything you want to describe the link
http://aaabbbcccdddeee.onion  everything you want to describe the link
http://aaabbbcccdddeee.onion  everything you want to describe the link
```
##output file
you will find two file in the same place you run the script

###urlOnline
constain all the valid link (exclude 404 error, Alert!, ngix welcome, ubuntu starter page) 

###urlOffline
constain everything else

#Disclamer
I'am not responsive of the usage you can do with my script and I don't provide union Link
