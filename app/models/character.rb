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

  def melee_target
    char0_active = team.get_char(0).active
    char1_active = team.get_char(1).active
    char2_active = team.get_char(2).active
    case team.formation
    when 1
      true
    when 2
      if (0..3) === position
        true
      elsif !char1_active and !char2_active
        true
      else
        false
      end
    when 3
      if (0..2) === position
        true
      elsif position == 3
        if !char0_active and !char1_active
          true
        else
          false
        end
      elsif position == 4
        if !char1_active and !char2_active
          true
        else
          false
        end
      end
    when 4
      if (0..1) === position
        true
      elsif position == 2
        if !char0_active
          true
        else
          false
        end
      elsif position == 3
        if !char0_active and !char1_active
          true
        else
          false
        end
      elsif position == 4
        if !char1_active
          true
        else
          false
        end
      end
    end
  end

  # 0: No penalty
  # 1: Slight penalty
  # 2: Heavy penalty
  def ranged_target
    char0_active = team.get_char(0).active
    char1_active = team.get_char(1).active
    char2_active = team.get_char(2).active
    case team.formation
    when 1
      0
    when 2
      if (0..3) === position or (!char1_active and !char2_active)
        0
      elsif !char1_active or !char2_active
        1
      else
        2
      end
    when 3
      if (0..2) === position
        0
      elsif position == 3
        if !char0_active and !char1_active
          0
        elsif !char0_active or !char1_active
          1
        else
          2
        end
      elsif position == 4
        if !char1_active and !char2_active
          0
        elsif !char1_active or !char2_active
          1
        else
          2
        end
      end
    when 4
      if (0..1) === position
        0
      elsif position == 2
        if !char0_active
          0
        else
          1
        end
      elsif position == 3
        if !char0_active and !char1_active
          0
        elsif !char0_active or !char1_active
          1
        else
          2
        end
      elsif position == 4
        if !char1_active
          0
        else
          1
        end
      end
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

