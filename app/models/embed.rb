# frozen_string_literal: true

require_relative 'concerns/serializable'

class Embed
  attr_accessor :title,
                :description,
                :url,
                :color,
                :timestamp,
                :footer,
                :thumbnail,
                :image,
                :author,
                :fields

  include Serializable

  class Footer
    attr_accessor :icon_url, :text
    include Serializable

    def to_hash
      {
        icon_url: icon_url,
        text: text
      }
    end
  end

  class Image
    attr_accessor :url
    include Serializable

    def to_hash
      {
        url: url
      }
    end
  end

  class Author
    attr_accessor :name, :url, :icon_url
    include Serializable

    def to_hash
      {
        name: name,
        url: url,
        icon_url: icon_url
      }
    end
  end

  class Field
    attr_accessor :name, :value, :inline
    include Serializable

    def to_hash
      {
        name: name,
        value: value,
        inline: inline
      }
    end
  end

  def to_hash
    hash = {
      title: title,
      description: description,
      url: url,
      color: int_color,
      timestamp: timestamp
    }
    hash[:footer] = footer if footer
    hash[:thumbnail] = thumbnail if thumbnail
    hash[:image] = image if image
    hash[:author] = author if author
    hash[:fields] = fields if fields

    hash
  end

  def int_color
    return nil unless color

    hex = color.to_s.sub(/\A#/, '0x')
    Integer(hex)
  end

  def self.convert(discord_embed)
    fields = []
    discord_embed.fields.each do |field|
      fields.push({ name: field.name, value: field.value })
    end

    embed = Embed.new(
      title: discord_embed.title,
      description: discord_embed.description,
      url: discord_embed.url,
      color: discord_embed.color&.combined,
      timestamp: discord_embed.timestamp
    )

    embed.footer = {
      icon_url: discord_embed.footer.icon_url,
      text: discord_embed.footer.text
    } if discord_embed.footer
    embed.thumbnail = { url: discord_embed.thumbnail.url } if discord_embed.thumbnail
    embed.image = { url: discord_embed.image.url } if discord_embed.image
    embed.author = {
      icon_url: discord_embed.author.icon_url,
      name: discord_embed.author.name,
      url: discord_embed.author.url,
    } if discord_embed.author
    embed.fields = fields if fields

    embed
  end
end
