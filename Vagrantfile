class VagrantPlugins::ProviderVirtualBox::Action::Network
  def dhcp_server_matches_config?(dhcp_server, config)
    true
  end
end

Vagrant.configure("2") do |config|
  config.vm.network "public_network", bridge: "Default Switch"

    config.vm.define "server" do |server|
      server.vm.box = "generic/rhel9"
      server.vm.provider "virtualbox" do |vb|
        vb.memory = "8192"
      end
      # For Hyper-V provider
      #server.vm.provider "hyperv" do |hv|
      #  hv.memory = 8192
      #end
      server.vm.network "private_network", type: "dhcp"
      server.vm.hostname = "rhel-server"
      server.vm.provision "file", source: "data", destination: "/tmp/vagrant_data"

      server.vm.provision "shell", privileged: true, path: "data/enable-ssh.sh"
      server.vm.provision "shell", privileged: true, path: "data/server.sh"
    end

    config.vm.define "agent" do |agent|
      agent.vm.box = "generic/rhel9"
      agent.vm.provider "virtualbox" do |vb|
        vb.memory = "2048"
      end
      # For Hyper-V provider
      #agent.vm.provider "hyperv" do |hv|
      #  hv.memory = 2048
      #end
      agent.vm.network "private_network", type: "dhcp"
      agent.vm.hostname = "rhel-agent"
      agent.vm.provision "file", source: "data", destination: "/tmp/vagrant_data"

      agent.vm.provision "shell", privileged: true, path: "data/enable-ssh.sh"
      agent.vm.provision "shell", privileged: true, path: "data/agent.sh"
    end

    config.vm.define "agent-deb" do |agent|
      agent.vm.box = "generic/ubuntu2310"
      agent.vm.provider "virtualbox" do |vb|
        vb.memory = "2048"
      end
      # For Hyper-V provider
      #agent.vm.provider "hyperv" do |hv|
      #  hv.memory = 2048
      #end
      agent.vm.network "private_network", type: "dhcp"
      agent.vm.hostname = "ubuntu-agent"
      agent.vm.provision "file", source: "data", destination: "/tmp/vagrant_data"

      agent.vm.provision "shell", privileged: true, path: "data/agent-deb.sh"
    end

  end
