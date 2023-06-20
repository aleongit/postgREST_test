@echo off

setlocal
set "set[1]=ABCDEFGHIJKLMNOPQRSTUVWXYZ"  &  set "len[1]=26"  &  set "num[1]=0"
set "set[2]=abcdefghijklmnopqrstuvwxyz"  &  set "len[2]=26"  &  set "num[2]=0"
set "set[3]=0123456789"                  &  set "len[3]=10"  &  set "num[3]=0"
set "set[4]=~!@#$%%"                     &  set "len[4]=6"   &  set "num[4]=0"
set "digits=32"
setlocal EnableDelayedExpansion

rem Create a list of n random numbers between 1 and 4;
rem the condition is that it must be at least one digit of each one

rem Initialize the list with n numbers
set "list="
for /L %%i in (1,1,!digits!) do (
   set /A rnd=!random! %% 4 + 1
   set "list=!list!!rnd! "
   set /A num[!rnd!]+=1
)

:checkList
rem Check that all digits appear in the list at least one time
set /A mul=num[1]*num[2]*num[3]*num[4]
if %mul% neq 0 goto listOK

   rem Change elements in the list until fulfill the condition

   rem Remove first element from list
   set /A num[%list:~0,1%]-=1
   set "list=%list:~2%"

   rem Insert new element at end of list
   set /A rnd=%random% %% 4 + 1
   set "list=%list%%rnd% "
   set /A num[%rnd%]+=1

goto checkList
:listOK

rem Generate the password with the sets indicated by the numbers in the list
set "RndAlphaNum="
for %%a in (%list%) do (
   set /A rnd=!random! %% len[%%a]
   for %%r in (!rnd!) do set "RndAlphaNum=!RndAlphaNum!!set[%%a]:~%%r,1!"
)

echo !RndAlphaNum!