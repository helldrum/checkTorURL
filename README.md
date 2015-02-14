# pingTorURL
 this bash script is use to read tor link for a file and sort valid link by ping
 the output file provide valid tor link and title of the page when it's possible
##requierement
this script is build to run in linux system only (sorry windows users) 
you need to install the following package to make it work
```
sudo apt-get install curl
sudo apt-get install usewithtor
sudo apt-get install httping
```
##usage
checkTorURL [input text file]

##input file format

you need to provide a simple txt file with onion link on it like this
```
aaabbbcccdddeee.onion random text here http://aaabbbcccdddeee.onion  everything you want here
randomtexthttp://aaabbbcccdddeee.onion  everything you want
```
##output file
constain all the valid link tested by the script (exclude 404 error, Alert!, ngix welcome, ubuntu starter page) 

#Disclamer
I'am not responsive of the usage you can do with my script and I don't provide union Link
