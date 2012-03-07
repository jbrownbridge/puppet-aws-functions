require 'rubygems'
require 'fog'

module Puppet::Parser::Functions
  newfunction(:r53SetRecord) do |args|
    Puppet::Parser::Functions.autoloader.loadall
    # all dns names must end with a period
    params = {}
    params[:zone] = args[0]
    params[:name] = args[1]
    params[:value] = args[2]
    params[:type] = args[3]
    params[:ttl] = args[4]

    Fog.credentials_path = '/etc/puppet/fog_cred'

    #set up the dns object
    @dns = Fog::DNS.new(:provider => 'aws')

    #find the zone based on the params
    @zone = @dns.zones.find { |z| z.attributes[:domain] == params[:zone]  }

    #check to see if the record exists, if not create it
    #
    # This is so rediculously complicated because amazon won't return
    # more than 100 items
    @record = @zone.records.all(:max_items =>'1', :name => params[:name]) {
      |r| r.name == params[:name] }[0]

    if not @record.name == params[:name]
      function_notice(['Record does not exist. Creating it.'])
      @zone.records.create(
        :value => params[:value],
        :name  => params[:name],
        :type  => params[:type],
        :ttl   => params[:ttl]
      )

      #check to see if the existing record is the same, if not destroy and create it
    elsif not @record.attributes[:value][0] == params[:value]
      function_notice(['Record exists but differs. Recreating it.'])
      @record.destroy
      @zone.records.create(
        :value => params[:value],
        :name  => params[:name],
        :type  => params[:type],
        :ttl   => params[:ttl]
      )
    end
  end
end
