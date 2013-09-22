module DriveControl
  def location_heuristic(wall)
    distance(robot, wall)
  end

  def find_drive_target
    if battle.board.walls.length > 0
      target_wall = battle.board.walls.reduce(nil) do |memo, wall|
        if memo.nil? || location_heuristic(wall) < location_heuristic(memo)
          wall
        else
          memo
        end
      end
      battle.board.line_of_sight(target_wall, board.direction_to(target_wall, robot)).first
    end
  end

  def drive_control_turn
    result = nil
    @drive_target_history ||= []
    rt = Benchmark.realtime do
      @drive_target = nil if @drive_target && @drive_target.located_at?(robot)

      unless @drive_target
        @drive_target = find_drive_target
        @drive_target = nil if @drive_target && @drive_target_history.include?([@drive_target.x,@drive_target.y])
      end

      @drive_target = nil if @drive_target && @drive_target.located_at?(robot)

      if @drive_target
        result = move_towards!(@drive_target)
      else
        los = battle.board.line_of_sight(robot, 180)
        if los && los.length > 0 && wall_at?(los.first)
          @drive_target = los.last
        else
          @drive_target = (battle.board.line_of_sight(robot, 0) || []).last
        end
        if @drive_target
          result = move_towards!(@drive_target)
        end
      end

      @drive_target_history << [@drive_target.x, @drive_target.y] if @drive_target
    end

    log "Drive Control Turn handled in #{rt} with result #{result};"
    result
  end
end
