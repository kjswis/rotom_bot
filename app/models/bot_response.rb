class BotResponse
  def initialize(destination: nil, text: "", embed: nil, timer: nil, file: nil, carousel: nil, reactions: [])
    @destination = destination
    @text = text
    @timer = timer
    @embed = embed
    @file = file
    @reactions = reactions
    @carousel = carousel
  end

  def call(event, bot)
    # Send message and embed(s)
    if @file
      message = bot.send_file(@destination, File.open(@file, 'r'))
    elsif @timer
      message = bot.send_temporary_message(
        @destination,
        @text,
        @timer,
        false,
        @embed
      )
    elsif @destination
      message = bot.send_message(
        @destination,
        @text,
        false,
        @embed
      )
    elsif !@carousel.is_a? Carousel
      message = event.send_embed(@text, @embed)
    end

    # Create/Update Carousel
    case @carousel
    when Carousel
      event.message.edit(@text, @embed)
      message = event.message
    when Character
      Carousel.create(message_id: message.id, char_id: @carousel.id)
    when Landmark
      Carousel.create(message_id: message.id, landmark_id: @carousel.id)
    when Fable
      Carousel.create(message_id: message.id, fable_id: @carousel.id)
    when JournalEntry
      Carousel.create(message_id: message.id, char_id: @carousel.char_id, journal_page: 1)
    when CharImage
      Carousel.create(
        message_id: message.id,
        image_id: @carousel.id
      )
    when Array
      Carousel.create(message_id: message.id, options: @carousel)
    when String
      Carousel.create(message_id: message.id)
    end

    # React
    @reactions.each do |reaction|
      message.react(reaction)
    end
  end
end
