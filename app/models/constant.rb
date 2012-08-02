class Constant

  #Do not forget to change MAX_SKILL_NUM in initializer constants when adding skills

  def self.skills
    [
      ["#{get_skill_name(0)}", 0, get_skill_ap(0), get_skill_targeting(0), get_skill_icon(0), get_skill_description(0)],
      ["#{get_skill_name(1)}", 1, get_skill_ap(1), get_skill_targeting(1), get_skill_icon(1), get_skill_description(1)],
      ["#{get_skill_name(2)}", 2, get_skill_ap(2), get_skill_targeting(2), get_skill_icon(2), get_skill_description(2)],
      ["#{get_skill_name(3)}", 3, get_skill_ap(3), get_skill_targeting(3), get_skill_icon(3), get_skill_description(3)],
      ["#{get_skill_name(4)}", 4, get_skill_ap(4), get_skill_targeting(4), get_skill_icon(4), get_skill_description(4)],
      ["#{get_skill_name(5)}", 5, get_skill_ap(5), get_skill_targeting(5), get_skill_icon(5), get_skill_description(5)],
      ["#{get_skill_name(6)}", 6, get_skill_ap(6), get_skill_targeting(6), get_skill_icon(6), get_skill_description(6)],
      ["#{get_skill_name(7)}", 7, get_skill_ap(7), get_skill_targeting(7), get_skill_icon(7), get_skill_description(7)],
      ["#{get_skill_name(8)}", 8, get_skill_ap(8), get_skill_targeting(8), get_skill_icon(8), get_skill_description(8)],
      ["#{get_skill_name(9)}", 9, get_skill_ap(9), get_skill_targeting(9), get_skill_icon(9), get_skill_description(9)],
      ["#{get_skill_name(10)}", 10, get_skill_ap(10), get_skill_targeting(10), get_skill_icon(10), get_skill_description(10)],
      ["#{get_skill_name(11)}", 11, get_skill_ap(11), get_skill_targeting(11), get_skill_icon(11), get_skill_description(11)],
      ["#{get_skill_name(12)}", 12, get_skill_ap(12), get_skill_targeting(12), get_skill_icon(12), get_skill_description(12)],
      ["#{get_skill_name(13)}", 13, get_skill_ap(13), get_skill_targeting(13), get_skill_icon(13), get_skill_description(13)],
      ["#{get_skill_name(14)}", 14, get_skill_ap(14), get_skill_targeting(14), get_skill_icon(14), get_skill_description(14)],
      ["#{get_skill_name(15)}", 15, get_skill_ap(15), get_skill_targeting(15), get_skill_icon(15), get_skill_description(15)],
      ["#{get_skill_name(16)}", 16, get_skill_ap(16), get_skill_targeting(16), get_skill_icon(16), get_skill_description(16)],
      ["#{get_skill_name(17)}", 17, get_skill_ap(17), get_skill_targeting(17), get_skill_icon(17), get_skill_description(17)],
      ["#{get_skill_name(18)}", 18, get_skill_ap(18), get_skill_targeting(18), get_skill_icon(18), get_skill_description(18)],
      ["#{get_skill_name(19)}", 19, get_skill_ap(19), get_skill_targeting(19), get_skill_icon(19), get_skill_description(19)],
      ["#{get_skill_name(20)}", 20, get_skill_ap(20), get_skill_targeting(20), get_skill_icon(20), get_skill_description(20)],
      ["#{get_skill_name(21)}", 21, get_skill_ap(21), get_skill_targeting(21), get_skill_icon(21), get_skill_description(21)]
    ].to_s
  end

  def self.get_skill_name(skill_id)
    if skill_id == DISCIPLINE_MELEE_COMBAT
      'Melee Combat'
    elsif skill_id == DISCIPLINE_RANGED_COMBAT
      'Ranged Combat'
    elsif skill_id == DISCIPLINE_DIRTY_COMBAT
      'Dirty Combat'
    elsif skill_id == SKILL_STRIKE
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
      4
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

  def self.get_skill_icon(skill_id)
    case skill_id
      when SKILL_STRIKE
        'icon_strike.png'
      when SKILL_THROWN
        'icon_thrown.png'
      when SKILL_RETREAT
        'icon_retreat.png'
      when SKILL_DIRT
        'icon_dirt.png'
      when SKILL_DEFENSIVE_POSTURE
        'icon_defensive_posture.png'
      when SKILL_COVER
        'icon_cover.png'
      when SKILL_QUICK_STRIKE
        'icon_quick_strike.png'
      when SKILL_HEAVY_STRIKE
        'icon_heavy_strike.png'
      when SKILL_ACCURATE_STRIKE
        'icon_accurate_strike.png'
      when SKILL_FINISHING_STRIKE
        'icon_finishing_strike.png'
      when SKILL_PROTECT
        'icon_protect.png'
      when SKILL_SHIELD_WALL
        'icon_shield_wall.png'
      when SKILL_COUNTERSTRIKE
        'icon_counterstrike.png'
      when SKILL_FLING
        'icon_fling.png'
      when SKILL_QUICK_THROW
        'icon_quick_throw'
      when SKILL_HEAVY_THROW
        'icon_heavy_throw.png'
      when SKILL_TAKE_AIM
        'icon_take_aim.png'
      when SKILL_UNDISTURBED
        'icon_undisturbed.png'
      when SKILL_BOLA
        'icon_bola.png'
      when SKILL_MIND_POISON
        'icon_mind_poison.png'
      when SKILL_PARALYZING_POISON
        'icon_paralyzing_poison.png'
      when SKILL_WEAKNESS_POISON
        'icon_weakness_poison.png'
    end
  end

  def self.get_skill_description(skill_id)
    case skill_id
      when SKILL_STRIKE
        'Standard melee attack.'
      when SKILL_THROWN
        'Standard ranged attack.'
      when SKILL_RETREAT
        ''
      when SKILL_DIRT
        'Blind the opponent by throwing dirt into their eyes. Reduced Dex and Ini of the target.'
      when SKILL_DEFENSIVE_POSTURE
        'Assume a defensive posture giving you an increased chance to dodge incoming melee attacks.'
      when SKILL_COVER
        'Greatly increased chance of avoiding ranged attacks by hiding behind characters in front.'
      when SKILL_QUICK_STRIKE
        'An attack with increased initiative but reduced damage.'
      when SKILL_HEAVY_STRIKE
        'An attack with increased damage but reduced initiative.'
      when SKILL_ACCURATE_STRIKE
        'An attack that always hits the opponent'
      when SKILL_FINISHING_STRIKE
        'A costly attack with greatly increased damage.'
      when SKILL_PROTECT
        'Attempt to protect another character by deflecting attacks onto oneself instead.'
      when SKILL_SHIELD_WALL
        'Protects self and characters behind from ranged attacks.'
      when SKILL_COUNTERSTRIKE
        'After successfuly avoiding a melee attack gives a chance to strike back at the attacker.'
      when SKILL_FLING
        'A ranged attack that hits a random enemy target.'
      when SKILL_QUICK_THROW
        'A ranged attack with increased initiative but reduced damage.'
      when SKILL_HEAVY_THROW
        'A ranged attack with increased damage but reduced initiative.'
      when SKILL_TAKE_AIM
        'When attacking the same target more than once in the same round, gives an increased chance to hit on each attack after the first.'
      when SKILL_UNDISTURBED
        'If the character takes no damage during round, gives a chance to increase AP for the next round.'
      when SKILL_BOLA
        'A ranged attack that aims to stun the opponent causing them to miss their next action.'
      when SKILL_MIND_POISON
        'Coats ones weapon with poison that can cause enemies who take damage from it to suffer reduced Int and Mem.'
      when SKILL_PARALYZING_POISON
        'Coats ones weapon with poison that can cause enemies who take damage from it to suffer reduced AP.'
      when SKILL_WEAKNESS_POISON
        'Coats ones weapon with poison that can cause enemies who take damage from it to suffer reduced Str and Tgh.'
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
      when EFFECT_TAKEN_AIM
        'THIS SHOULD NOT BE HERE'
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
      when EFFECT_TAKEN_AIM
        false
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
      when EFFECT_TAKEN_AIM
        "<span class='red'>"
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

  def self.get_cryptic_armor(armor)
    if armor == 0
      'Unarmored'
    elsif armor < 5
      'Hardly Armored'
    elsif armor < 10
      'Slightly Armored'
    elsif armor < 15
      'Armored'
    elsif armor < 20
      'Well Armored'
    elsif armor < 25
      'Heavily Armored'
    elsif armor < 30
      'Like a Tank'
    else
      'Invulnerable'
    end
  end

  def self.get_discipline(skill_id)
    case skill_id
      when SKILL_STRIKE
        DISCIPLINE_MELEE_COMBAT

      when SKILL_THROWN
        DISCIPLINE_RANGED_COMBAT

      when SKILL_RETREAT
        DISCIPLINE_NONE

      when SKILL_DIRT
        DISCIPLINE_DIRTY_COMBAT

      when SKILL_DEFENSIVE_POSTURE
        DISCIPLINE_MELEE_COMBAT

      when SKILL_COVER
        DISCIPLINE_RANGED_COMBAT

      when SKILL_QUICK_STRIKE
        DISCIPLINE_MELEE_COMBAT

      when SKILL_HEAVY_STRIKE
        DISCIPLINE_MELEE_COMBAT

      when SKILL_ACCURATE_STRIKE
        DISCIPLINE_MELEE_COMBAT

      when SKILL_FINISHING_STRIKE
        DISCIPLINE_MELEE_COMBAT

      when SKILL_PROTECT
        DISCIPLINE_MELEE_COMBAT

      when SKILL_SHIELD_WALL
        DISCIPLINE_MELEE_COMBAT

      when SKILL_COUNTERSTRIKE
        DISCIPLINE_MELEE_COMBAT

      when SKILL_FLING
        DISCIPLINE_RANGED_COMBAT

      when SKILL_QUICK_THROW
        DISCIPLINE_RANGED_COMBAT

      when SKILL_HEAVY_THROW
        DISCIPLINE_RANGED_COMBAT

      when SKILL_TAKE_AIM
        DISCIPLINE_RANGED_COMBAT

      when SKILL_UNDISTURBED
        DISCIPLINE_RANGED_COMBAT

      when SKILL_BOLA
        DISCIPLINE_DIRTY_COMBAT

      when SKILL_MIND_POISON
        DISCIPLINE_DIRTY_COMBAT

      when SKILL_PARALYZING_POISON
        DISCIPLINE_DIRTY_COMBAT

      when SKILL_WEAKNESS_POISON
        DISCIPLINE_DIRTY_COMBAT
    end
  end
end

