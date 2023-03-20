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
  name: 'nexus3_user',
  docs: <<-EOS,
@summary a nexus3_user type
@example
nexus3_user { 'admin':
  firstname => 'Administrator',
  lastname  => 'User',
  email     => 'admin@example.org',
  roles     => ['nx-admin'],
  status    => 'active',
}

This type provides Puppet with the capabilities to manage Nexus 3 User.

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
      desc: 'Id of the user.',
      behaviour: :namevar,
    },
    firstname: {
      type: 'String',
      desc: 'The first name of the user.',
    },
    lastname: {
      type: 'String',
      desc: 'The last name of the user.',
    },
    password: {
      type: 'Optional[String]',
      desc: 'The password of the user.',
      behaviour: :parameter,
    },
    email: {
      type: 'Pattern[/\A.+@.+\..+\z/]',
      desc: 'The email of the user.',
    },
    status: {
      type: 'Enum[active, disabled]',
      desc: 'When user is activated or not.',
    },
    roles: {
      type: 'Array[String]',
      desc: 'A list of roles the user have.',
    },
  },
  autorequire: {
    file: Nexus3::Config.file_path,
  },
)
