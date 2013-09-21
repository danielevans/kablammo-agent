module FireControl
  def aimed_properly?(test_robot, target)
    los = targeted_los(test_robot, target)
    los && los.none? { |pixel| wall_at?(pixel) } && los.last.located_at?(target)
  end

  def firing_solutions(r, target)
    # primary_vector = Vector[(target.x - robot.x).to_f, (target.y - robot.y).to_f]
    # normal_vector = Vector[primary_vector[1], 0 - primary_vector[0]].normalize
    arc = Math.atan(1.0 / Math.sqrt((target.x - r.x)**2 + (target.y - r.y)**2)) * 360.0 / Math::PI

    base_direction = r.direction_to(target)
    test_robot = r.clone

    range = (((base_direction - arc).to_i)..(base_direction + arc))
    samples = (range.to_a + [(base_direction + arc).to_i]).uniq
    # samples = [(base_direction - arc + 0.5).to_i, base_direction, (base_direction + arc).to_i].uniq

    samples.select do |rotation|
      test_robot.rotation = rotation
      aimed_properly?(test_robot, target)
    end
  end

  def fire_control_turn
    result = nil
    rt = Benchmark.realtime do
      solutions = nil
      target = choose_target
      # log 'starting'
      # log target
      if target
        if aimed_properly?(robot, target)
          # log "Aimed Properly"
          # log "#{robot.line_of_sight}"
          solutions = [robot.rotation]
        else
          solutions = firing_solutions(robot, target)
        end
      end
      # log "#{(solutions || []).length} solutions found"
      if target && !solutions.empty? && robot.ammo > 0
        immediate_solutions = solutions.select { |s| (s - robot.rotation).abs <= Strategy::Constants::MAX_SKEW }
        # log "#{immediate_solutions.length} imeediate solutions found"
        unless immediate_solutions.empty?
          result = fire!((immediate_solutions[immediate_solutions.length / 2] - robot.rotation + 0.5).to_i)
        else
          result = rotate!((solutions[solutions.length / 2] +0.5).to_i)
        end
      elsif robot.ammo <= 1
        result = rest
      end
    end

    log "Fire Control Turn handled in #{rt}, with result #{result};"
    result
  end
end
