#!/usr/bin/env ruby


# for quick debugging
#require 'pp'

require 'rubygems'
require 'mysql2'
require 'yaml'
require 'syslog/logger'

log = Syslog::Logger.new 'mysql-enc'

if ARGV.length != 1
  log.error 'missing certname'
  exit 1
end

certname = ARGV[0].to_s

cfg_file = File.join(File.dirname(__FILE__),"mysql-enc.yaml")

unless File.exist?(cfg_file)
  log.error "missing config file #{cfg_file}"
  exit 1
end

cfg = YAML.load(File.read(cfg_file))
unless cfg.kind_of?(Hash)
  log.error 'error parsing configurtion file #{cfg_file}'
  exit 1
end

db_user = cfg["db_user"]
db_pass = cfg["db_pass"]
db_name = cfg["db_name"]
db_host = cfg["db_host"]

log.debug "user: #{db_user}, pass: #{db_pass}, db: #{db_name}, host: #{db_host}"

db = Mysql2::Client.new(:username => db_user, :password => db_pass, :host => db_host, :database => db_name)

query = "select class from node where certname = '#{certname}'"
log.debug "Executing #{query}"
node = db.query(query)
if node.any?
  role = node.first['class'].to_s
  log.debug "Node #{certname} role found: #{role}"
end



query = "select parameter, value from parameter where certname = '#{certname}'"
log.debug "Executing #{query}"

parameters = {}
params = db.query(query)
if params.any?
  params.each do |parameter|
  	parameters[parameter['parameter'].to_s] = parameter['value'].to_s
    log.debug "Node #{certname} parameter #{parameter['parameter'].to_s} = #{parameter['value'].to_s}"
  end
end

output = { 'classes'    => role,
           'parameters' => parameters
}

puts(output.to_yaml)
