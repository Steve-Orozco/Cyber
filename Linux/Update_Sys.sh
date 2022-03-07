#!/bin/bash
#updates system in GREEN color!

C=$(printf '\033')
GREEN="${C}[1;32m"
B="${C}[1;34m"
printf "$B" && echo -e "This will update your machine!"

sudo apt update && sudo apt upgrade -yy

printf echo -e "Checking Who is using System"

printf "$GREEN" && w 


exit 0

