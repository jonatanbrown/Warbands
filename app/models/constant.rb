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
      ["#{get_skill_name(10)}", 10, get_skill_ap(10), get_skill_targeting(10)],
      ["#{get_skill_name(11)}", 11, get_skill_ap(11), get_skill_targeting(11)],
      ["#{get_skill_name(12)}", 12, get_skill_ap(12), get_skill_targeting(12)],
      ["#{get_skill_name(13)}", 13, get_skill_ap(13), get_skill_targeting(13)],
      ["#{get_skill_name(14)}", 14, get_skill_ap(14), get_skill_targeting(14)],
      ["#{get_skill_name(15)}", 15, get_skill_ap(15), get_skill_targeting(15)],
      ["#{get_skill_name(16)}", 16, get_skill_ap(16), get_skill_targeting(16)],
      ["#{get_skill_name(17)}", 17, get_skill_ap(17), get_skill_targeting(17)],
      ["#{get_skill_name(18)}", 18, get_skill_ap(18), get_skill_targeting(18)],
      ["#{get_skill_name(19)}", 19, get_skill_ap(19), get_skill_targeting(19)],
      ["#{get_skill_name(20)}", 20, get_skill_ap(20), get_skill_targeting(20)],
      ["#{get_skill_name(21)}", 21, get_skill_ap(21), get_skill_targeting(21)]
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
    elsif skill_id == SKILL_SHIELD_WALL
      'Shield Wall'
    elsif skill_id == SKILL_COUNTERSTRIKE
      'Counterstrike'
    elsif skill_id == SKILL_FLING
      'Fling'
    elsif skill_id == SKILL_QUICK_THROW
      'Quick Throw'
    elsif skill_id == SKILL_HEAVY_THROW
      'Heavy Throw'
    elsif skill_id == SKILL_TAKE_AIM
      'Take Aim'
    elsif skill_id == SKILL_UNDISTURBED
      'Undisturbed'
    elsif skill_id == SKILL_BOLA
      'Bola'
    elsif skill_id == SKILL_MIND_POISON
      'Mind Numbing Poison'
    elsif skill_id == SKILL_PARALYZING_POISON
      'Paralyzing Poison'
    elsif skill_id == SKILL_WEAKNESS_POISON
      'Weakness Poison'
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
    elsif skill_id == SKILL_SHIELD_WALL
      5
    elsif skill_id == SKILL_COUNTERSTRIKE
      0
    elsif skill_id == SKILL_FLING
      4
    elsif skill_id == SKILL_QUICK_THROW
      6
    elsif skill_id == SKILL_HEAVY_THROW
      6
    elsif skill_id == SKILL_TAKE_AIM
      0
    elsif skill_id == SKILL_UNDISTURBED
      0
    elsif skill_id == SKILL_BOLA
      6
    elsif skill_id == SKILL_MIND_POISON
      5
    elsif skill_id == SKILL_PARALYZING_POISON
      5
    elsif skill_id == SKILL_WEAKNESS_POISON
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
    elsif skill_id == SKILL_SHIELD_WALL
      SELF
    elsif skill_id == SKILL_COUNTERSTRIKE
      SELF
    elsif skill_id == SKILL_FLING
      RANDOM_ENEMY
    elsif skill_id == SKILL_QUICK_THROW
      RANGED
    elsif skill_id == SKILL_HEAVY_THROW
      RANGED
    elsif skill_id == SKILL_TAKE_AIM
      SELF
    elsif skill_id == SKILL_UNDISTURBED
      SELF
    elsif skill_id == SKILL_BOLA
      RANGED
    elsif skill_id == SKILL_MIND_POISON
      SELF
    elsif skill_id == SKILL_PARALYZING_POISON
      SELF
    elsif skill_id == SKILL_WEAKNESS_POISON
      SELF
    end
  end

  def self.get_skill_text(skill_id)
    case skill_id
      when SKILL_STRIKE
        'strikes'
      when SKILL_THROWN
        'throws a stone at'
      when SKILL_RETREAT
        ''
      when SKILL_DIRT
        'throws dirt at'
      when SKILL_DEFENSIVE_POSTURE
        ''
      when SKILL_COVER
        ''
      when SKILL_QUICK_STRIKE
        'quickly strikes'
      when SKILL_HEAVY_STRIKE
        'heavily strikes'
      when SKILL_ACCURATE_STRIKE
        'accurately strikes'
      when SKILL_FINISHING_STRIKE
        'does a finishing strike at'
      when SKILL_PROTECT
        ''
      when SKILL_SHIELD_WALL
        ''
      when SKILL_COUNTERSTRIKE
        ''
      when SKILL_FLING
        'flings a stone at'
      when SKILL_QUICK_THROW
        'quickly throws a stone at'
      when SKILL_HEAVY_THROW
        'throws a stone heavily at'
      when SKILL_TAKE_AIM
        ''
      when SKILL_UNDISTURBED
        ''
      when SKILL_BOLA
        'throws a bola at'
      when SKILL_MIND_POISON
        ''
      when SKILL_PARALYZING_POISON
        ''
      when SKILL_WEAKNESS_POISON
        ''
    end
  end

  def self.get_effect_name(effect_id)
    case effect_id
      when EFFECT_BLINDED
        'Blinded'
      when EFFECT_UNDISTURBED
        'Undisturbed'
      when EFFECT_MIND_POISON
        'Unfocused'
      when EFFECT_PARALYZING_POISON
        'Paralyzed'
      when EFFECT_WEAKNESS_POISON
        'Weakened'
      when EFFECT_APPLIED_MIND_POISON
        'Mind Numbing Attacks'
      when EFFECT_APPLIED_PARALYZING_POISON
        'Paralyzing Attacks'
      when EFFECT_APPLIED_WEAKNESS_POISON
        'Weakness Attacks'
      when EFFECT_BLEEDING
        'Bleeding'
    end
  end

  def self.effect_beneficial?(effect_id)
    case effect_id
      when EFFECT_BLINDED
        false
      when EFFECT_MIND_POISON
        false
      when EFECT_PARALYZING_POISON
        false
      when EFFECT_WEAKNESS_POISON
        false
      when EFFECT_BLEEDING
        false
      when EFFECT_APPLIED_MIND_POISON
        true
      when EFFECT_APPLIED_PARALYZING_POISON
        true
      when EFFECT_APPLIED_WEAKNESS_POISON
        true
      else
        true
    end
  end

  def self.weapon_based_attack?(skill_id)
    [SKILL_STRIKE, SKILL_THROWN, SKILL_QUICK_STRIKE, SKILL_HEAVY_STRIKE, SKILL_ACCURATE_STRIKE, SKILL_FINISHING_STRIKE, SKILL_FLING, SKILL_QUICK_THROW, SKILL_HEAVY_THROW].include?(skill_id)
  end

  def self.get_effect_color_tag(effect_id)
    case effect_id
      when EFFECT_BLINDED
        "<span class='red'>"
      when EFFECT_MIND_POISON
        "<span class='red'>"
      when EFFECT_PARALYZING_POISON
        "<span class='red'>"
      when EFFECT_WEAKNESS_POISON
        "<span class='red'>"
      when EFFECT_BLEEDING
        "<span class='red'>"
      when EFFECT_UNDISTURBED
        "<span class='green'>"
      when EFFECT_APPLIED_MIND_POISON
        "<span class='green'>"
      when EFFECT_APPLIED_PARALYZING_POISON
        "<span class='green'>"
      when EFFECT_APPLIED_WEAKNESS_POISON
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

