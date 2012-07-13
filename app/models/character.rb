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
      field :accurate_thow, :type => Integer
      field :take_aim, :type => Integer
      field :undisturbed, :type => Integer

  #Dirty Combat

    #Basic
      field :dirt, :type => Integer

    #Learnable
      field :bola, :type => Integer
      field :aggravate, :type => Integer
      field :mind_poison, :type => Integer
      field :paralyzing_poison, :type => Integer
      field :weakness_poison, :type => Integer

  #Magic

  #Combat info
  field :current_hp, :type => Integer
  field :active, :type => Boolean, :default => 1

  field :position, :type => Integer

  #Tuples in effects are in format [effect_id, duration, power]
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

  def get_priority(action_index)
    self.final_ini - (action_index * 4) + rand(1..5)
  end

  def is_active?
    current_hp > 0
  end

  def action_available?(skill_nr)
    #Should check if the character has learned the skill etc, now only checks if skill is a valid skill number at all.
    (0..MAX_SKILL_NUM) === skill_nr.to_i
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
    result += "<p>Cover: #{cover}</p>"
    result += "<p>Throw Dirt: #{dirt}</p>"
  end

  #Returns skills in order of ID
  def get_skills_array
    [strike, thrown, 0, dirt, defensive_posture, cover]
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

