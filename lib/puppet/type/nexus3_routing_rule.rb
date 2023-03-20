# frozen_string_literal: true

# This is a workaround for bug: #4248 whereby ruby files outside of the normal
# provider/type path do not load until pluginsync has occured on the puppetmaster
#
# In this case I'm trying the relative path first, then falling back to normal
# mechanisms. This should be fixed in future versions of puppet but it looks
# like we'll need to maintain this for some time perhaps.
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', '..'))
require 'puppet/resource_api'
require 'puppet_x/nexus3/config'

Puppet::ResourceApi.register_type(
  name: 'nexus3_routing_rule',
  docs: <<-EOS,
@summary a nexus3_routing_rule type
@example
nexus3_routing_rule { 'route_rule':
  matchers => ['foo', 'bar'],
}

This type provides Puppet with the capabilities to manage Nexus 3 Routing Rule.

**Autorequires**:
* `File[$PUPPET_CONF_DIR/nexus3_rest.conf]`
  EOS
  features: ['canonicalize'],
  attributes: {
    ensure: {
      type: 'Enum[present, absent]',
      desc: 'Whether this resource should be present or absent on the target system.',
      default: 'present',
    },
    name: {
      type: 'String',
      desc: 'Unique rule name.',
      behaviour: :namevar,
    },
    mode: {
      type: 'Pattern[/\A(ALLOW|BLOCK)\z/]',
      desc: 'When rule is to block or allow.',
      default: 'BLOCK',
    },
    description: {
      type: 'String',
      desc: 'The description of the rule.',
      default: '',
    },
    matchers: {
      type: 'Array[String]',
      desc: 'A list of matchers.',
      default: [],
    },
  },
  autorequire: {
    file: Nexus3::Config.file_path,
  },
)
