require_relative "steep"

class Session
  attr_reader :plan
  attr_accessor :last_steep, :count, :current_step

  def initialize(plan:)
    @plan = plan
    @last_steep = 0
    @incrementer_count = 0
    @current_step = nil
    @count = 0
  end

  def next_steep
    step = next_step

    length_strategy = strategy_from(step)
    length = length_strategy.length

    self.last_steep = length

    Steep.new(length: length)
  end

  private

  def step_count(step)
    step[:count]&.to_i || 1
  end

  def steps
    @steps ||= plan
  end

  def next_step
    self.count -= 1
    if self.count > 0
      current_step
    else
      steps.shift.tap do |step|
        steps << step if steps.empty?

        self.count = step_count(step)
        self.current_step = step
      end
    end
  end

  def strategy_from(step)
    if step[:increment]
      IncrementStrategy.new(last_steep, step)
    elsif step[:length]
      ExactStrategy.new(step)
    end
  end

  class ExactStrategy
    attr_reader :length

    def initialize(step)
      @length = step.fetch(:length).to_i
    end
  end

  class IncrementStrategy
    attr_reader :increment, :last_steep

    def initialize(last_steep, step)
      @increment = step.fetch(:increment)
      @last_steep = last_steep
    end

    def length
      last_steep.to_i + increment.to_i
    end
  end
end
