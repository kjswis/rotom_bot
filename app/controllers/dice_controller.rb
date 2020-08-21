class DiceController
  def self.roll(die)
    case die
    when Hash
      # If number of die isn't specified, set it to 1
      die[:number] = die[:number] || 1

      # Create array to save each roll
      results = []
      die[:number].times do
        results.push(rand(1 .. die[:sides]))
      end

      # Return results array
      die[:results] = results
      die
    when Array
      { sides: die, results: [die.sample] }
    end
  end

  def self.edit_die(die_array, die, array)
    if die_array.nil?
      # Create
      DieArray.create(name: die, sides: array)
      success_embed("Created #{die}: #{array.join(", ")}")
    elsif array.include?(/delete/i)
      # Destroy
      die_array.destroy
      success_embed("Deleted #{die}!")
    else
      # Update
      die_array.update(sides: array)
      die_array.reload
      success_embed("Updated #{die}: #{array.join(", ")}")
    end
  end
end
