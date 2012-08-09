class Team
  include Mongoid::Document
  belongs_to :user
  has_many :characters

  has_many :equipments

  field :name, :type => String

  field :formation, :type => Integer, :default => 1

  field :rating, :type => Integer, :default => 1000

  field :gold, :type => Integer, :default => 200

  field :difficulty, :type => Integer, :default => nil

  def create_characters
    5.times do |i|
      c = Character.new(:name => "Character #{i + 1}")
      c.roll_char
      c.position = i
      self.characters << c
      c.create_basic_gear
    end
  end

  def get_char(pos)
    self.characters.where(position: pos).first
  end

  def reset_battle_stats
    self.characters.each do |c|
      c.update_attributes(current_hp: c.hp, active: true, effects: [])
    end
  end

  def set_character_positions(char_positions)
    chars = char_positions.map{|i| i[1] }
    chars.uniq!

    unless chars.length == 5
      errors.add(:position, "You can not have two characters in the same position.")
    end

    if self.user.battle
      errors.add(:position, "Cannot change positions during battle.")
    end

    unless self.errors.any?
      char_positions.each do |c|
        position = c[0].to_i
        id = c[1]
        char = Character.find(id)
        char.position = position
        char.save
      end
      true
    else
      false
    end

  end

  def set_character_names(char_names)
    char_names.each do |id, name|
      char = Character.find(id)
      char.update_attribute(:name, name)
    end
  end

  def set_formation(formation_num)

    unless (1..4) === formation_num.to_i
      errors.add(:formation, "Formation has to be between 1 and 4.")
    end

    if self.user.battle
      errors.add(:formation, "Cannot change formation during battle.")
    end

    unless self.errors.any?
      self.formation = formation_num
      true
    else
      false
    end

  end

  def position_targetability_melee(pos)
    if get_char(pos).active
      pos0_active = get_char(0).active
      pos1_active = get_char(1).active
      pos2_active = get_char(2).active
      case formation
      when 1
        true
      when 2
        if (0..3) === pos
          true
        elsif !pos1_active and !pos2_active
          true
        else
          false
        end
      when 3
        if (0..2) === pos
          true
        elsif pos == 3
          if !pos0_active and !pos1_active
            true
          else
            false
          end
        elsif pos == 4
          if !pos1_active and !pos2_active
            true
          else
            false
          end
        end
      when 4
        if (0..1) === pos
          true
        elsif pos == 2
          if !pos0_active
            true
          else
            false
          end
        elsif pos == 3
          if !pos0_active and !pos1_active
            true
          else
            false
          end
        elsif pos == 4
          if !pos1_active
            true
          else
            false
          end
        end
      end
    else
      false
    end
  end

  # 0: No penalty
  # 1: Slight penalty
  # 2: Severe penalty
  def position_targetability_ranged(pos)
    pos0_active = get_char(0).active
    pos1_active = get_char(1).active
    pos2_active = get_char(2).active
    case formation
    when 1
      0
    when 2
      if (0..3) === pos
          0
        elsif !pos1_active and !pos2_active
          0
        elsif !pos1_active or !pos2_active
          1
        else
          2
        end
    when 3
      if (0..2) === pos
          0
      elsif pos == 3
        if !pos0_active and !pos1_active
          0
        elsif !pos0_active or !pos1_active
          1
        else
          2
        end
      elsif pos == 4
        if !pos1_active and !pos2_active
          0
        elsif !pos1_active or !pos2_active
          1
        else
          2
        end
      end
    when 4
      if (0..1) === pos
          0
      elsif pos == 2
        if !pos0_active
          0
        else
          1
        end
      elsif pos == 3
        if !pos0_active and !pos1_active
          0
        elsif !pos0_active or !pos1_active
          1
        else
          2
        end
      elsif pos == 4
        if !pos1_active
          0
        else
          1
        end
      end
    end
  end

  def unused_equipment
    equipments.where(:character_id => nil)
  end

  def self.create_ai_team(type)
    case type
    when 'goblins'
      ai_team = Team.create(:name => "Gang of Goblins", :formation => 3, :rating => nil, :difficulty => 1)
      5.times do |i|
        if (0..2) === i
          basic_weapon = 'wooden_stick'
          name = 'Goblin Berserker'
        else
          basic_weapon = 'rusty_cutlery'
          name = 'Goblin Forkthrower'
        end
        c = Character.new(:name => name, :position => i, :str => 5, :dex => 11, :tgh => 3, :ini => 14, :int => 1, :mem => 1, :strike => 5, :fling => 5, :ap => 8, :hp => 30, :current_hp => 30)
        e = Equipment.create_item(basic_weapon, nil)
        c.equipments << e
        e.save
        c.save
        ai_team.characters << c
      end
      ai_team.save
    end
    ai_team
  end
end

