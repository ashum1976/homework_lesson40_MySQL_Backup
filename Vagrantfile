# -*- mode: ruby -*-
# vim: set ft=ruby :
# -*- mode: ruby -*-
# vim: set ft=ruby :

MACHINES = {
:srvmysql => {
        :box_name => "centos/8",
        :net => [
                   {ip: '192.168.3.2', adapter: 2, netmask: "255.255.255.240", virtualbox__intnet: "mysql_net"},
                ]
  },

:backupmysql => {
        :box_name => "centos/8",
        :net => [
                   {ip: '192.168.3.3', adapter: 2, netmask: "255.255.255.240", virtualbox__intnet: "mysql_net"},
                ]
  },

}

Vagrant.configure("2") do |config|

    config.vm.provider "virtualbox" do |v|
        v.customize ["modifyvm", :id, "--audio", "none"]
        v.memory = 512
        v.cpus = 1
          end

  MACHINES.each do |boxname, boxconfig|
    config.vm.synced_folder "./", "/vagrant", type: "rsync", rsync__auto: true, rsync__exclude: ['./hddvm, README.md']
    config.vm.define boxname do |box|

        box.vm.box = boxconfig[:box_name]
        box.vm.host_name = boxname.to_s

        boxconfig[:net].each do |ipconf|
          box.vm.network "private_network", ipconf
        end

        box.vm.provision "shell", inline: <<-SHELL
          mkdir -p ~root/.ssh
          cp ~vagrant/.ssh/auth* ~root/.ssh
          sed -i.bak 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
          systemctl restart sshd

        SHELL

        box.vm.provision :ansible_local do |ansible|
          #Установка  коллекции community.general, для использования community.general.nmcli (nmcli) управление сетевыми устройствами.
          # ansible.galaxy_command = 'ansible-galaxy collection install community.general'
          ansible.verbose = "vv"
          ansible.install = "true"
          #ansible.limit = "all"
          ansible.tags = boxname.to_s
          # ansible.tags = "facts"
          ansible.inventory_path = "./ansible/inventory/"
          ansible.playbook = "./ansible/playbooks/vlan.yml"
        end
    end
  end
end
