#!/usr/bin/expect -f


# cisco_100_loopbacks
# Copyright 2017 Ibrahim Abdulghni Khorwat
#
# cisco_100_loopbacks is free code: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# cisco_100_loopbacks is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with pymscoader.  If not, see <http://www.gnu.org/licenses/>.



# WARNING WARNING WARNING WARNING WARNING
# Don't Try This on a prduction Environment.


# cisco_100_loopbacks creates 100 loopback interfaces
# each with an ip address of 172.16.x.0/24
# where x is the loopback id address
# example:
# loo1 assigned with the ip address 172.16.1.0/24
# loo2 assigned with the ip address 172.16.2.0/24

# To trigger this code, simlpy type the below on your linux shell
# ./cisco_100_loopbacks.sh 192.168.1.1 username password enablepasword
# if no enabelpassword is configured, it is ok just to type Enter To execute the code.
# example:
# user@user$./cisco_100_loopbacks.sh 10.1.1.1 <username> <password> <enablepassword>
# user@user$./cisco_100_loopbacks.sh 10.1.1.1 <username> <password>

# Set variables
set device [lindex $argv 0]
set username [lindex $argv 1]
set password [lindex $argv 2]
set enpasswd [lindex $argv 3]
set date [exec date +%F]
set sec [clock seconds]
set time [clock format $sec -format %H-%M-%S]

# Don't check keys
spawn ssh -o StrictHostKeyChecking=no $username\@$device

# Please don't change the following timeout value
set timeout 1


# Announce device & time
send_user "\n"
send_user ">      Working on $device @ [exec date]     <\n"
send_user "\n"



expect {
timeout { send_error "\nTimeout Exceeded - Check connectivity with Host $device\n";exit 1 }
eof { send_error "\nSSH Connection To $device Failed\n"; exit 1 }
"*assword" {
send "$password\r"
expect "*assword" {
  send_error "\n"
  send_error "\nError processing $device: The specified username or password is incorrect, please try again\n"
  exit 1
}
}
}

log_file


# if the script got enable prompt '>' what should it do
expect {
  "*>" {
    send "enable\r"
    expect "*assword"
    send "$enpasswd\r"
    expect "*assword" {
    send_error "\n"
    exit 1
    }
    }
    }



# just to print a new line
send "\r"
expect "#"
send "config terminal\r"
expect "*(config)#"


for {set id 1} {$id < 101} {incr id 1} {
send "interface loopback $id\r"
expect "*(config-if)#"
send "ip address 172.16.$id.1 255.255.255.0\r"
sleep 0.1
}

send "exit\r"
expect "*(config-if)#"
send "exit\r"
expect "*(config)#"
send "exit\r"
expect "*#"
send_user "\n"

