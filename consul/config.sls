#!pyobjects
import json

consul = salt.jinja.load_map('consul/map.jinja', 'consul')

include('.service')

for name, contents in salt.pillar.get('consul:extra_configs', {}).items():
    File.managed('write_{}_config'.format(name),
                 name='{0}/{1}.json'.format(consul['config_dir'], name),
                 contents=json.dumps(contents, indent=2, sort_keys=True),
                 makedirs=True,
                 user=consul['user'],
                 group=consul['group'],
                 watch_in=[Service('start_consul_service')])


for name, contents in salt.pillar.get('consul:esm_configs', {}).items():
    File.managed('write_esm_{}_config'.format(name),
                 name='/etc/consul-esm.d/{0}.json'.format(name),
                 contents=json.dumps(contents, indent=2, sort_keys=True),
                 makedirs=True,
                 user=consul['user'],
                 group=consul['group'],
                 watch_in=[Service('start_consul_service')])
