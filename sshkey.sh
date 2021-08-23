#bin/bash
#############################
##Built by github.com/Volarken###
######Public Release 1.1####
#############################
func_logEvent () {
TIME0=$(date)
mkdir -p $HOME/sshkey
LOGFILE="$HOME/sshkey/log.txt"
sudo /bin/cat <<-EOM >>$LOGFILE
        $LogInput $TIME0
			EOM
}
func_autoUpdate(){
version=$(curl -s https://raw.githubusercontent.com/Volarken/SimpleSSHKeys/main/version.txt)
versionCurrent="$(cat $HOME/sshkey/version.txt)"
clear
if [ "$versionCurrent" = "$version" ]; then
LogInput="Script up to date, last update check ran on "
func_logEvent
else
LogInput="Script is outdated, running update protocols on "
func_logEvent
mkdir -p ~/.ssh/keys
sudo -s curl https://raw.githubusercontent.com/Volarken/SimpleSSHKeys/main/version.txt -o $HOME/sshkey/version.txt > /dev/null
sudo -s curl -L https://raw.githubusercontent.com/Volarken/SimpleSSHKeys/main/sshkey.sh -o "$0" > /dev/null
clear
sudo bash "$0"
fi
}

function_enableKeys() {
rm ~/.ssh/authorized_keys >> /dev/null
for file in ls ~/.ssh/keys/* 
do
  ssh-keygen -i -f "$file" >> ~/.ssh/authorized_keys
  done
  LogInput="Authorization file updated..."
  func_logEvent
  echo $LogInput
  echo "Press enter to exit..."
  read -p ""
  exit
}

function_removeKey() {
echo "Here is a list of our current keys... "
ls ~/.ssh/keys
sleep 2;
echo "Which key would you like to remove?"
echo "If none, press enter"
read -p '' -e REMOVE
rm ~/.ssh/keys/$REMOVE
LogInput="SSH Key $REMOVE has been deleted!"
func_logEvent
echo $LogInput
sleep 2;
echo "Would you like to remove another key?"
echo "Y/N"
read -p '' -e qValue
echo ""
if [[ "$qValue" == "Y" || "$qValue" == "y" ]]; then
function_removeKey
fi
clear
function_enableKeys
}

function_addKey() {
echo "Please copy your key to the clipboard and prepare to paste into nano..."
echo "What would you like to name this key?"
read -p "" -e NAME
nano ~/.ssh/keys/$NAME
if test -f ~/.ssh/keys/$NAME
then
LogInput="SSH Key $NAME has been successfully added!"
else
LogInput="ERROR SSH Key $NAME has NOT added!"
fi
func_logEvent
echo $LogInput
echo "Would you like to add another key?"
echo "Y/N"
read -p '' -e qValue
echo ""
if [[ "$qValue" == "Y" || "$qValue" == "y" ]]; then
function_addKey
fi
function_enableKeys
}

func_mainRun() { 
echo "$(tput setaf 2)"
echo -e "
Welcome to the Linux SSH Key Management System\n\n\
1)Enable all Keys\n\
2)Remove a Key\n\
3)Upload a Key\n\
4)Exit\n\
"
read -p '' -e MenuProcessor
echo "$(tput sgr0)"
if [[ "$MenuProcessor" = '1' ]]; then
function_enableKeys
fi
if [[ "$MenuProcessor" = '2' ]]; then 
function_removeKey
fi
if [[ "$MenuProcessor" = '3' ]]; then
function_addKey
fi
if [[ "$MenuProcessor" = '4' ]]; then
func_logEvent
LogInput="Exit Function Executed at "
exit
fi
}

func_autoUpdate
func_mainRun
#func_mainMenu