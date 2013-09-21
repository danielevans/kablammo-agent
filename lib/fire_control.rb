module FireControl
  def targeted_los(source, target)
    los = source.line_of_sight
    target_index = los.index { |pixel| pixel.located_at?(target) }
    if target_index
      los = los[0..target_index]
    else
      nil
    end
  end

  def aimed_properly?(test_robot, target)
    los = targeted_los(robot, target)
    !los.nil? && los.none? { |pixel| wall_at?(pixel) }
  end

  def firing_solutions(target)
    # primary_vector = Vector[(target.x - robot.x).to_f, (target.y - robot.y).to_f]
    # normal_vector = Vector[primary_vector[1], 0 - primary_vector[0]].normalize
    arc = Math.atan(1.0 / Math.sqrt((target.x - robot.x)**2 + (target.y - robot.y)**2)) * 360.0 / Math::PI

    base_direction = robot.direction_to(target)
    test_robot = robot.clone

    # range = (((base_direction - arc).to_i)..(base_direction + arc))
    # samples = (range.step(range.count / 5).to_a + [(base_direction + arc).to_i]).uniq
    samples = [(base_direction - arc + 0.5).to_i, base_direction, (base_direction + arc).to_i].uniq

    samples.select do |rotation|
      test_robot.rotation = rotation
      aimed_properly?(test_robot, target)
    end
  end

  def fire_control_turn
    result = ''
    rt = Benchmark.realtime do
      solutions = nil
      target = opponents.first { |enemy| can_fire_at?(enemy) } || opponents.first

      if target
        if aimed_properly?(robot, target)
          solutions = [robot.rotation]
        else
          solutions = firing_solutions(target)
        end
      end
      if target && !solutions.empty?
        immediate_solutions = solutions.select { |s| (s - robot.rotation).abs <= MAX_SKEW }
        unless immediate_solutions.empty?
          result = fire!((immediate_solutions[immediate_solutions.length / 2] - robot.direction_to(target) +0.5).to_i)
        else
          result = rotate!((solutions[solutions.length / 2] +0.5).to_i)
        end
      elsif robot.ammo <= 1
        result = rest!
      end
    end

    puts "Fire Control Turn handled in #{rt}"
    result
  end
end
