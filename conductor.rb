#!/usr/bin/env ruby

require 'pp'
require_relative 'lib/scenario'
require_relative 'lib/scenario_list'

ROOT_DIR = File.dirname(__FILE__)
COMPILE_DIR = File.join(ROOT_DIR, 'compile')

def main
  scenario_name = ARGV[0]
  scenario_location = ARGV[1] || 'production'

  return if scenario_name.nil?
  Scenario.new(scenario_name, scenario_location).compile!(COMPILE_DIR)
end

main
