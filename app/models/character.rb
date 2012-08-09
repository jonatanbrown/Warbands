class Character
  include Mongoid::Document
  belongs_to :team

  has_many :equipments

  field :name, :type => String

  field :position, :type => Integer

  #Stats
  field :str, :type => Integer
  field :dex, :type => Integer
  field :tgh, :type => Integer
  field :ini, :type => Integer
  field :int, :type => Integer
  field :mem, :type => Integer

  field :ap, :type => Integer

  field :hp, :type => Integer, :default => 40


  #Disciplines

      field :melee_combat_points, :type => Integer, :default => 0
      field :ranged_combat_points, :type => Integer, :default => 0
      field :dirty_combat_points, :type => Integer, :default => 0

      field :melee_combat, :type => Integer, :default => 0
      field :ranged_combat, :type => Integer, :default => 0
      field :dirty_combat, :type => Integer, :default => 0

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
      field :run_up, :type => Integer

    #Learnable
      field :fling, :type => Integer
      field :cover, :type => Integer
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

  field :learnings, :type => Array, :default => []

  #Tuples in effects are in format [effect_id, duration, power, character_id]
  field :effects, :type => Array, :default => []


  def roll_char
    self.equipments = []
    self.roll_stats
    self.roll_skills
    self.create_basic_gear
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
    self.run_up = roll_skill
    self.dirt = roll_skill
  end

  def create_basic_gear
    if str > dex
      eq = Equipment.create_item('wooden_stick', team)
      equipments << eq
    else
      eq =Equipment.create_item('rusty_cutlery', team)
      equipments << eq
    end
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

    if Constant.weapon_based_attack?(skill_id) and weapon = equipped_weapon and weapon.eq_type == EQUIPMENT_SPEAR
      result = (result * 1.1).round(0)
    elsif Constant.weapon_based_attack?(skill_id) and weapon = equipped_weapon and weapon.eq_type == EQUIPMENT_THROWING_KNIVES
      result = (result * 1.1).round(0)
    end
    result
  end

  def is_active?
    current_hp > 0
  end

  def skill_available?(skill_nr)
    #Should check if the character has learned the skill etc, now only checks if skill is a valid skill number at all.
    ((0..MAX_SKILL_NUM) === skill_nr.to_i and get_final_skill_value(skill_nr) != nil)
  end

  #Functions for returning stats after current effects

  def final_str
    result = str
    if (effects.map {|x| x[0] }).include?(EFFECT_WEAKNESS_POISON)
      result = result * 0.5
    end
    if result < 0
      result = 0
    end
    result.round(0)
  end

  def final_dex
    result = dex
    if (effects.map {|x| x[0] }).include?(EFFECT_BLINDED)
      result = result * 0.5
    end
    result -= (weight_penalty/2.0).round(0)
    if result < 0
      result = 0
    end
    result.round(0)
  end

  def final_tgh
    result = tgh
    if (effects.map {|x| x[0] }).include?(EFFECT_WEAKNESS_POISON)
      result = result * 0.5
    end
    if result < 0
      result = 0
    end
    result.round(0)
  end

  def final_ini
    result = ini
    if (effects.map {|x| x[0] }).include?(EFFECT_BLINDED)
      result = result * 0.5
    end
    if result < 0
      result = 0
    end
    result.round(0)
  end

  def get_final_int
    result = int
    if (effects.map {|x| x[0] }).include?(EFFECT_MIND_POISON)
      result = result * 0.5
    end
    if result < 0
      result = 0
    end
    result.round(0)
  end

  def get_final_mem
    result = mem
    if (effects.map {|x| x[0] }).include?(EFFECT_MIND_POISON)
      result = result * 0.5
    end
    if result < 0
      result = 0
    end
    result.round(0)
  end

  def final_ap
    result = ap
    if (effects.map {|x| x[0] }).include?(EFFECT_UNDISTURBED)
      result = result * (1.3 + undisturbed/100)
    end
    if (effects.map {|x| x[0] }).include?(EFFECT_PARALYZING_POISON)
      result = result * 0.8
    end
    result -= (weight_penalty/2.0).round(0)
    if result < 0
      result = 0
    end
    result.round(0)
  end

  def armor
    result = 0
    equipments.each do |item|
      if item.armor
        result += item.armor
      end
    end
    if result < 0
      result = 0
    end
    result
  end

  def str_req
    result = 0
    equipments.each do |item|
      if item.str_req
        result += item.str_req
      end
    end
    result
  end

  def weight_penalty
    if (diff = str_req - final_str) > 0
      return diff
    end
    0
  end

  def get_effects_text
    unique_effect_hash = {}
    stack_hash = {}
    effects.each do |effect|
      if !unique_effect_hash.has_key?(effect[0])
        unique_effect_hash[effect[0]] = effect
      else
        if unique_effect_hash[effect[0]][1] < effect[1]
          unique_effect_hash[effect[0]] = effect
        end
        if stack_hash.has_key?("#{effect[0]}-stack")
          stack_hash["#{effect[0]}-stack"] += 1
        else
          stack_hash["#{effect[0]}-stack"] = 2
        end
      end
    end

    result = ''
    unique_effect_hash.each_pair do |effect_id, effect|
      stack = ''
      if stack_hash.has_key?("#{effect[0]}-stack")
        stack = '(' + stack_hash["#{effect[0]}-stack"].to_s + ') '
      end
      result += "<p>" + Constant.get_effect_color_tag(effect_id) + stack + Constant.get_effect_name(effect_id) + "</span>" +" - " + effect[1].to_s + " turns</p>"
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
      result += "<p>AP: " + final_ap.to_s + "</p>"
    end
    result += "<p>HP: " + current_hp.to_s + "</p>"
    result += "<p>Armor: " + armor.to_s + "</p>"

  end

  def get_cryptic_stats_text
    result = ''
    result += "<p>Strength: " + Constant.get_cryptic_str(final_str) + "</p>"
    result += "<p>Dexterity: " + Constant.get_cryptic_dex(final_dex) + "</p>"
    result += "<p>Toughness: " + Constant.get_cryptic_tgh(final_tgh) + "</p>"
    result += "<p>Initiative: " + Constant.get_cryptic_ini(final_ini) + "</p>"
    result += "</br>"
    result += "<p>HP: " + current_hp.to_s + "</p>"
    result += "<p>Armor: " + Constant.get_cryptic_armor(armor) + "</p>"
  end


  def get_skills_text
    result = ''
    get_skills_array.each_with_index do |skill_level, index|
      if skill_level != 0
        result += "<p>#{Constant.get_skill_name(index)}: #{get_skill_value(index)}</p>"
      end
    end
    result
  end

  def get_gear_text
    result = ''
    if (weapon = equipped_weapon)
      result += "<p>Weapon: #{weapon.name}</p>"
    end
    if (shield = equipped_shield)
      result += "<p>Shield: #{shield.name}</p>"
    end
    if (head = equipped_head)
      result += "<p>Helm: #{head.name}</p>"
    end
    if (chest = equipped_chest)
      result += "<p>Chest Armor: #{chest.name}</p>"
    end
    if (legs = equipped_legs)
      result += "<p>Leg Armor: #{legs.name}</p>"
    end
    result
  end

  #Returns skill level in order of ID. Passives should be 0.
  def get_final_skills_array
    result = []
    (0..MAX_SKILL_NUM).each do |skill_num|
      result << get_final_skill_value(skill_num)
    end
    result.map {|num| num == nil ? 0 : num}
  end

  def get_skills_array
    result = []
    (0..MAX_SKILL_NUM).each do |skill_num|
      result << get_skill_value(skill_num)
    end
    result.map {|num| num == nil ? 0 : num}
  end

  def get_final_skill_value(skill_id)
    case skill_id
    when SKILL_STRIKE
      if (weapon = equipped_weapon) and weapon.melee?
        return strike
      end
    when SKILL_THROWN
      if (weapon = equipped_weapon) and weapon.ranged?
        return thrown
      end
    when SKILL_RETREAT
      return 0
    when SKILL_DIRT
      return dirt
    when SKILL_DEFENSIVE_POSTURE
      return defensive_posture
    when SKILL_COVER
      return cover
    when SKILL_QUICK_STRIKE
      if (weapon = equipped_weapon) and weapon.melee?
        return quick_strike
      end
    when SKILL_HEAVY_STRIKE
      if (weapon = equipped_weapon) and weapon.melee?
        return heavy_strike
      end
    when SKILL_ACCURATE_STRIKE
      if (weapon = equipped_weapon) and weapon.melee?
        return accurate_strike
      end
    when SKILL_FINISHING_STRIKE
      if (weapon = equipped_weapon) and weapon.melee?
        return finishing_strike
      end
    when SKILL_PROTECT
      return protect
    when SKILL_SHIELD_WALL
      return shield_wall
    when SKILL_COUNTERSTRIKE
      return counterstrike
    when SKILL_FLING
      if (weapon = equipped_weapon) and weapon.ranged?
        return fling
      end
    when SKILL_QUICK_THROW
      if (weapon = equipped_weapon) and weapon.ranged?
        return quick_throw
      end
    when SKILL_HEAVY_THROW
      if (weapon = equipped_weapon) and weapon.ranged?
        return heavy_throw
      end
    when SKILL_TAKE_AIM
      return take_aim
    when SKILL_UNDISTURBED
      return undisturbed
    when SKILL_BOLA
      return bola
    when SKILL_MIND_POISON
      return mind_poison
    when SKILL_PARALYZING_POISON
      return paralyzing_poison
    when SKILL_WEAKNESS_POISON
      return weakness_poison
    when SKILL_RUN_UP
      return run_up
    end

    nil

  end

  def get_skill_value(skill_id)
    if skill_id == SKILL_STRIKE
      strike
    elsif skill_id == SKILL_THROWN
      thrown
    elsif skill_id == SKILL_RETREAT
      0
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
    elsif skill_id == SKILL_MIND_POISON
      mind_poison
    elsif skill_id == SKILL_PARALYZING_POISON
      paralyzing_poison
    elsif skill_id == SKILL_WEAKNESS_POISON
      weakness_poison
    elsif skill_id == SKILL_RUN_UP
      run_up
    end
  end

  def set_skill_value(skill_id, value)
    if skill_id == SKILL_STRIKE
      update_attribute(:strike, 4)
    elsif skill_id == SKILL_THROWN
      update_attribute(:thrown, 4)
    elsif skill_id == SKILL_RETREAT
    elsif skill_id == SKILL_DIRT
      update_attribute(:dirt, 4)
    elsif skill_id == SKILL_DEFENSIVE_POSTURE
      update_attribute(:defensive_posture, 4)
    elsif skill_id == SKILL_COVER
      update_attribute(:cover, 4)
    elsif skill_id == SKILL_QUICK_STRIKE
      update_attribute(:quick_strike, 4)
    elsif skill_id == SKILL_HEAVY_STRIKE
      update_attribute(:heavy_strike, 4)
    elsif skill_id == SKILL_ACCURATE_STRIKE
      update_attribute(:accurate_strike, 4)
    elsif skill_id == SKILL_FINISHING_STRIKE
      update_attribute(:finishing_strike, 4)
    elsif skill_id == SKILL_PROTECT
      update_attribute(:protect, 4)
    elsif skill_id == SKILL_SHIELD_WALL
      update_attribute(:shield_wall, 4)
    elsif skill_id == SKILL_COUNTERSTRIKE
      update_attribute(:counterstrike, 4)
    elsif skill_id == SKILL_FLING
      update_attribute(:fling, 4)
    elsif skill_id == SKILL_QUICK_THROW
      update_attribute(:quick_throw, 4)
    elsif skill_id == SKILL_HEAVY_THROW
      update_attribute(:heavy_throw, 4)
    elsif skill_id == SKILL_TAKE_AIM
      update_attribute(:take_aim, 4)
    elsif skill_id == SKILL_UNDISTURBED
      update_attribute(:undisturbed, 4)
    elsif skill_id == SKILL_BOLA
      update_attribute(:bola, 4)
    elsif skill_id == SKILL_MIND_POISON
      update_attribute(:mind_poison, 4)
    elsif skill_id == SKILL_PARALYZING_POISON
      update_attribute(:paralyzing_poison, 4)
    elsif skill_id == SKILL_WEAKNESS_POISON
      update_attribute(:weakness_poison, 4)
    end
  end

  def get_discipline_value(discipline_id)
    case discipline_id
    when DISCIPLINE_MELEE_COMBAT
      melee_combat
    when DISCIPLINE_RANGED_COMBAT
      ranged_combat
    when DISCIPLINE_DIRTY_COMBAT
      dirty_combat
    end
  end

  def melee_dodge?
    rand(1..100) <= (100*final_dex)/(100+final_dex)
  end

  def defensive_posture_dodge?
    (effects.map {|x| x[0] }).include?(EFFECT_DEFENSIVE_POSTURE) and skill_roll_successful?(SKILL_DEFENSIVE_POSTURE)
  end

  def parry_roll
    rand(1..100) <= 5
  end

  def damage_reduction
    val = armor + tgh
    ((100.0*val)/(50.0+val)) * 0.01
  end

  def is_protected?
    effects.each do |effect|
      if effect[0] == EFFECT_PROTECTED
        char = Character.find(effect[3])
        if char.skill_roll_successful?(SKILL_PROTECT)
          return char
        end
      end
    end
    return false
  end

  def aim_success?
    effects.each do |effect|
      if effect[0] == EFFECT_TAKEN_AIM and skill_available?(SKILL_TAKE_AIM) and skill_roll_successful?(SKILL_TAKE_AIM)
        return Character.find(effect[3])._id
      end
    end
    return false
  end

  def check_if_poisoned(char)
    result = ''
    if (char.effects.map {|x| x[0] }).include?(EFFECT_APPLIED_MIND_POISON)
      if char.skill_roll_successful?(SKILL_MIND_POISON)
        result += "<p>#{name} has been <span class='red'>poisoned</span> with mind numbing poison.</p>"
        effects << [EFFECT_MIND_POISON, rand(2..4), nil, nil]
      else
        result += "<p>The poison applied is not potent enough and #{name} avoids being poisoned.</p>"
      end
    end

    if (char.effects.map {|x| x[0] }).include?(EFFECT_APPLIED_PARALYZING_POISON)
      if char.skill_roll_successful?(SKILL_PARALYZING_POISON)
        result += "<p>#{name} has been <span class='red'>poisoned</span> with paralyzing poison.</p>"
        effects << [EFFECT_PARALYZING_POISON, rand(2..4), nil, nil]
      else
        result += "<p>The poison applied is not potent enough and #{name} avoids being poisoned.</p>"
      end
    end

    if (char.effects.map {|x| x[0] }).include?(EFFECT_APPLIED_WEAKNESS_POISON)
      if char.skill_roll_successful?(SKILL_WEAKNESS_POISON)
        result += "<p>#{name} has been <span class='red'>poisoned</span> with weakness poison.</p>"
        effects << [EFFECT_WEAKNESS_POISON, rand(2..4), nil, nil]
      else
        result += "<p>The poison applied is not potent enough and #{name} avoids being poisoned.</p>"
      end
    end

    result
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
    rand(1..100) <= (100*(final_dex + get_final_skill_value(skill_id)))/(7+(final_dex + get_final_skill_value(skill_id)))
  end

  def skill_roll_successful?(skill_id)
    rand(1..100) <= (100*get_final_skill_value(skill_id))/(7+get_final_skill_value(skill_id))
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

  def took_damage
    self.taken_damage = true
    effects.delete_if do |effect|
      effect[0] == EFFECT_RAN_UP
    end
  end

  def ran_up?
    effects.map {|x| x[0] }.include?(EFFECT_RAN_UP)
  end

  def equipped_weapon
    equipments.each do |equipment|
      if equipment.weapon?
        return equipment
      end
    end
    false
  end

  def equipped_shield
    equipments.each do |equipment|
      if equipment.shield?
        return equipment
      end
    end
    false
  end

  def equipped_head
    equipments.each do |equipment|
      if equipment.head?
        return equipment
      end
    end
    false
  end

  def equipped_chest
    equipments.each do |equipment|
      if equipment.chest?
        return equipment
      end
    end
    false
  end

  def equipped_legs
    equipments.each do |equipment|
      if equipment.legs?
        return equipment
      end
    end
    false
  end

  def change_item(equipment)
    if equipments.include?(equipment)
      equipment.character = nil
      equipment.save
    elsif equipment.weapon?
      if weapon = equipped_weapon
        weapon.character = nil
        weapon.save
      end
      equipment.character = self
      equipment.save

    elsif equipment.shield?
      if shield = equipped_shield
        shield.character = nil
        shield.save
      end
      equipment.character = self
      equipment.save

    elsif equipment.head?
      if head = equipped_head
        head.character = nil
        head.save
      end
      equipment.character = self
      equipment.save

    elsif equipment.chest?
      if chest = equipped_chest
        chest.character = nil
        chest.save
      end
      equipment.character = self
      equipment.save

  elsif equipment.legs?
      if legs = equipped_legs
        legs.character = nil
        legs.save
      end
      equipment.character = self
      equipment.save

    end
  end

  def roll_learning(skill_id)
    discipline = Constant.get_discipline(skill_id)
    if discipline != DISCIPLINE_NONE
      roll_discipline_increase(discipline)
    end
    if skill_id != SKILL_RETREAT
      roll_skill_increase(skill_id)
    end
  end

  def roll_discipline_increase(discipline_id)
    if rand(1..50) == 1 and rand(1..35) > get_discipline_value(discipline_id)
      learnings << discipline_id
    end
  end

  def roll_skill_increase(skill_id)
    if rand(1..50) == 1
      skill_value = get_skill_value(skill_id)
      if skill_value >= 20
        if rand(1..(20 * (skill_value - 19))) == 1
          learnings << skill_id
        end
      elsif rand(1..20) > skill_value
        learnings << skill_id
      end
    end
  end

  def apply_learnings
    result = ''
    learnings.each do |id|
      increment_skill(id)
      result += "<p><span class='green'>#{name} has become better at #{Constant.get_skill_name(id)}.</span><p>"
    end
    result
  end

  def increment_skill(skill_id)
    case skill_id
      when DISCIPLINE_MELEE_COMBAT
        update_attribute(:melee_combat, melee_combat + 1)
        if melee_combat.divmod(5)[1] == 0
          update_attribute(:melee_combat_points, melee_combat_points + 1)
        end
      when DISCIPLINE_RANGED_COMBAT
        update_attribute(:ranged_combat, ranged_combat + 1)
        if ranged_combat.divmod(5)[1] == 0
          update_attribute(:ranged_combat_points, ranged_combat_points + 1)
        end
      when DISCIPLINE_DIRTY_COMBAT
        update_attribute(:dirty_combat, dirty_combat + 1)
        if dirty_combat.divmod(5)[1] == 0
          update_attribute(:dirty_combat_points, dirty_combat_points + 1)
        end
      when SKILL_STRIKE
        update_attribute(:strike, strike + 1)
      when SKILL_THROWN
        update_attribute(:thrown, thrown + 1)
      when SKILL_RETREAT
      when SKILL_DIRT
        update_attribute(:dirt, dirt + 1)
      when SKILL_DEFENSIVE_POSTURE
        update_attribute(:defensive_posture, defensive_posture + 1)
      when SKILL_COVER
        update_attribute(:cover, cover + 1)
      when SKILL_QUICK_STRIKE
        update_attribute(:quick_strike, quick_strike + 1)
      when SKILL_HEAVY_STRIKE
        update_attribute(:heavy_strike, heavy_strike + 1)
      when SKILL_ACCURATE_STRIKE
        update_attribute(:accurate_strike, accurate_strike + 1)
      when SKILL_FINISHING_STRIKE
        update_attribute(:finishing_strike, finishing_strike + 1)
      when SKILL_PROTECT
        update_attribute(:protect, protect + 1)
      when SKILL_SHIELD_WALL
        update_attribute(:shield_wall, shield_wall + 1)
      when SKILL_COUNTERSTRIKE
        update_attribute(:counterstrike, counterstrike + 1)
      when SKILL_FLING
        update_attribute(:fling, fling + 1)
      when SKILL_QUICK_THROW
        update_attribute(:quick_throw, quick_throw + 1)
      when SKILL_HEAVY_THROW
        update_attribute(:heavy_throw, heavy_throw + 1)
      when SKILL_TAKE_AIM
        update_attribute(:take_aim, take_aim + 1)
      when SKILL_UNDISTURBED
        update_attribute(:undisturbed, undisturbed + 1)
      when SKILL_BOLA
        update_attribute(:bola, bola + 1)
      when SKILL_MIND_POISON
        update_attribute(:mind_poison, mind_poison + 1)
      when SKILL_PARALYZING_POISON
        update_attribute(:paralyzing_poison, paralyzing_poison + 1)
      when SKILL_WEAKNESS_POISON
        update_attribute(:weakness_poison, weakness_poison + 1)
    end
  end

  def points_to_spend?
    (melee_combat_points + ranged_combat_points + dirty_combat_points > 0)
  end

  def select_skill(skill_id)
    if Constant.get_discipline(skill_id) == DISCIPLINE_MELEE_COMBAT and self.melee_combat_points > 0
      self.melee_combat_points -= 1
      set_skill_value(skill_id, 4)
  elsif Constant.get_discipline(skill_id) == DISCIPLINE_RANGED_COMBAT and self.ranged_combat_points > 0
      self.ranged_combat_points -= 1
      set_skill_value(skill_id, 4)
  elsif Constant.get_discipline(skill_id) == DISCIPLINE_DIRTY_COMBAT and self.dirty_combat_points > 0
      self.dirty_combat_points -= 1
      set_skill_value(skill_id, 4)
    end
  end

  #PRIVATE METHODS FROM HERE
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

