#mysql-enc#

Simple mySQL ENC script for Puppet.

There's not much in the form of error handling.


How to add this script to your Puppet Master configuration:

https://docs.puppetlabs.com/guides/external_nodes.html#connecting-an-enc

##Requirements##

Ruby gems:

- mysql2
- syslog_logger


On Enterprise Linux:

```bash
yum install -q ruby-devel mysql-devel
gem install mysql2
gem install syslog_logger
```

## Configuration

It loads the database details from `mysql-enc.yaml`. The file should be on the same directory as the script.

## Caveats ##

It expects two tables
- node
  - certname
  - class 
- parameter
  - certname 
  - paremeter
  - value

You can only assign one class to each node. Why? You should be using Roles & Profiles so you don't need more than one (and it simplifies the DB).

