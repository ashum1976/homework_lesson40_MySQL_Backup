## -*- mode: ruby -*-
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

    if Vagrant.has_plugin?("vagrant-timezone")
      config.timezone.value = "Europe/Minsk"
    end

    config.vm.provider "virtualbox" do |v|
      v.customize ["modifyvm", :id, "--audio", "none", "--memory", "512", "--cpus", "1" ]
    end

  MACHINES.each do |boxname, boxconfig|

    config.vm.synced_folder "./", "/vagrant", type: "rsync", rsync__auto: true, rsync__exclude: ['./hddvm, README.md']
#    config.ssh.insert_key = false
    config.vm.define boxname do |box|
        box.vm.provider "virtualbox" do |v|
            if boxname.to_s == "srvmysql"
              v.customize ["modifyvm", :id, "--audio", "none", "--memory", "1024", "--cpus", "1" ]
            end
        end

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
	        dnf -y --nogpgcheck install python39 epel-release
	        dnf -y --nogpgcheck install sshpass
	        pip3 install ansible
        SHELL

         box.vm.provision :ansible_local do |ansible|
#         ansible.galaxy_role_file = 'requirements.yml'
	        ansible.compatibility_mode = '2.0'
	        ansible.verbose = "vv"
#         ansible.install = "true"
	        ansible.install = "false"
          ansible.tags = boxname.to_s
          ansible.inventory_path = "./ansible/inventory/"
          ansible.playbook = "./ansible/playbooks/mysql.yml"
        end
    end
  end
end
