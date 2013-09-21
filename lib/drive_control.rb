module DriveControl
  def find_drive_target
  end

  def drive_control_turn
    result = nil
    rt = Benchmark.realtime do
      if !@drive_target && battle.board.walls.length > 0
        @drive_target = find_drive_target
      end

      if @drive_target
        result = move_towards(@drive_target)
      end
    end

    log "Drive Control Turn handled in #{rt} with result #{result};"
    result
  end
end
