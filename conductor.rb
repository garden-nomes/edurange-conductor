#!/usr/bin/env ruby

require_relative 'lib/scenario_compiler'

ROOT_DIR = File.dirname(__FILE__)
COMPILE_DIR = File.join(ROOT_DIR, 'compile')

def usage
  puts "Usage: #{$PROGRAM_NAME} <scenario_file>"
  exit
end

def main
  usage if ARGV.length != 1

  fname = ARGV[0]
  output_dir = ScenarioCompiler.new(fname).compile!(COMPILE_DIR)
  puts "Wrote scenario to #{output_dir}"
end

main
