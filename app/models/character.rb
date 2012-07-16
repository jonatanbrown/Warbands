class Character
  include Mongoid::Document
  belongs_to :team

  field :name, :type => String

  #Stats
  field :str, :type => Integer
  field :dex, :type => Integer
  field :tgh, :type => Integer
  field :ini, :type => Integer
  field :int, :type => Integer
  field :mem, :type => Integer

  field :ap, :type => Integer

  field :hp, :type => Integer, :default => 30

  #Skills

  #Melee Combat

    #Basic
      field :strike, :type => Integer
      field :defensive_posture, :type => Integer

    #Learnable
      field :quick_strike, :type => Integer
      field :heavy_strike, :type => Integer
      field :accurate_strike, :type => Integer
      field :finishing_strike, :type => Integer
      field :protect, :type => Integer
      field :shield_wall, :type => Integer
      field :counterstrike, :type => Integer

  #Ranged

    #Basic
      field :thrown, :type => Integer
      field :cover, :type => Integer

    #Learnable
      field :fling, :type => Integer
      field :quick_throw, :type => Integer
      field :heavy_throw, :type => Integer
      field :take_aim, :type => Integer
      field :undisturbed, :type => Integer

  #Dirty Combat

    #Basic
      field :dirt, :type => Integer

    #Learnable
      field :bola, :type => Integer
      field :mind_poison, :type => Integer
      field :paralyzing_poison, :type => Integer
      field :weakness_poison, :type => Integer

  #Magic

  #Combat info
  field :current_hp, :type => Integer
  field :taken_damage, :type => Boolean
  field :active, :type => Boolean, :default => 1

  field :position, :type => Integer

  #Tuples in effects are in format [effect_id, duration, power, character_id]
  field :effects, :type => Array, :default => []


  def roll_char
    self.roll_stats
    self.roll_skills
  end

  def roll_stats
    self.str = roll_stat
    self.dex = roll_stat
    self.tgh = roll_stat
    self.ini = roll_stat
    self.int = roll_stat
    self.mem = roll_stat

    self.ap = roll_ap
  end

  def roll_skills
    self.strike = roll_skill
    self.defensive_posture = roll_skill
    self.thrown = roll_skill
    self.cover = roll_skill
    self.dirt = roll_skill
  end

  def get_priority(action_index, skill_id)
    result = self.final_ini - (action_index * 4) + rand(1..5)
    if skill_id == SKILL_QUICK_STRIKE
      result = (result * 1.2).round(0)
    elsif skill_id == SKILL_HEAVY_STRIKE
      result = (result * 0.8).round(0)
    elsif skill_id == SKILL_QUICK_THROW
      result = (result * 1.2).round(0)
    elsif skill_id == SKILL_HEAVY_THROW
      result = (result * 0.8).round(0)
    end
    result
  end

  def is_active?
    current_hp > 0
  end

  def skill_available?(skill_nr)
    #Should check if the character has learned the skill etc, now only checks if skill is a valid skill number at all.
    ((0..MAX_SKILL_NUM) === skill_nr.to_i and get_skill_value(skill_nr) != nil)
  end

  #Functions for returning stats after current effects

  def final_str
    str
  end

  def final_dex
    result = dex
    if (effects.map {|x| x[0] }).include?(EFFECT_BLINDED)
      result = result * 0.5
    end
    result.round(0)
  end

  def final_tgh
    tgh
  end

  def final_ini
    result = ini
    if (effects.map {|x| x[0] }).include?(EFFECT_BLINDED)
      result = result * 0.5
    end
    result.round(0)
  end

  def final_ap
    result = ap
    if (effects.map {|x| x[0] }).include?(EFFECT_UNDISTURBED)
      result = result * (1.3 + undisturbed/100)
    end
    result.round(0)
  end

  def get_effects_text
    unique_effect_hash = {}
    effects.each do |effect|
      if !unique_effect_hash.has_key?(effect[0])
        unique_effect_hash[effect[0]] = effect
      else
        if unique_effect_hash[effect[0]][1] < effect[1]
          unique_effect_hash[effect[0]] = effect
        end
      end
    end

    result = ''
    unique_effect_hash.each_pair do |effect_id, effect|
      result += "<p>" + Constant.get_effect_color_tag(effect_id) + Constant.get_effect_name(effect_id) + "</span>" +" - " + effect[1].to_s + " turns</p>"
    end
    result
  end

  def get_stats_text
    result = ''

    if final_str < str
      result += "<p><span class='red'>Strength: " + final_str.to_s + "</span> (" + str.to_s + ")</p>"
    elsif final_str > str
      result += "<p><span class='green'>Strength: " + final_str.to_s + "</span> (" + str
    else
      result += "<p>Strength: " + final_str.to_s + "</p>"
    end

    if final_dex < dex
      result += "<p><span class='red'>Dexterity: " + final_dex.to_s + "</span> (" + dex.to_s + ")</p>"
    elsif final_dex > dex
      result += "<p><span class='green'>Dexterity: " + final_dex.to_s + "</span> (" + dex.to_s + ")</p>"
    else
      result += "<p>Dexterity: " + final_dex.to_s + "</p>"
    end

    if final_tgh < tgh
      result += "<p><span class='red'>Toughness: " + final_tgh.to_s + "</span> (" + tgh.to_s + ")</p>"
    elsif final_tgh > tgh
      result += "<p><span class='green'>Toughness: " + final_tgh.to_s + "</span> (" + tgh.to_s + ")</p>"
    else
      result += "<p>Toughness: " + final_tgh.to_s + "</p>"
    end

    if final_ini < ini
      result += "<p><span class='red'>Initiative: " + final_ini.to_s + "</span> (" + ini.to_s + ")</p>"
    elsif final_ini > ini
      result += "<p><span class='green'>Initiative: " + final_ini.to_s + "</span> (" + ini.to_s + ")</p>"
    else
      result += "<p>Initiative: " + final_ini.to_s + "</p>"
    end

    result += "</br>"
    if final_ap < ap
      result += "<p><span class='red'>AP: " + final_ap.to_s + "</span> (" + ap.to_s + ")</p>"
    elsif final_ap > ap
      result += "<p><span class='green'>AP: " + final_ap.to_s + "</span> (" + ap.to_s + ")</p>"
    else
      result += "<p>Initiative: " + final_ap.to_s + "</p>"
    end
    result += "<p>HP:" + current_hp.to_s + "</p>"

  end

  def get_cryptic_stats_text
    result = ''
    result += "<p>Strength: " + Constant.get_cryptic_str(final_str) + "</p>"
    result += "<p>Dexterity: " + Constant.get_cryptic_dex(final_dex) + "</p>"
    result += "<p>Toughness: " + Constant.get_cryptic_tgh(final_tgh) + "</p>"
    result += "<p>Initiative: " + Constant.get_cryptic_ini(final_ini) + "</p>"
    result += "</br>"
    result += "<p>HP:" + current_hp.to_s + "</p>"

  end


  def get_skills_text
    result = ''

    result += "<p>Strike: #{strike}</p>"
    result += "<p>Defensive Posture: #{defensive_posture}</p>"
    result += "<p>Throw: #{thrown}</p>"
    result += "<p>Take Cover: #{cover}</p>"
    result += "<p>Throw Dirt: #{dirt}</p>"
  end

  #Returns skill level in order of ID. Passives should be 0.
  def get_skills_array
    [strike, thrown, 1, dirt, defensive_posture, cover, quick_strike, heavy_strike, accurate_strike, finishing_strike, protect, shield_wall, 0, fling, quick_throw, heavy_throw, 0, 0, bola].map {|num| num == nil ? 0 : num}
  end

  def get_skill_value(skill_id)
    if skill_id == SKILL_STRIKE
      strike
    elsif skill_id == SKILL_THROWN
      thrown
    elsif skill_id == SKILL_RETREAT
      1
    elsif skill_id == SKILL_DIRT
      dirt
    elsif skill_id == SKILL_DEFENSIVE_POSTURE
      defensive_posture
    elsif skill_id == SKILL_COVER
      cover
    elsif skill_id == SKILL_QUICK_STRIKE
      quick_strike
    elsif skill_id == SKILL_HEAVY_STRIKE
      heavy_strike
    elsif skill_id == SKILL_ACCURATE_STRIKE
      accurate_strike
    elsif skill_id == SKILL_FINISHING_STRIKE
      finishing_strike
    elsif skill_id == SKILL_PROTECT
      protect
    elsif skill_id == SKILL_SHIELD_WALL
      shield_wall
    elsif skill_id == SKILL_COUNTERSTRIKE
      counterstrike
    elsif skill_id == SKILL_FLING
      fling
    elsif skill_id == SKILL_QUICK_THROW
      quick_throw
    elsif skill_id == SKILL_HEAVY_THROW
      heavy_throw
    elsif skill_id == SKILL_TAKE_AIM
      take_aim
    elsif skill_id == SKILL_UNDISTURBED
      undisturbed
     elsif skill_id == SKILL_BOLA
      bola
    end
  end

  def melee_dodge?
    rand(1..100) <= (100*final_dex)/(100+final_dex)
  end

  def defensive_posture_dodge?
    (effects.map {|x| x[0] }).include?(EFFECT_DEFENSIVE_POSTURE) and rand(1..10) <= 3
  end

  def is_protected?
    effects.each do |effect|
      if effect[0] == EFFECT_PROTECTED and rand(1..10) <= 7
        return Character.find(effect[3])
      end
    end
    return false
  end

  def aim_success?
    effects.each do |effect|
      if effect[0] == EFFECT_TAKEN_AIM and skill_roll_successful?(SKILL_TAKE_AIM)
        return Character.find(effect[3])._id
      end
    end
    return false
  end

  def behind_shield_wall?
    if team.formation == 2 and position == 5

      waller = team.get_char(1)
      if waller and (waller.effects.map {|x| x[0] }).include?(EFFECT_SHIELD_WALL) and waller.skill_roll_successful?(SKILL_SHIELD_WALL)
        return waller.name
      end

      waller = team.get_char(2)
      if waller and (waller.effects.map {|x| x[0] }).include?(EFFECT_SHIELD_WALL) and waller.skill_roll_successful?(SKILL_SHIELD_WALL)
        return waller.name
      end

    elsif team.formation == 3

      if position == 3

        waller = team.get_char(0)
        if waller and (waller.effects.map {|x| x[0] }).include?(EFFECT_SHIELD_WALL) and waller.skill_roll_successful?(SKILL_SHIELD_WALL)
          return waller.name
        end

        waller = team.get_char(1)
        if waller and (waller.effects.map {|x| x[0] }).include?(EFFECT_SHIELD_WALL) and waller.skill_roll_successful?(SKILL_SHIELD_WALL)
          return waller.name
        end

      elsif position == 4

        waller = team.get_char(1)
        if waller and (waller.effects.map {|x| x[0] }).include?(EFFECT_SHIELD_WALL) and waller.skill_roll_successful?(SKILL_SHIELD_WALL)
          return waller.name
        end

        waller = team.get_char(2)
        if waller and (waller.effects.map {|x| x[0] }).include?(EFFECT_SHIELD_WALL) and waller.skill_roll_successful?(SKILL_SHIELD_WALL)
          return waller.name
        end

      end
    elsif team.formation == 4
      if position == 2

        waller = team.get_char(0)
        if waller and (waller.effects.map {|x| x[0] }).include?(EFFECT_SHIELD_WALL) and waller.skill_roll_successful?(SKILL_SHIELD_WALL)
          return waller.name
        end

      elsif position == 3

        waller = team.get_char(0)
        if waller and (waller.effects.map {|x| x[0] }).include?(EFFECT_SHIELD_WALL) and waller.skill_roll_successful?(SKILL_SHIELD_WALL)
          return waller.name
        end

        waller = team.get_char(1)
        if waller and (waller.effects.map {|x| x[0] }).include?(EFFECT_SHIELD_WALL) and waller.skill_roll_successful?(SKILL_SHIELD_WALL)
          return waller.name
        end

      elsif position == 4
        waller = team.get_char(1)
        if waller and (waller.effects.map {|x| x[0] }).include?(EFFECT_SHIELD_WALL) and waller.skill_roll_successful?(SKILL_SHIELD_WALL)
          return waller.name
        end
      end
    end
    false
  end

  def counterstrike_damage(target)
    if counterstrike and skill_roll_successful?(SKILL_COUNTERSTRIKE)
      damage = (rand(4..8) + ((final_str + counterstrike)/2.0)).round(0)
      damage -= (target.final_tgh/2.0).round(0)
      if damage < 0
        damage = 0
      end
      return damage
    end
    false
  end

  def ranged_hit?(skill_id)
    rand(1..100) <= (100*(final_dex + get_skill_value(skill_id)))/(5+(final_dex + get_skill_value(skill_id)))
  end

  def skill_roll_successful?(skill_id)
    rand(1..100) <= (100*get_skill_value(skill_id))/(5+get_skill_value(skill_id))
  end

  def check_knockout
    self.active = is_active?
    self.save
    if !active
      "<p>#{name} has been knocked out!</p>"
    else
      ''
    end
  end

  private

  def roll_stat
    result = 0

    3.times do
      result += rand(1..20)
    end

    result / 3
  end

  def roll_ap
    8 + rand(1..4)
  end

  def roll_skill
    #Returning 1..10 for now, will fix later.
    rand(1..10)
  end

end

