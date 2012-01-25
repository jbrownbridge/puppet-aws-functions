#!/usr/bin/env ruby
#
#

require 'rubygems'
require 'fog'
require 'yaml'
require 'optparse'

options = {}

usage = "Example: set_elb_cert.rb --name NAME --cert CERTIFICATE"

optparse = OptionParser.new do|opts|
  opts.banner = usage

  opts.on( '-V', '--verbose', 'Output more information' ) do
    options[:verbose] = true
  end

  options[:region] = 'us-east-1'
  opts.on( '-r', '--region REGION', 'AWS Region (us-east-1)' ) do|region|
    options[:region] = region
  end

  options[:name] = nil
  opts.on( '-n', '--name NAME', 'ELB Name' ) do|name|
    options[:name] = name
  end

  options[:cert_id] = nil
  opts.on( '-c', '--cert CERT', 'Certificate ID' ) do|cert|
    options[:cert_id] = cert
  end

  options[:port] = '443'
  opts.on( '-p', '--port PORT', 'Listener Port' ) do|port|
    options[:port] = port
  end

  options[:mock] = nil
  opts.on( '-M', '--mock', 'Simulate all actions' ) do
    options[:mock] = true
  end

end

optparse.parse!

abort(usage) if ! options[:name]

@elbs = Fog::AWS::ELB.new(:region => options[:region])

elb = @elbs.load_balancers.get(options[:name])

abort('No Such ELB') if ! elb

if options[:cert_id] then
  puts elb.set_listener_ssl_certificate(options[:port], options[:cert_id])
else
  elb.listeners.each do |listener|
    if options[:verbose] then
      puts listener.attributes.to_yaml
    else
      puts listener.attributes[:lb_port].to_s + ': ' + listener.attributes[:ssl_id].to_s
    end
  end
end
