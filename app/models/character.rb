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
  field :dodge, :type => Integer
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
  field :active, :type => Boolean

  field :position, :type => Integer


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

    self.dodge = roll_skill
    self.block = roll_skill

    self.poison = roll_skill
    self.dirt = roll_skill

    #Magic works as all other skills now, will later be done in some other way.
    self.defensive = roll_skill
    self.destructive = roll_skill
    self.debuffs = roll_skill
    self.buffs = roll_skill
  end

  def get_priority
    self.ini
  end

  def is_active?
    current_hp > 0
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

