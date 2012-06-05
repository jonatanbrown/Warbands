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
end

