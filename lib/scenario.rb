require 'yaml'

require_relative 'vagrantfile_renderer'

# Takes a scenario .yml file and compiles it into the vagrant and puppet files
# nessecary to boot the scenario up.
class Scenario
  attr_reader :location

  def initialize(name, location = 'production')
    path = File.join(ROOT_DIR, 'scenarios', location, name)
    @scenario = YAML.load_file(File.join(path, "#{name}.yml"))
    @uid = generate_uid
  end

  def compile!(out_dir)
    setup_directory!(out_dir)

    @scenario['Clouds'].each do |cloud|
      cloud['Subnets'].each do |subnet|
        subnet['Instances'].each do |instance|
          compile_instance!(cloud, subnet, instance)
        end
      end
    end
  end

  private

  def setup_directory!(out_dir)
    # create compilations directory if it doesn't exist
    Dir.mkdir(out_dir) unless File.exist?(out_dir)

    # delete colliding compilation directory if any and create a new
    compile_dir = File.join(out_dir, @uid)
    File.rm_rf(compile_dir) if File.exist?(compile_dir)
    Dir.mkdir(compile_dir)

    # create a directory for instances
    @instances_dir = File.join(compile_dir, 'instances')
    Dir.mkdir(@instances_dir)
  end

  def compile_instance!(cloud, subnet, instance)
    instance_dir = File.join(@instances_dir, instance['Name'])
    Dir.mkdir(instance_dir) unless File.exist?(instance_dir)

    # process template
    output = VagrantfileRenderer.new(@scenario, cloud, subnet, instance).render
    File.write(File.join(instance_dir, 'Vagrantfile'), output)
  end

  # generate a uid from the scenario name and current time
  def generate_uid
    timestamp = Time.now.to_i
    [@scenario['Name'].tr(' ', '_'), timestamp].join('_').tr(' ', '_')
  end
end
