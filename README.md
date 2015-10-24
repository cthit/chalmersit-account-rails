# Account management for chalmers.it
Written in rails. Used as a single sign on (SSO) page.

## Requirements
(This assumes Ubuntu usage since that is what our Vagrant setup uses)

* `libkrb5-dev` - Headers and development libraries for MIT Kerberos ([Package info](http://packages.ubuntu.com/search?keywords=libkrb5-dev))
* `redis-server` - Persistent key-value database with network interface ([Package info](http://packages.ubuntu.com/search?keywords=redis-server))

## Installation

#### Install vagrant plugins
```sh
$ vagrant plugin install vagrant-vbguest vagrant-librarian-chef
```
#### Start the VM and ssh into it
```sh
$ vagrant up
$ vagrant ssh
$ echo "PATH=$PATH:/home/vagrant/.rbenv/versions/2.1.2/bin/" >> /home/vagrant/.bashrc
```
#### Install dependencies
```sh
$ cd /vagrant
$ sudo apt-get --yes install libkrb5-dev redis-server
$ bundle install
```
#### Create the secrets.yml file (fetch from wiki)
```sh
$ touch config/secrets.yml
$ touch config/ldap.yml
$ touch config/ldap_devise.yml
```

Put the following in `/etc/krb5.conf`
```
[libdefaults]
        default_realm = CHALMERS.SE
```

#### Prepare the db
```sh
$ rake db:create db:migrate
$ rake rails:update:bin
$ rbenv rehash
```

#### Then serve:
```sh
$ rails s -b 0.0.0.0
```
The instance is now accessible at [0.0.0.0:3000](0.0.0.0:3000)


Contribute
----

Want to contribute? Great! Fire of a mail to digit@chalmers.it or send a pull request.

We use git flow in this repository.

License
----

[MIT License](./LICENSE)

