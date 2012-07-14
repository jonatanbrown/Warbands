class Constant

  #Do not forget to change MAX_SKILL_NUM in initializer constants when adding skills

  def self.skills
    [
      ["#{get_skill_name(0)}", 0, get_skill_ap(0), get_skill_targeting(0)],
      ["#{get_skill_name(1)}", 1, get_skill_ap(1), get_skill_targeting(1)],
      ["#{get_skill_name(2)}", 2, get_skill_ap(2), get_skill_targeting(2)],
      ["#{get_skill_name(3)}", 3, get_skill_ap(3), get_skill_targeting(3)],
      ["#{get_skill_name(4)}", 4, get_skill_ap(4), get_skill_targeting(4)],
      ["#{get_skill_name(5)}", 5, get_skill_ap(5), get_skill_targeting(5)],
      ["#{get_skill_name(6)}", 6, get_skill_ap(6), get_skill_targeting(6)],
      ["#{get_skill_name(7)}", 7, get_skill_ap(7), get_skill_targeting(7)],
      ["#{get_skill_name(8)}", 8, get_skill_ap(8), get_skill_targeting(8)],
      ["#{get_skill_name(9)}", 9, get_skill_ap(9), get_skill_targeting(9)],
      ["#{get_skill_name(10)}", 10, get_skill_ap(10), get_skill_targeting(10)]
    ].to_s
  end

  def self.get_skill_name(skill_id)
    if skill_id == SKILL_STRIKE
      'Strike'
    elsif skill_id == SKILL_THROWN
      'Throw'
    elsif skill_id == SKILL_RETREAT
      'Retreat'
    elsif skill_id == SKILL_DIRT
      'Throw Dirt'
    elsif skill_id == SKILL_DEFENSIVE_POSTURE
      'Defensive Posture'
    elsif skill_id == SKILL_COVER
      'Take Cover'
    elsif skill_id == SKILL_QUICK_STRIKE
      'Quick Strike'
    elsif skill_id == SKILL_HEAVY_STRIKE
      'Heavy Strike'
    elsif skill_id == SKILL_ACCURATE_STRIKE
      'Accurate Strike'
    elsif skill_id == SKILL_FINISHING_STRIKE
      'Finishing Strike'
    elsif skill_id == SKILL_PROTECT
      'Protect'
    end
  end

  def self.get_skill_ap(skill_id)
    if skill_id == SKILL_STRIKE
      4
    elsif skill_id == SKILL_THROWN
      6
    elsif skill_id == SKILL_RETREAT
      0
    elsif skill_id == SKILL_DIRT
      6
    elsif skill_id == SKILL_DEFENSIVE_POSTURE
      5
    elsif skill_id == SKILL_COVER
      5
    elsif skill_id == SKILL_QUICK_STRIKE
      4
    elsif skill_id == SKILL_HEAVY_STRIKE
      4
    elsif skill_id == SKILL_ACCURATE_STRIKE
      6
    elsif skill_id == SKILL_FINISHING_STRIKE
      8
    elsif skill_id == SKILL_PROTECT
      5
    end
  end

  def self.get_skill_targeting(skill_id)
    if skill_id == SKILL_STRIKE
      MELEE
    elsif skill_id == SKILL_THROWN
      RANGED
    elsif skill_id == SKILL_RETREAT
      SELF
    elsif skill_id == SKILL_DIRT
      RANGED
    elsif skill_id == SKILL_DEFENSIVE_POSTURE
      SELF
    elsif skill_id == SKILL_COVER
      SELF
    elsif skill_id == SKILL_QUICK_STRIKE
      MELEE
    elsif skill_id == SKILL_HEAVY_STRIKE
      MELEE
    elsif skill_id == SKILL_ACCURATE_STRIKE
      MELEE
    elsif skill_id == SKILL_FINISHING_STRIKE
      MELEE
    elsif skill_id == SKILL_PROTECT
      FRIENDLY_NONSELF
    end
  end

  def self.get_effect_name(effect_id)
    if effect_id == 0
      'Blinded'
    end
  end

  def self.effect_beneficial?(effect_id)
    if [0].include?(effect_id)
      false
    else
      true
    end
  end

  def self.get_effect_color_tag(effect_id)
    if [0].include?(effect_id)
      "<span class='red'>"
    elsif false
      "<span class='green'>"
    else
      "<span>"
    end
  end

  def self.get_cryptic_str(str)
    if str < 4
      'Puny'
    elsif str < 8
      'Weak'
    elsif str < 12
      'Average'
    elsif str < 16
      'Strong'
    elsif str < 20
      'Herculean'
    else
      'Godlike'
    end
  end

  def self.get_cryptic_dex(dex)
    if dex < 4
      'Immobile'
    elsif dex < 8
      'Clumsy'
    elsif dex < 12
      'Average'
    elsif dex < 16
      'Dexterous'
    elsif dex < 20
      'Graceful'
    else
      'Godlike'
    end
  end

  def self.get_cryptic_tgh(tgh)
    if tgh < 4
      'Brittle'
    elsif tgh < 8
      'Vulnerable'
    elsif tgh < 12
      'Average'
    elsif tgh < 16
      'Tough'
    elsif tgh < 20
      'Ironman'
    else
      'Godlike'
    end
  end

  def self.get_cryptic_ini(ini)
    if ini < 4
      'Slothlike'
    elsif ini < 8
      'Slow'
    elsif ini < 12
      'Average'
    elsif ini < 16
      'Fast'
    elsif ini < 20
      'Lizardish'
    else
      'Godlike'
    end
  end
end

