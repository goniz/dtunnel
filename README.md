# dtunnel

A simple Layer2/3 tunnel created in D for educational purposes.
* TCP is used briefly for establishing the tunnel
* UDP is used  for the tunnel itself.
* tun.ko (/dev/net/tun) is used for the virtual interface.

# development

* linux (archlinux)
* MonoDevelop (5.9.5)
* dmd compiler (v2.068)

# usage

  * sudo ./DTunnel -d {tap/tun} -m {client/server} -i {ip/hostname} -p {port}

# example

Server: (192.168.1.5)
  * sudo ./DTunnel -d tap -m server -p 9999
  * sudo ifconfig tap0 1.1.1.1/24
  * sudo ifconfig tap0 mtu 1300
  
Client: (192.168.1.6)
  * sudo ./DTunnel -d tap -m client -i 192.168.1.5 -p 9999
  * sudo ifconfig tap0 1.1.1.2/24
  * sudo ifconfig tap0 mtu 1300
