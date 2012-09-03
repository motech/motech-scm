 #!/bin/bash +x
  ip=/sbin/iptables
  admins=$1
  sshers=$2
  tcpservices=$3
  ssh_port=$4
#  udpservices=""
  
  # Firewall script for servername

  echo -n ">> Applying iptables rules... "

  ## flushing...
  $ip -F
  $ip -X
  $ip -Z
  $ip -t nat -F

  # default: DROP!
  $ip -P INPUT DROP
  $ip -P OUTPUT DROP
  $ip -P FORWARD DROP

  # filtering...

  # localhost: free pass!
  $ip -A INPUT -i lo -j ACCEPT
  $ip -A OUTPUT -o lo -j ACCEPT

  # administration ips: free pass!
  for admin in $admins ; do
      $ip -A INPUT -s $admin -j ACCEPT
      $ip -A FORWARD -s $admin -j ACCEPT
      $ip -A OUTPUT -d $admin -j ACCEPT
  done

  # allow ssh access to sshers
  for ssher in $sshers ; do
      $ip -A INPUT -s $ssher -p tcp -m tcp --dport $ssh_port -j ACCEPT
      $ip -A OUTPUT -d $ssher -p tcp -m tcp --sport $ssh_port -j ACCEPT
  done

  # allowed services
  for service in $tcpservices ; do
      $ip -A INPUT -p tcp -m tcp --dport $service -j ACCEPT 
      $ip -A OUTPUT -p tcp -m tcp --sport $service -m state --state RELATED,ESTABLISHED -j ACCEPT
  done
 # for service in $udpservices ; do
 #     $ip -A INPUT -p udp -m udp --dport $service -j ACCEPT
 #     $ip -A OUTPUT -p udp -m udp --sport $service -m state --state RELATED,ESTABLISHED -j ACCEPT
 # done

  $ip -A INPUT -j LOG --log-level 4


  # allow the machine to browse the internet
  $ip -A INPUT -p tcp -m tcp --sport 80 -m state --state RELATED,ESTABLISHED -j ACCEPT
  $ip -A OUTPUT -p tcp -m tcp --dport 80 -j ACCEPT
  $ip -A INPUT -p tcp -m tcp --sport 443 -m state --state RELATED,ESTABLISHED -j ACCEPT
  $ip -A OUTPUT -p tcp -m tcp --dport 443 -j ACCEPT

  #$ip -A INPUT -p tcp -m tcp --sport 8080 -m state --state NEW,RELATED,ESTABLISHED -j ACCEPT
  #$ip -A OUTPUT -p tcp -m tcp --dport 8080 -j ACCEPT


  # don't forget the dns...
  $ip -A INPUT -p udp -m udp --sport 53 -j ACCEPT
  $ip -A OUTPUT -p udp -m udp --dport 53 -j ACCEPT

  $ip -A INPUT -p udp -m udp --dport 123 -j ACCEPT
  $ip -A OUTPUT -p udp -m udp --sport 123 -j ACCEPT


  $ip -A INPUT -p tcp -m tcp --sport 25 -j ACCEPT
  $ip -A OUTPUT -p tcp -m tcp --dport 25 -j ACCEPT


  # temporary backup if we change from DROP to ACCEPT policies
  $ip -A INPUT -p tcp -m tcp --dport 1:1024 -j DROP
  $ip -A INPUT -p udp -m udp --dport 1:1024 -j DROP

  iptables-save > /etc/sysconfig/iptables

  echo "OK. Check rules with iptables -L -n"

  # end :)
