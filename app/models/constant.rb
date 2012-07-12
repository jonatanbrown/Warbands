class Constant

  #Do not forget to change MAX_SKILL_NUM in initializer constants when adding skills

  def self.skills
    [
      ["#{get_skill_name(0)}", 0, get_skill_ap(0), get_skill_targeting(0)],
      ["#{get_skill_name(1)}", 1, get_skill_ap(1), get_skill_targeting(1)],
      ["#{get_skill_name(2)}", 2, get_skill_ap(2), get_skill_targeting(2)],
      ["#{get_skill_name(3)}", 3, get_skill_ap(3), get_skill_targeting(3)]
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
end

