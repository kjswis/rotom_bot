class UsersController
  def self.stat_image(user, member, stats=nil)
    size_width = 570;
    size_height = 376;
    stats_frame =  "../../images/LevelUp.png"
    level_up = "../../images/LevelUpFont.png"
    user_url_img = "../../images/Image_Builder/user_url_img.png"
    output_file =  "../../images/Image_Builder/LevelUp"

    Down.download(member.avatar_url, destination: user_url_img)

    #Gif Destroyer
    i = Magick::ImageList.new(user_url_img)
    i[0].write(user_url_img) if i.count > 1

    if stats
      merge_image(
        [stats_frame, level_up, user_url_img],
        output_file,
        size_width,
        size_height,
        [nil, nil, 19],
        [nil, nil, 92],
        [size_width, size_width, 165],
        [size_height, size_height, 165]
      )
    else
      merge_image(
        [stats_frame, user_url_img],
        output_file,
        size_width,
        size_height,
        [nil, 19],
        [nil, 92],
        [size_width, 165],
        [size_height, 165]
      )
    end

    ratio = 0.5
    user_name = member.nickname || member.name
    short_name = user_name.length > 25 ? "#{user_name[0..22]}..." : user_name
    rank = User.order(unboosted_xp: :desc)
    user_rank = rank.detect{ |r| r.id == user.id }

    gc = Draw.new

    gc.font('../../OpenSans-SemiBold.ttf')

    gc.stroke('#39c4ff').fill('#39c4ff')
    gc.rectangle(42, 48, 42 + (95 * ratio), 48 + 3)

    gc.stroke('none').fill('black')
    gc.pointsize('15')
    gc.text(15,25, short_name)
    gc.text(40, 45, user.level.to_s)
    gc.text(15, 290, user_rank.to_s)
    gc.text(40, 65, user.boosted_xp.to_s)

    gc.stroke('white').fill('white')
    gc.pointsize('30')
    gc.text(40,330, user_name)
    reached = "reached level #{user.level}!"
    gc.text(40,360, reached)

    if stats
      gc.stroke('none').fill('black')
      gc.pointsize('18')
      gc.text(450, 97, stats['hp'].to_s)
      gc.text(450, 127, stats['attack'].to_s)
      gc.text(450, 159, stats['defense'].to_s)
      gc.text(450, 191, stats['sp_attack'].to_s)
      gc.text(450, 222, stats['sp_defense'].to_s)
      gc.text(450, 255, stats['speed'].to_s)

      gc.stroke('none').fill('maroon')
      gc.text(505, 97, user.hp - stats['hp'].to_s)
      gc.text(505, 127, user.attack - stats['attack'].to_s)
      gc.text(505, 159, user.defense - stats['defense'].to_s)
      gc.text(505, 191, user.sp_attack - stats['sp_attack'].to_s)
      gc.text(505, 222, user.sp_defense - stats['sp_defense'].to_s)
      gc.text(505, 255, user.speed - stats['speed'].to_s)
    else
      gc.stroke('none').fill('black')
      gc.pointsize('18')
      gc.text(450, 97, user.hp.to_s)
      gc.text(450, 127, user.attack.to_s)
      gc.text(450, 159, user.defense.to_s)
      gc.text(450, 191, user.sp_attack.to_s)
      gc.text(450, 222, user.sp_defense.to_s)
      gc.text(450, 255, user.speed.to_s)
    end

    u = Magick::ImageList.new("#{output_file}.png")
    gc.draw(u[0])

    u.write("#{output_file}.png")
  end
end
