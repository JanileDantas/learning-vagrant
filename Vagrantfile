$script_mysql = <<-SCRIPT
    apt-get update && \
    apt-get install -y mysql-server-5.7 && \
    mysql -e "create user 'phpuser'@'%' identified by 'pass';"
SCRIPT

Vagrant.configure("2") do |config|

  config.vm.box = "hashicorp/bionic64"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = 512
    vb.cpus = 1
  end

  config.vm.define "mysqldb" do |mysql|
    mysql.vm.network "public_network", ip: "192.168.0.17"
    mysql.vm.provision "shell", 
      inline: "cat /configs/id-bionic.pub >> .ssh/authorized_keys"
    mysql.vm.provision "shell", inline: $script_mysql
    mysql.vm.provision "shell", 
      inline: "cat /configs/mysqld.cnf > /etc/mysql/mysql.conf.d/mysqld.cnf"
    mysql.vm.provision "shell", inline: "service mysql restart"

    mysql.vm.synced_folder ".", "/vagrant", disabled: true
    mysql.vm.synced_folder "./configs", "/configs"
  end

  config.vm.define "phpweb" do |phpweb|
    phpweb.vm.network "forwarded_port", guest: 8888, host: 8888
    phpweb.vm.network "public_network", ip: "192.168.0.18"

    phpweb.vm.provision "shell", 
      inline: "apt-get update -y && apt-get install -y puppet"

    phpweb.vm.provision "puppet" do |puppet|
      puppet.manifests_path = "./configs/manifests"
      puppet.manifest_file = "phpweb.pp"
    end
  end  
end
