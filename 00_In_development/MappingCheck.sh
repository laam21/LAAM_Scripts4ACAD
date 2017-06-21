#!/bin/bash -l
##########################################################
#
#       Chapter II - Mapping Check
#
#       Luis Arriola
#       Last Update: 19 June 2017
#               v.0
#
##########################################################
#
# This script checks how many reads were mapped within the correct slidding window

join -1 <colfile1> -2 <col file2> file1 file2 | awk -v Chr=${Arrayline[0]} -v Start=$(( ${Arrayline[1]}-1 )) -v End=${Arrayline[2]} '
BEGIN{
SelfFound="N"
}
{
if(Chr == $1 && Start == $2 && End == $3){
SelfFound = "Y";
next
}else if(Chr == $1 && ((Start <= $2 && End >= $2) || (Start <= $3 && End >= $3)) ){
SelfFound = "O"
}else if(Chr == $1 &&  $2 <= Start  && $3 >= End ){
SelfFound = "OO"
}else if(Chr == $1 &&  $2 <= End  && $3 >= Start ){
SelfFound = "OI"
}
}END{
if(!NR){
SelfFound= "E"
};
print SelfFound
}' )
