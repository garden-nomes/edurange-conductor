require 'erb'

# Generates a +Vagrantfile+ for a particular instance.
class VagrantfileRenderer
  attr_accessor :scenario, :cloud, :subnet, :instance

  def initialize(scenario, cloud, subnet, instance)
    @scenario = scenario
    @cloud = cloud
    @subnet = subnet
    @instance = instance
  end

  def render
    renderer = ERB.new(load_template)
    renderer.result(binding)
  end

  private

  def load_template
    template_path = File.join(ROOT_DIR, 'templates', 'Vagrantfile.erb')
    File.read(template_path)
  end

  # Helper functions for Vagrantfil template

  def vm_name
    @vm_name ||=
      [scenario['Name'], instance['Name']].join('_').tr(' ', '_').downcase
  end

  def network_name
    @network_name ||=
      ['edurange', scenario['Name']].join('_').tr(' ', '_').downcase
  end

  def nat?
    instance['OS'] == 'nat'
  end

  def generate_nat_ip
    # Yank the ip from the CIDR block (e.g. '10.0.129.0' from '10.0.129.0/24')
    ip, = subnet['CIDR_Block'].split('/')

    # Use .2 as the nat location? Turns '10.0.129.0' into '10.0.129.2'
    sections = ip.split('.')
    sections[3] = '2'
    sections.join('.')
  end
end
