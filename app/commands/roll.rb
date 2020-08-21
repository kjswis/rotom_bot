class RollCommand < BaseCommand
  def self.opts
    {
      usage: {
        die: "Rolls a specified die. Can be a list of options, a name of a saved die, " +
        "or an indication of standard dice. Standard Die are designated as `xDy` " +
        "where `x` designates the number of die to roll, and `y` designates the number of sides" +
        " on the die. A modifier can be added with a + or - number: Added to total." +
        " If no die is specified, displays a list of all saved dice",
        combined: "Indicates you don't want to see the individual rolls, only the total." +
        " If left empty it will show each individual roll (unless more than 25 dice were rolled)"
      }
    }
  end

  def self.cmd
    desc = 'Roll a saved die, a comma separated list, or a standard die'

    @cmd ||= Command.new(:roll, desc, opts) do |event, die, array|
      # Save author
      author = event.author

      # Determine die and roll it
      # Display a list of saved dice
      if die.nil?
        dice_list

      elsif d = die.gsub(" ", "").match(/([0-9]*?)d([0-9]+)([\+|\-]?[0-9]+)?/i)
        # Roll the dice, and save it in the hash
        hash = DiceController.roll({
          number: d[1] == "" ? 1 : d[1].to_i ,
          sides: d[2].to_i,
          modifier: d[3]
        })

        # Determine if each result should be displayed
        # Format the results into an embed, and reply
        combine = array&.match(/combined?/i) || hash[:number] > 25 || hash[:number] == 1
        roll_results(author, hash, combine)

      # Create an array and roll it
      elsif die.match(/,/)
        hash = DiceController.roll(die.split(/\s?,\s?/))
        roll_results(author, hash)

      # Create/Update/Destroy a new dice
      elsif array && Util::Roles.admin?(author)
        # Attempt to find die, then update
        die_array = DieArray.find_by('name ilike ?', die)
        DiceController.edit_die(die_array, die, array&.split(/\s?,\s?/))

      # Roll a saved Die
      else
        die_array = DieArray.find_by!('name ilike ?', die)

        hash = DiceController.roll(die_array.sides)
        roll_results(author, hash)
      end
    rescue ActiveRecord::RecordNotFound => e
      error_embed("Record Not Found!", e.message)
    rescue StandardError => e
      error_embed(e.message)
    end
  end

  def self.example_command(event=nil)
    list = [
      'Hotdog, Hamburger, Chilli Cheese Fries, Nachos, Fried Onions',
      'A, B, C, D',
      'Cat, Dog, Mouse, Frog, Squirrel, Turtle, Dragon',
      'Eevee, Vaporeon, Flareon, Jolteon, Espeon, Umbreon, Glaceon, Leafeon, Sylveon',
      'Sword, Sheild, Gun, Bomb, Tank, Fighter Jet'
    ].sample

    case ['', 'standard', 'modifier', 'list', 'named', 'combined'].sample
    when ''
      []
    when 'standard'
      [ "#{rand(1 .. 70)}d#{rand(2 .. 420)}" ]
    when 'modifier'
      [ "#{rand(1 .. 70)}d#{rand(2 .. 420)} #{['+', '-'].sample}#{rand(1 .. 10)}" ]
    when 'list'
      [ list ]
    when 'named'
      [ DiceArray.order('RANDOM()').first.name ]
    when 'combined'
      [ "#{rand(1 .. 70)}d#{rand(2 .. 420)}", 'combined' ]
    end
  end

  def self.admin_opts
    {
      usage: {
        die: "New die name",
        sides: "Sides of die, `delete` will delete the stored die"
      }
    }
  end
end
