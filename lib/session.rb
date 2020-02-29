require_relative "steep"

class Session
  attr_reader :plan, :logger, :last_length

  def initialize(plan:, logger:)
    @plan = plan
    @logger = logger
    @last_length = 0
    @incrementer_count = 0
  end

  def next
    step = next_step

    length = length_from(step)
    binding.pry
    capture_length(length)

    Steep
      .new(length: length, logger: logger)
      .start
  end

  private

  def steps
    @steps ||= plan.config
  end

  def next_step
    steps.shift.tap do |step|
      steps << step if steps.empty?
    end
  end

  def length_from(step)
    if step[:length]
      step[:length]
    elsif step[:increment]
      last_length + step[:increment].to_i
    end
  end

  def capture_length(length)
    @last_length += length
  end
end
