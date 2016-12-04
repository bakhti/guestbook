# -*- mode: ruby -*-
# vi: set ft=ruby :

redis_ip = '172.17.0.3'
postgres_ip = '172.17.0.4'

Vagrant.configure('2') do |config|

  config.vm.define :gb_redis do |redis|
    redis.vm.provider :docker do |d|
      d.image = 'redis:alpine'
      d.ports = ['6379:6379']
      d.has_ssh = false
      d.name = 'gb_redis'
    end
  end

  config.vm.define :gb_postgres do |postgres|
    postgres.vm.provider :docker do |d|
      d.image = 'postgres:alpine'
      d.ports = ['5432:5432']
      d.has_ssh = false
      d.name = 'gb_postgres'
      d.env = {
        'POSTGRES_PASSWORD' => 'mysecretpassword',
        'POSTGRES_DB' => 'charlie'
    }
    end
  end

  config.vm.define 'gb_web' do |web|
    web.vm.box = 'trusty64'
    web.vm.box_url = 'https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box'
    web.vm.host_name = 'guestbook'
    web.vm.network :private_network, ip: '10.0.0.3'
    web.vm.network :forwarded_port, guest: 9292, host: 9292
    web.trigger.after :provision, :stdout => true do
      run_remote 'sudo -u vagrant -H -i /bin/bash /vagrant/ansible/post-provision.sh'
    end
  end

  config.vm.provision :ansible do |ansible|
    ansible.playbook = 'ansible/local.yml'
    ansible.groups = { 'web' => [ 'guestbook' ] }
    ansible.host_key_checking = false
    ansible.verbose = 'vv'
  end
end

