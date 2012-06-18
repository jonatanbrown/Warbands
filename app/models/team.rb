class Team
  include Mongoid::Document
  belongs_to :user
  has_many :characters

  field :name, :type => String

  field :formation, :type => Integer, :default => 1

  def create_characters
    5.times do |i|
      c = Character.new(:name => "Character #{i + 1}")
      c.roll_char
      c.position = i
      self.characters << c
    end
  end

  def get_char(pos)
    self.characters.where(position: pos).first
  end

  def reset_battle_stats
    self.characters.each do |c|
      c.update_attributes(current_hp: c.hp, active: true)
    end
  end

  def set_character_positions(char_positions)
    chars = char_positions.map{|i| i[1] }
    chars.uniq!
    if chars.length == 5
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
end

