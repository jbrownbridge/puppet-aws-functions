
README
======

This is a repository of useful functions for integrating puppet with Amazon Web Services.
These custom parser functions are executed on the puppet master during catalog compilation
The gem and aws credentials need only be installed on the master.

Installation
------------

These files should be placed in your puppet config tree in a module at lib/puppet/parser/functions

### Dependencies

fog gem (fog.io)
curl

### Credentials

There should be a yaml file at '/etc/puppet/fog_cred' in the format:

    :default:
            :aws_access_key_id:     XXXXXXXXXXXXXXXXX
            :aws_secret_access_key: XXXXXXXXXXXXXXXXXXXXXXXXXX


Functions
---------

### getIPsByTag(key,value) 

returns a hash of the internal IP addresses of all instances matching the aws 
resource tag key, value, or key => value pair passed in. Useful for load balancer
configs.

### elbRegisterInstance('ELBNAME') 

Registers the instance ID with the elb matching the passed name 

### r53SetRecord($zone, $name, $value, $type, $ttl) 

creates a route53 dns record (all dns names must be passed with a . at the end)

### s3getEtag($bucket, $key) 

returns the Etag (md5) of an s3 object

### s3getcurl($bucket, $key, $filename, $expires) 

returns a curl command and signed url referencing the specified s3 object

### s3 example:

    define s3get ($bucket='puppet-filesource', $cwd='/tmp', $expires=30) {

        $file_checksum = s3getEtag($bucket, $key)

        exec { "s3getcurl[$bucket][$title][$name]":
               cwd => $cwd,
               unless => "echo \"$file_checksum  $name\" | md5sum -c --status",
               command => s3getcurl($bucket, $title, $name, $expires),
        }
    }


