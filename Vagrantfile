# -*- mode: ruby -*-
# vi: set ft=ruby :

# Install required plugins if not present.
required_plugins = %w(vagrant-ghost vagrant-vbguest)
required_plugins.each do |plugin|
  need_restart = false
  unless Vagrant.has_plugin? plugin
    system "vagrant plugin install #{plugin}"
    need_restart = true
  end
  exec "vagrant #{ARGV.join(' ')}" if need_restart
end

# Vagrant multi machine configuration
Vagrant.configure(2) do |config|

  # generic config
  config.vm.box = "debian/jessie64"

  # set os manually to debian
  config.vm.guest = :debian

  # config.vm.provision :shell do |shell|
  #   shell.inline = "apt-get -y install python-git"
  # end

  # disable guest additions install (slow)
  config.vbguest.no_install = true

  # mitenant vm for postgres
  config.vm.define "salt-demo-master", autostart: true do |mitenant|

    mitenant.vm.hostname = "salt-demo-master.dev"

    mitenant.vm.network "private_network", ip: "192.168.33.40", nictype: 'virtio'

    config.vm.synced_folder "salt/states/", "/srv/salt/states/"
    config.vm.synced_folder "salt/pillar/", "/srv/salt/pillars/"
    config.vm.synced_folder "salt/formulas/", "/srv/salt/formulas/"

    mitenant.vm.provider "virtualbox" do |vb|
      vb.cpus = 2
      vb.memory = "512"
      # vb.paravirtprovider = "kvm"
    end

    mitenant.vm.provision :salt do |salt|

      salt.install_master = true

      salt.master_config = "salt/master_config"
      salt.seed_master = { "minion-1" => "minion-1.pub", "minion-2" => "minion-2.pub" }

      salt.bootstrap_options = "-F -c /tmp -P -i minion-1"

      salt.minion_id = "minion-1"
      salt.minion_pub = "minion-1.pub"
      salt.minion_key = "minion-1.pem"

      salt.minion_config = "salt/minion_config"
      salt.grains_config = "salt/master_grains"

      salt.masterless = false

      salt.run_highstate = false
      salt.log_level = "debug"

    end

  end

  config.vm.define "salt-demo-minion-2", autostart: true do |mitenant|

    mitenant.vm.hostname = "salt-demo-minion-2.dev"

    mitenant.vm.network "private_network", ip: "192.168.33.41", nictype: 'virtio'

    mitenant.vm.provider "virtualbox" do |vb|
      vb.cpus = 2
      vb.memory = "512"
      # vb.paravirtprovider = "kvm"
    end

    mitenant.vm.provision :salt do |salt|

      salt.bootstrap_options = "-F -c /tmp -P -i minion-2"

      salt.minion_id = "minion-2"
      salt.minion_pub = "minion-2.pub"
      salt.minion_key = "minion-2.pem"

      salt.minion_config = "salt/minion_config"
      salt.grains_config = "salt/node_grains"

      salt.masterless = false

      salt.run_highstate = false
      salt.log_level = "debug"

    end

  end

end
