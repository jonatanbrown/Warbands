class Constant

  def self.skills
    [
      ["#{get_skill_name(1)}", 1, get_skill_ap(1), get_skill_targeting(1)],
      ["#{get_skill_name(2)}", 2, get_skill_ap(2), get_skill_targeting(2)],
      ["#{get_skill_name(3)}", 3, get_skill_ap(3), get_skill_targeting(3)]
    ].to_s
  end

  def self.get_skill_ap(skill_id)
    if skill_id == 1
      4
    elsif skill_id == 2
      6
    elsif skill_id == 3
      0
    end
  end

  def self.get_skill_name(skill_id)
    if skill_id == 1
      'Strike'
    elsif skill_id == 2
      'Throw'
    elsif skill_id == 3
      'Retreat'
    end
  end

  def self.get_skill_targeting(skill_id)
    if skill_id == 1
      MELEE
    elsif skill_id == 2
      RANGED
    elsif skill_id == 3
      SELF
    end
  end
end

