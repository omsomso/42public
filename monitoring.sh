# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    monitoring.sh                                      :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: kpawlows <kpawlows@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2022/12/01 00:23:37 by kpawlows          #+#    #+#              #
#    Updated: 2022/12/01 14:29:02 by kpawlows         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#declaring and calculating variables to print

architecture=$(uname -a)

physical_cpus=$(grep "physical id" /proc/cpuinfo | uniq | wc -l)
virtual_cpus=$(grep "processor" /proc/cpuinfo | uniq | wc -l)

ram_used_m=$(free -m | awk '/Mem/ {print $3}')
ram_total_m=$(free -m | awk '/Mem/ {print $2"MB"}')
ram_percent=$(echo $ram_used_m/$ram_total_m*100 | bc -l | rev | cut -c 20- | rev)

disk_used=$(df -h --total / | awk '/total/ {print $3}')
disk_total=$(df -h --total / | awk '/total/ {print $2"b"}')
disk_percent=$(df -h --total / | awk '/total/ {print $5}')

cpu_load=$(top -bn1 | grep '^%Cpu' | cut -c 9- | xargs | awk '{printf("%.1f%%"), $1 + $3}')

last_boot=$(who -b | awk '{print $3 " " $4}')

lvm=$(lsblk | grep "lvm" | wc -l)
lvm_use=$(if [ $lvm -eq 0 ]; then echo no; else echo yes; fi)

tcp=$(netstat -a | grep 'ESTABLISHED' | wc -l)
user=$(who | wc -l)

ip=$(hostname -I)
mac=$(ip link show | awk '$1 == "link/ether" {print $2}')

sudo=$(journalctl _COMM=sudo | grep COMMAND | wc -l)

Mb_sign=$(echo "Mb")
b_sign=$(echo "b")

echo "
#Architecture: $architecture
#CPU physical : $physical_cpus
#vCPU : $virtual_cpus
#Memory Usage : $ram_used_m/$ram_total_m ($ram_percent%)
#Disk Usage : $disk_used/$disk_total ($disk_percent)
#CPU load : $cpu_load
#Last boot : $last_boot
#LVM use : $lvm_use
#Connexions TCP : $tcp ESTABLISHED
#User log : $user
#Network : IP $ip ($mac)
#Sudo : $sudo cmd"