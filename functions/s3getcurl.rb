require 'rubygems'
require 'fog'
require 'time'

module Puppet::Parser::Functions
  newfunction(:s3getcurl, :type => :rvalue) do |args|
    bucket   = args[0]
    key      = args[1]
    filename = args[2]
    expires  = args[3] # in seconds from Time.now.to_i
    headers = { }
    Fog.credentials_path = '/etc/puppet/fog_cred'
    s3 = Fog::Storage.new(:provider => 'AWS')
    s3bucket = s3.directories.get(bucket)
    url = s3bucket.files.get_https_url(key, Time.parse(DateTime.now.to_s).to_i + expires.to_i)
    heads = headers.map{|k,v| "-H '#{k}: #{v}'"}.join(' ')
    cmd = "curl #{heads} --create-dirs -s -f -o #{filename} '#{url}'"
    return cmd
  end
end
