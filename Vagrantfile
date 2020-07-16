HOST_IP = "192.168.5.50"

Vagrant.configure("2") do |config|
        config.vm.box = "ubuntu/bionic64"
	config.vm.box_check_update = false
	config.vm.define "CMS-FFC-WP-01" do |node|
		node.vm.provider "virtualbox" do |vb|
			vb.name = "CMS-FFC-01"
			vb.memory = 2048
			vb.cpus = 2
		end
		node.vm.hostname = "cms-ffc-01"
		node.vm.network :private_network, ip: "#{HOST_IP}"
		node.vm.network "forwarded_port", guest: 22, host: "#{2710}"
		node.vm.provision "setup-hosts", :type => "shell", :path => "ubuntu/vagrant/setup-hosts.sh" do |s|
			s.args = ["enp0s8"]
		end
        	node.vm.provision "setup-WP", type: "shell", :path => "install.sh"
		node.vm.provision "setup-dns", type: "shell", :path => "ubuntu/update-dns.sh"
	end
end


