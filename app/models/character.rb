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

  field :hp, :type => Integer, :default => 20

  #Skills

  #Melee Combat
  field :strike, :type => Integer

  #Ranged
  field :thrown, :type => Integer
  field :projectile, :type => Integer

  #Defense
  field :defensive_posture, :type => Integer
  field :block, :type => Integer

  #Dirty Combat
  field :poison, :type => Integer
  field :dirt, :type => Integer

  #Magic
  field :defensive, :type => Integer
  field :destructive, :type => Integer
  field :buffs, :type => Integer
  field :debuffs, :type => Integer

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

    self.thrown = roll_skill
    self.projectile = roll_skill

    self.defensive_posture = roll_skill
    self.block = roll_skill

    self.poison = roll_skill
    self.dirt = roll_skill

    #Magic works as all other skills now, will later be done in some other way.
    self.defensive = roll_skill
    self.destructive = roll_skill
    self.debuffs = roll_skill
    self.buffs = roll_skill
  end

  def get_priority(action_index)
    self.ini - (action_index * 4) + rand(1..5)
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
    if (effects.map {|x| x[0] }).include?(EFFECT_DIRT)
      result = result * 0.5
    end
    result.round(0)
  end

  def final_tgh
    tgh
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

