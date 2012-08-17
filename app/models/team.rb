class Team
  include Mongoid::Document
  belongs_to :user
  has_many :characters

  has_many :equipments, :dependent => :destroy

  field :name, :type => String

  field :formation, :type => Integer, :default => 1

  field :rating, :type => Integer, :default => 1000

  field :gold, :type => Integer, :default => 200

  field :difficulty, :type => Integer, :default => nil

  field :monster_beaten, :type => Integer, :default => 0

  def create_characters
    5.times do |i|
      c = Character.create(:name => "Character #{i + 1}")
      self.characters << c
      c.position = i
      c.save
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
    c = get_char(pos)
    if c and c.active
      pos0_active = (c = get_char(0) and c.active)
      pos1_active = (c = get_char(1) and c.active)
      pos2_active = (c = get_char(2) and c.active)
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
    pos0_active = (c = get_char(0) and c.active)
    pos1_active = (c = get_char(1) and c.active)
    pos2_active = (c = get_char(2) and c.active)
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
        c = Character.new(:name => name, :position => i, :str => 5, :dex => 15, :tgh => 3, :ini => 14, :int => 1, :mem => 1, :strike => 10, :fling => 10, :ap => 8, :hp => 30, :current_hp => 30)
        e = Equipment.create_item(basic_weapon, nil)
        c.equipments << e
        e.save
        c.save
        ai_team.characters << c
      end
      ai_team.save
    when 'boar'
      ai_team = Team.create(:name => "Giant Boar", :formation => 1, :rating => nil, :difficulty => 2)
      c = Character.new(:name => 'Giant Boar', :position => 2, :str => 18, :dex => 11, :tgh => 17, :ini => 13, :int => 1, :mem => 1, :strike => 17, :ap => 40, :hp => 180, :current_hp => 180)
      e = Equipment.create_item('giant_tusks', nil)
      c.equipments << e
      e.save
      c.save
      ai_team.characters << c
      ai_team.save
    when 'orc_bandits'
      ai_team = Team.create(:name => "Orc Bandits", :formation => 3, :rating => nil, :difficulty => 3)
      3.times do |i|
        if i == 0
          basic_weapon = 'small_axe'
          name = 'Orc Thug'
          position = 1
        else
          basic_weapon = 'javelins'
          name = 'Orc Spearthrower'
          position = i + 2
        end

        c = Character.new(:name => name, :position => position, :str => 15, :dex => 6, :tgh => 16, :ini => 7, :int => 1, :mem => 1, :strike => 14, :thrown => 14, :dirt => 14, :ap => 16, :hp => 70, :current_hp => 80)
        e = Equipment.create_item(basic_weapon, nil)
        c.equipments << e
        e.save
        c.save
        ai_team.characters << c
      end
      ai_team.save
    when 'ogre'
      ai_team = Team.create(:name => "Ogre", :formation => 1, :rating => nil, :difficulty => 4)
      c = Character.new(:name => 'Ogre', :position => 2, :str => 45, :dex => 8, :tgh => 23, :ini => 5, :int => 1, :mem => 1, :heavy_strike => 10, :ap => 32, :hp => 300, :current_hp => 300)
      e = Equipment.create_item('club', nil)
      c.equipments << e
      e.save
      c.save
      ai_team.characters << c
      ai_team.save
    when 'trained_gladiators'
      ai_team = Team.create(:name => "Trained Gladiators", :formation => 3, :rating => nil, :difficulty => 5)
      5.times do |i|
        if (0..2) === i
          basic_weapon = 'short_spear'
          c = Character.new(:name => 'Hardened Veteran', :position => i, :str => 15, :dex => 12, :tgh => 15, :ini => 12, :int => 1, :mem => 1, :strike => 15, :dirt => 13, :ap => 18, :hp => 100, :current_hp => 100)
          e = Equipment.create_item('kite_shield', nil)
          c.equipments << e
          e.save
          e = Equipment.create_item('full_helm', nil)
          c.equipments << e
          e.save
        else
          basic_weapon = 'throwing_axes'
          c = Character.new(:name => 'Master of Axes', :position => i, :str => 10, :dex => 20, :tgh => 10, :ini => 19, :int => 1, :mem => 1, :take_aim => 11, :bola => 14, :thrown => 15, :ap => 18, :hp => 60, :current_hp => 60)
        end
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

