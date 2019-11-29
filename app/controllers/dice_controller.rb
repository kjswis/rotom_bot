class DiceController
  def self.roll(die)
    case die
    when String
      match = /([0-9]*?)d([0-9]+)/.match(die)
      num = match[1].to_i || 1
      sides = match[2].to_i
      num = 1 if num == 0

      r = 0
      num.times do
        r += rand(1 .. sides)
      end

      r
    when Array
      die.sample
    end
  end
end
