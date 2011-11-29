require 'rubygems'
require 'fog'

module Puppet::Parser::Functions
        newfunction(:getIPsByTag, :type => :rvalue) do |args|
                filter = { 'key' => args[0] }
                filter = { 'value' => args[1] }
                instances  = {}

                Fog.credentials_path = '/etc/puppet/fog_cred'

                # new compute provider from AWS
                compute = Fog::Compute.new(:provider => 'AWS')

                # print resource id's by the hash {key => value}
                compute.describe_tags(filter).body['tagSet'].each do|tag|
                        instance_facts = compute.describe_instances('instance-id' => tag['resourceId']).body['reservationSet'][0]['instancesSet'][0]
                        instances[tag['resourceId']] = instance_facts['privateIpAddress']
                end

                return instances

        end
end
