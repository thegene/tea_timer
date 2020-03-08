class Steep
  attr_reader :length

  def initialize(length:)
    @length = length.to_i
  end

  def start
    while length > 0 do
      sleep(1)
      decrement
    end
  end

  private

  def decrement
    @length -= 1
  end
end
