require_relative "steep"

class Session
  attr_reader :plan, :logger

  def initialize(plan:, logger:)
    @plan = plan
    @logger = logger
  end

  def next
    step = next_step

    Steep
      .new(length: step[:length], logger: logger)
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
end
