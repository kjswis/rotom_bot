class User < ActiveRecord::Base
  validates :id, presence: true

  def make_stats
    stats = {}

    stats['hp_base'] = rand(1..184)
    stats['s_base'] = 185 - stats['hp_base']
    stats['a_base'] = rand(1..184)
    stats['sa_base'] = 185 - stats['a_base']
    stats['d_base'] = rand(1..184)
    stats['sd_base'] = 185 - stats['d_base']

    self.update(stats)
    self.update(
      hp_iv: rand(0..31),
      a_iv: rand(0..31),
      d_iv: rand(0..31),
      sa_iv: rand(0..31),
      sd_iv: rand(0..31),
      s_iv: rand(0..31),
      nature: rand(1..25)
    )

    self.reload

    n = Nature.find(nature)
    stats = stat_calc(n.up_stat, n.down_stat)
    self.update(stats)

    self.reload
    self
  end

  def update_xp(msg, user=nil)
    xp =
      case msg.length
      when 0..40 then 0
      when 40..149 then 1
      when 150..299 then 2
      when 300..599 then 3
      when 600..1000 then 4
      else 5
      end

    self.update(
      boosted_xp: boosted_xp + xp,
      unboosted_xp: unboosted_xp + xp
    )

    self.reload
    reply = level_up(user) if next_level && boosted_xp > next_level

    reply
  end

  def level_up(user=nil)
    if level < 100
      next_level = (level + 6) ** 3 / 10.0
      self.update(level: level + 1, next_level: next_level.round)
    else
      self.update(level: level + 1, next_level: nil)
    end

    n = Nature.find(nature)

    stats = stat_calc(n.up_stat, n.down_stat)
    img = stat_image(self, user, stats) if user

    self.update(stats)
    self.reload

    img
  end

  def stat_calc(up_stat, down_stat)
    stats = {}
    stats['hp'] =
      ((2 * hp_base + hp_iv + (hp_ev / 4)) * level) / 100 + level + 10
    stats['attack'] =
      (((2 * a_base + a_iv + (a_ev / 4)) * level) / 100) + 5
    stats['defense'] =
      (((2 * d_base + d_iv + (d_ev / 4)) * level) / 100) + 5
    stats['sp_attack'] =
      (((2 * sa_base + sa_iv + (sa_ev / 4)) * level) / 100) + 5
    stats['sp_defense'] =
      (((2 * sd_base + sd_iv + (sd_ev / 4)) * level) / 100) + 5
    stats['speed'] =
      (((2 * s_base + s_iv + (s_ev / 4)) * level) / 100) + 5

    case up_stat
    when /attack/ then stats['attack'] = (stats['attack'] * 1.1).round
    when /defense/ then stats['defense'] = (stats['defense'] * 1.1).round
    when /sp_attack/ then stats['sp_attack'] = (stats['sp_attack'] * 1.1).round
    when /sp_defense/ then stats['sp_defense'] = (stats['sp_defense'] * 1.1).round
    when /speed/ then stats['speed'] = (stats['speed'] * 1.1).round
    end

    case down_stat
    when /attack/ then stats['attack'] = (stats['attack'] * 0.9).round
    when /defense/ then stats['defense'] = (stats['defense'] * 0.9).round
    when /sp_attack/ then stats['sp_attack'] = (stats['sp_attack'] * 0.9).round
    when /sp_defense/ then stats['sp_defense'] = (stats['sp_defense'] * 0.9).round
    when /speed/ then stats['speed'] = (stats['speed'] * 0.9).round
    end

    stats
  end

  def self.import_user(file)
    file.each do |line|
      usr = line.split(",")
      id = usr[0]
      b_xp = usr[3].to_i
      ub_xp = usr[17].to_i > 0 ? usr[17].to_i : usr[3].to_i

      if user = User.find_by(id: id)
        user.update(
          level: 1,
          next_level: 22,
          boosted_xp: b_xp,
          unboosted_xp: ub_xp
        )
        user.reload
      else
        user = User.create(
          id: id,
          level: 1,
          next_level: 22,
          boosted_xp: b_xp,
          unboosted_xp: ub_xp
        )
      end

      user = user.make_stats
      until user.next_level > user.boosted_xp
        user.level_up
      end
    end
  end
end
