# cisco_100_loopbacks

cisco_100_loopbacks.sh code creates 100 loopback interfaces
each with an ip address of 172.16.x.0/24
where x is the loopback id address, i found this code usefull if i want to have fun with BGP,
where i could populate the BGP table of multiple routers with lots of ip addresses and have them exchanged.

example:

 loo1 assigned with the ip address 172.16.1.0/24
 
 loo2 assigned with the ip address 172.16.2.0/24
 

 To trigger this code, simlpy type the below on your linux shell
 
 
  user@user$./cisco_100_loopbacks.sh 192.168.1.1 username password enablepasword
 
 if no enabelpassword is configured, it is ok just to type Enter To execute the code.
 
 example:
 
 user@user$./cisco_100_loopbacks.sh 10.1.1.1 cisco_user cisco_passwd cisco
 
 
 user@user$./cisco_100_loopbacks.sh 10.1.1.1 cisco cisco 
 
 
 
 To change the ip address from 172.16.x.0/24
 currently you can go to the last lines where you can see the below code
 
 
 
 for {set id 1} {$id < 101} {incr id 1} {
 
 send "interface loopback $id\r"

 expect "*(config-if)#"

 send "ip address 172.16.$id.1 255.255.255.0\r"

 sleep 0.1

 }




then just change the below 
send "ip address 172.16.$id.1 255.255.255.0\r"

to the ip address you are interested with
ex:
send "ip address 192.168.$id.1 255.255.255.0\r"

Then save and run the code.

Enjoy!
