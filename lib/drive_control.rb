module DriveControl
  def location_heuristic(target, wall)
    heuristic = distance(robot, wall)
    if target
      heuristic += distance(target, wall)
    end
    heuristic
  end

  def find_drive_target(target)
    if battle.board.walls.length > 0
      target_wall = battle.board.walls.reduce(nil) do |memo, wall|
        if memo.nil? || location_heuristic(target, wall) < location_heuristic(target, memo)
          wall
        else
          memo
        end
      end
      target = board.line_of_sight(target_wall, 360 - robot.direction_to(target_wall)).first
      target unless robot.located_at?(target)
    end
  end

  def drive_control_turn
    @drive_target_history ||= []
    result = nil
    rt = Benchmark.realtime do
      target = choose_target
      if !@drive_target
        @drive_target = find_drive_target(target)
        if @drive_target_history.include?(@drive_target) || @drive_target.nil?
          @drive_target = nil
        else
          @drive_target_history << @drive_target
        end
      end

      if @drive_target && @drive_target.located_at?(robot)
        @drive_target = nil
      end

      if @drive_target
        result = move_towards!(@drive_target)
      elsif target
        result = move_towards!(target)
      end
    end

    log "Drive Control Turn handled in #{rt} with result #{result};"
    result
  end
end
