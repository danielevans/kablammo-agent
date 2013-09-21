require 'benchmark'
require 'pp'
require './lib/map_inspection.rb'
require './lib/fire_control.rb'
require './lib/drive_control.rb'
require './lib/predictive_targeting.rb'

@debug = true

include MapInspection
include FireControl
include DriveControl
include PredictiveTargeting

def log(message)
  puts message if @debug
end

def handle_turn
  result = fire_control_turn
  result ||= predictive_targeting_turn
  result ||= drive_control_turn
  target = choose_target
  result ||= rotate(robot.direction_to(target)) if target
  resutl ||= rest
  result
end

on_turn do
  result = nil
  rt = Benchmark.realtime do
    result = handle_turn
  end
  log "done in #{rt}, result is #{result};"
  result
end
