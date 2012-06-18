class Constant

  def self.skills
    [
      ["#{get_skill_name(0)}", 0, get_skill_ap(0), get_skill_targeting(0)],
      ["#{get_skill_name(1)}", 1, get_skill_ap(1), get_skill_targeting(1)],
      ["#{get_skill_name(2)}", 2, get_skill_ap(2), get_skill_targeting(2)]
    ].to_s
  end

  def self.get_skill_name(skill_id)
    if skill_id == 0
      'Strike'
    elsif skill_id == 1
      'Throw'
    elsif skill_id == 2
      'Retreat'
    end
  end

  def self.get_skill_ap(skill_id)
    if skill_id == 0
      4
    elsif skill_id == 1
      6
    elsif skill_id == 2
      0
    end
  end

  def self.get_skill_targeting(skill_id)
    if skill_id == 0
      MELEE
    elsif skill_id == 1
      RANGED
    elsif skill_id == 2
      SELF
    end
  end
end

