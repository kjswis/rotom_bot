class User < ActiveRecord::Base
  validates :id, presence: true

  def allowed_chars(member)
    # Determine if the member is a Nitro Booster
    booster = Util::Roles.booster?(member) ? 2 : 1
    level / 10 + booster
  end

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

  def update_xp(msg_length, member=nil)
    xp =
      case msg_length
      when 0..39 then 0
      when 40..149 then 1
      when 150..299 then 2
      when 300..599 then 3
      when 600..999 then 4
      else 5
      end

    self.update(
      boosted_xp: boosted_xp + xp,
      unboosted_xp: unboosted_xp + xp
    )

    self.reload
    reply = level_up(member) if next_level && boosted_xp > next_level

    reply
  end

  def level_up(member=nil)
    if level < 100
      next_level = (level + 6) ** 3 / 10.0
      self.update(level: level + 1, next_level: next_level.round)
      self.reload
    else
      self.update(level: level + 1, next_level: nil)
      self.reload
    end

    n = Nature.find(nature)

    stats = stat_calc(n.up_stat, n.down_stat)
    img = UsersController.stat_image(self, member, stats) if member

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
end
