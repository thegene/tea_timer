class Step
  attr_reader :length, :logger

  def initialize(length:, logger:)
    @length = length.to_i
    @logger = logger
  end

  def run
    while length > 0 do

      log_multiples_of_ten

      sleep(1)

      decrement
    end

    finished
  end

  private

  def finished
    logger.info("done")
  end

  def decrement
    @length -= 1
  end

  def log_multiples_of_ten
    logger.info(length.to_s) if length % 10 == 0
  end
end
