module MapInspection
  def wall_at?(target)
    @walls ||= board.walls.reduce({}) do |memo, wall|
      memo[wall.x] ||= {}
      memo[wall.x][wall.y] = true
      memo
    end
    (@walls[target.x] || {})[target.y]
  end
end
