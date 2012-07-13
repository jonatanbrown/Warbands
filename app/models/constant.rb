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
      ["#{get_skill_name(9)}", 9, get_skill_ap(9), get_skill_targeting(9)]
    ].to_s
  end

  def self.get_skill_name(skill_id)
    if skill_id == 0
      'Strike'
    elsif skill_id == 1
      'Throw'
    elsif skill_id == 2
      'Retreat'
    elsif skill_id == 3
      'Throw Dirt'
    elsif skill_id == 4
      'Defensive Posture'
    elsif skill_id == 5
      'Take Cover'
    elsif skill_id == 6
      'Quick Strike'
    elsif skill_id == 7
      'Heavy Strike'
    elsif skill_id == 8
      'Accurate Strike'
    elsif skill_id == 9
      'Finishing Strike'
    end
  end

  def self.get_skill_ap(skill_id)
    if skill_id == 0
      4
    elsif skill_id == 1
      6
    elsif skill_id == 2
      0
    elsif skill_id == 3
      6
    elsif skill_id == 4
      5
    elsif skill_id == 5
      5
    elsif skill_id == 6
      4
    elsif skill_id == 7
      4
    elsif skill_id == 8
      6
    elsif skill_id == 9
      8
    end
  end

  def self.get_skill_targeting(skill_id)
    if skill_id == 0
      MELEE
    elsif skill_id == 1
      RANGED
    elsif skill_id == 2
      SELF
    elsif skill_id == 3
      RANGED
    elsif skill_id == 4
      SELF
    elsif skill_id == 5
      SELF
    elsif skill_id == 6
      MELEE
    elsif skill_id == 7
      MELEE
    elsif skill_id == 8
      MELEE
    elsif skill_id == 9
      MELEE
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

