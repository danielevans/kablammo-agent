module PredictiveTargeting
  def predictive_firing_solutions(target)
    targets = 4.time.map do
      target.clone
    end
    targets[0].x -= 1
    targets[1].x += 1
    targets[2].y -= 1
    targets[3].y += 1
    targets.map do |target|
      solutions = firing_solutions(robot, target)
      unless solutions.empty?
        solutions[solution.length / 2]
      end
    end.compact.uniq
  end

  def predictive_targeting_turn
    result = nil
    rt = Benchmark.realtime do
      target = choose_target
      if target
        solutions = predictive_firing_solutions(target)
        result = rotate(solutions.first.to_i) unless solutions.empty?
      end
    end
    log "Predictive Targeting Turn finished in #{rt} with result #{result};"
    result
  end
end
