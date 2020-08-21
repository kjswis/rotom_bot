module Util
  module Roles
    extend self

    # Search for Admin Role: Guild Masters
    def admin?(member)
      member.roles.map(&:name).include?('Guild Masters')
    end

    # Search for Booster Role: Nitro Booster
    def booster?(member)
      member.roles.map(&:name).include?('Nitro Booster')
    end
  end
end
