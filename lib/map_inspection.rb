module MapInspection
  def targeted_los(source, target)
    los = source.line_of_sight
    target_index = los.index { |pixel| pixel.x == target.x && pixel.y == target.y }
    if target_index
      los = los[0..target_index]
    else
      nil
    end
  end

  def distance(a,b)
    Math.sqrt((a.x - b.x)**2 + (a.y - b.y)**2)
  end

  def wall_at?(target)
    @walls ||= board.walls.reduce({}) do |memo, wall|
      memo[wall.x] ||= {}
      memo[wall.x][wall.y] = true
      memo
    end
    (@walls[target.x] || {})[target.y]
  end

  def choose_target
    opponents.first { |enemy| can_fire_at?(enemy) } || opponents.first
  end
end
