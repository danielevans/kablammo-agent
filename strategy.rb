require 'pp'
class Cell
  include Strategy::Model::Target
  def initialize(x,y)
    @x = x
    @y = y
  end
end

def firing_line_clear?(x,y)
  # # deal with verticle and horizontal lines
  # cells = []
  # m = (x - robot.x).to_f / (y - robot.x).to_f
  # b = (y - m * x).to_f
  # cells += (([x, robot.x].min)..([x, robot.x].max)).map do |line|
  #   line_y = m * line + b
  #   [Cell.new(line, line_y), Cell.new(line-1, line_y)]
  # end
  # cells += (([y, robot.y].min)..([y, robot.y].max)).map do |line|
  #   line_x = (line - b) / m
  #   [Cell.new(line_x, line), Cell.new(line_x, line)]
  # end

  # cells.flatten!.uniq!.none? do |cell|
  #   battle.board.walls.any? { |w| w.located_at? cell }
  # end
end

def handle_turn
  begin
    # target = opponents.first { |enemy| can_fire_at?(enemy) } || opponents.first
    target = opponents.first

    if target && aiming_at?(target) && robot.ammo > 0
      fire!
    elsif target && (robot.ammo > 0 || robot.ammo == 10)
      aim_at!(target)
    else
      rest
    end

  rescue Exception => e
    puts e
    rest
  end
end

on_turn do
  handle_turn
end
