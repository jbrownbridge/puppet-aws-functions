require 'rubygems'
require 'fog'

module Puppet::Parser::Functions
        newfunction(:s3getcurl, :type => :rvalue) do |args|
                bucket   = args[0]
                key      = args[1]
                Fog.credentials_path = '/etc/puppet/fog_cred'
                s3 = Fog::Storage.new(:provider => 'AWS')
                s3bucket = s3.directories.get(bucket)
                etag = s3bucket.files.head(key).etag
                return etag
        end
end
