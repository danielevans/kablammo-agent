module MapInspection
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
end
