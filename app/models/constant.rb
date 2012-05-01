class Constant

  def self.skills
    [
      ["#{get_skill_name(1)}", 1, get_skill_ap(1)],
      ["#{get_skill_name(2)}", 2, get_skill_ap(2)]
    ].to_s
  end

  def self.get_skill_ap(skill_id)
    if skill_id == 1
      4
    elsif skill_id == 2
      6
    end
  end

  def self.get_skill_name(skill_id)
    if skill_id == 1
      'Strike'
    elsif skill_id == 2
      'Throw'
    end
  end

end

