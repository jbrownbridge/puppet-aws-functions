require 'rubygems'
require 'fog'

module Puppet::Parser::Functions
  newfunction(:elbRegisterInstance) do |args|

    params = {}

    params[:elb] = args[0]
    params[:instanceid] = lookupvar('ec2_instance_id')

    Fog.credentials_path = '/etc/puppet/fog_cred'

    @elbs = Fog::AWS::ELB.new

    @elb = @elbs.load_balancers.get(params[:elb])

    #check to see if the instance is registered
    if ! @elb.attributes[:instances].include?(params[:instanceid])
      #if not, register it
      @elb.register_instances(params[:instanceid])
    end
  end
end



