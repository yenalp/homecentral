# require 'rest-client'
# require 'json'

scriptsDir = $scriptsDir ||= File.expand_path("setup", File.dirname(__FILE__))

setupScriptPath = scriptsDir + '/bootstrap.sh'
startupScriptPath = scriptsDir + '/startup.sh'

# Comment out the line below if you do not require a mail server to be installed
mailScriptPath = scriptsDir + '/bootstrap.mail.sh'


puts "
 __  __             _    _ _
|  \\/  | ___  _ __ | | _(_|_)
| |\\/| |/ _ \\| '_ \\| |\/ \/ | |
| |  | | (_) | | | |   <| | |
|_|  |_|\\___\/|_| |_|_|\\_\\_|_|

"

VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |node_config|

  node_config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

  node_config.vm.box = "ubuntu/bionic64"

  node_config.vm.network :private_network, ip: "192.168.56.101"
  node_config.vm.network :forwarded_port, guest: 443, host: 8085

  # VM specific configs
  node_config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--name", "homecentral" ]
    vb.customize ["modifyvm", :id, "--ioapic", "on"]
    vb.customize ["modifyvm", :id, "--vram", "256"]
    vb.customize ["modifyvm", :id, "--cpus", "1"]
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--memory", "2000"]
  end

  # Share project folder (where Vagrantfile is located) as /vagrant
  node_config.vm.synced_folder ".", "/vagrant",
      :nfs => true,
      :nfs_udp => false,
      :mount_options => ['sec=sys']

  # Provisioning scripts
  node_config.vm.provision "shell", path: setupScriptPath

  if File.exists? mailScriptPath then
    node_config.vm.provision "shell", path: mailScriptPath
  end

  # Provision script that runs on every boot
  if File.exists? startupScriptPath then
    node_config.vm.provision "shell", path: startupScriptPath, run: "always"
  end

end
