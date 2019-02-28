# AD_User_Info
# A powershell program to gather up password related information on AD users for each DC in the enterprise and output to ogv
# This program uses a prompt so that you can check other users without retyping any code

# Global variable for Domain Controllers
$dcs = Get-ADDomainController -filter {Name -like '*'}

# function to check the Password related fields for an AD user
function CheckADUser {ForEach($dc in $dcs)
    {
    $hostname = $dc.HostName
    Get-ADUser $user -Server $hostname -Properties * | select CN, DisplayName, BadLogonCount, badPwdCount, LastLogonDate, PasswordExpired, PasswordLastSet, 
    PasswordNeverExpires, LockedOut, LastBadPasswordAttempt
    }
 
 }

# function to gather username 
function GatherUserInfo{
$script:user = Read-Host -Prompt 'Enter a user name: '
}

# import Active Directory Module
import-module ActiveDirectory

# first check for users password data from AD
GatherUserInfo
CheckADUser | ogv

# allow users to continue checking other accounts until finished

$continueQuestion = $null # create empty variable for while loop

# loop to query password stats from DC until user says no

while($continueQuestion -ne 'y' -Or $continueQuestion -ne 'n'){
$continueQuestion = Read-Host -Prompt 'Would you like to check another user? (y/n): '
if ($continueQuestion -eq 'y'){
    GatherUserInfo
    CheckADUser | ogv
    }
elseif ($continueQuestion -eq 'n'){
    break
    }
else{
    "You must type y or n" }
    continue
    }
