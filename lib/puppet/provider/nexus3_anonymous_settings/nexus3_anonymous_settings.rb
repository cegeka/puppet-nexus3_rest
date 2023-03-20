# frozen_string_literal: true

# This is a workaround for bug: #4248 whereby ruby files outside of the normal
# provider/type path do not load until pluginsync has occured on the puppetmaster
#
# In this case I'm trying the relative path first, then falling back to normal
# mechanisms. This should be fixed in future versions of puppet but it looks
# like we'll need to maintain this for some time perhaps.
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', '..', '..'))
require 'puppet/resource_api/simple_provider'
require 'puppet/provider/nexus3_utils'

# Implementation for the nexus3_anonymous_settings type using the Resource API.
class Puppet::Provider::Nexus3AnonymousSettings::Nexus3AnonymousSettings < Puppet::ResourceApi::SimpleProvider
  include Puppet::Provider::Nexus3Utils

  def canonicalize(context, resources)
    resources.each do |r|
      apply_default_values(context, r)

      r[:name] = 'global'
      munge_booleans(context, r)
    end
  end

  def create(context, _name, _should)
    context.notice('Not possible to create new Anonymous settings')
  end

  def delete(context, _name)
    context.notice('Not possible to remove Anonymous settings')
  end

  def max_instances_allowed
    1
  end
end
