module DriveControl
  def drive_control_turn
    result = ''
    rt = Benchmark.realtime do
      result = rest!
    end

    puts "Drive Control Turn handled in #{rt}"
    result
  end
end
