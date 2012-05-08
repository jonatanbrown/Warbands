class Team
  include Mongoid::Document
  belongs_to :user
  has_many :characters

  field :name, :type => String

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
      c.update_attribute(:current_hp, c.hp)
    end
  end

end

