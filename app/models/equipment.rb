class Equipment
  include Mongoid::Document
  belongs_to :team

  belongs_to :character

  field :name, :type => String

  field :eq_type, :type => Integer

  field :min_damage, :type => Integer
  field :max_damage, :type => Integer

  field :armor, :type => Integer
  field :str_req, :type => Integer, :default => 0

  field :value, :type => Integer

  def equipped?
    character != nil
  end

  def weapon?
    (0..6) === eq_type
  end

  def shield?
    eq_type == EQUIPMENT_SHIELD
  end

  def head?
    eq_type == EQUIPMENT_HEAD
  end

  def chest?
    eq_type == EQUIPMENT_CHEST
  end

  def legs?
    eq_type == EQUIPMENT_LEGS
  end

  def melee?
    (0..3) === eq_type
  end

  def ranged?
    (4..6) === eq_type
  end

  def get_class_name
    case eq_type
    when EQUIPMENT_SWORD
      'Sword'
    when EQUIPMENT_MACE
      'Mace'
    when EQUIPMENT_AXE
      'Axe'
    when EQUIPMENT_SPEAR
      'Spear'
    when EQUIPMENT_THROWING_KNIVES
      'Knife'
    when EQUIPMENT_JAVELINS
      'Javelin'
    when EQUIPMENT_THROWING_AXES
      'Axe'
    when EQUIPMENT_SHIELD
      'Shield'
    when EQUIPMENT_HEAD
      'Head Armor'
    when EQUIPMENT_CHEST
      'Chest Armor'
    when EQUIPMENT_LEGS
      'Leg Armor'
    end
  end

  def get_equipment_slot
    case eq_type
    when EQUIPMENT_SWORD
      'Weapon'
    when EQUIPMENT_MACE
      'Weapon'
    when EQUIPMENT_AXE
      'Weapon'
    when EQUIPMENT_SPEAR
      'Weapon'
    when EQUIPMENT_THROWING_KNIVES
      'Weapon'
    when EQUIPMENT_JAVELINS
      'Weapon'
    when EQUIPMENT_THROWING_AXES
      'Weapon'
    when EQUIPMENT_SHIELD
      'Shield'
    when EQUIPMENT_HEAD
      'Head Armor'
    when EQUIPMENT_CHEST
      'Chest Armor'
    when EQUIPMENT_LEGS
      'Leg Armor'
    end
  end

  def roll_damage
    rand(min_damage..max_damage)
  end

  def self.get_cost(item)
    case item
      when 'short_sword'
        35
      when 'club'
        35
      when 'small_axe'
        35
      when 'short_spear'
        35
      when 'throwing_knives'
        35
      when 'javelins'
        35
      when 'throwing_axes'
        35
      when 'buckler'
        40
      when 'small_shield'
        150
      when 'kite_shield'
        500
      when 'leather_cap'
        20
      when 'studded_leather_cap'
        55
      when 'chainmail_coif'
        200
      when 'full_helm'
        650
      when 'leather_armor'
        45
      when 'studded_leather_armor'
        145
      when 'chainmail_armor'
        400
      when 'chest_plate'
        900
      when 'leather_pants'
        25
      when 'studded_leather_pants'
        75
      when 'chainmail_breeches'
        220
      when 'plate_legs'
        600
    end
  end

  def self.create_item(item, team)
    case item
      when 'short_sword'
        Equipment.create(:name => 'Short Sword', :team => team, :eq_type => EQUIPMENT_SWORD, :min_damage => 4, :max_damage => 8, :value => 35)
      when 'club'
        Equipment.create(:name => 'Club', :team => team, :eq_type => EQUIPMENT_MACE, :min_damage => 4, :max_damage => 8, :value => 35)
      when 'small_axe'
        Equipment.create(:name => 'Small Axe', :team => team, :eq_type => EQUIPMENT_AXE, :min_damage => 4, :max_damage => 8, :value => 35)
      when 'short_spear'
        Equipment.create(:name => 'Short Spear', :team => team, :eq_type => EQUIPMENT_SPEAR, :min_damage => 4, :max_damage => 8, :value => 35)
      when 'throwing_knives'
        Equipment.create(:name => 'Throwing Knives', :team => team, :eq_type => EQUIPMENT_THROWING_KNIVES, :min_damage => 4, :max_damage => 8, :value => 35)
      when 'javelins'
        Equipment.create(:name => 'Javelins', :team => team, :eq_type => EQUIPMENT_JAVELINS, :min_damage => 4, :max_damage => 8, :value => 35)
      when 'throwing_axes'
        Equipment.create(:name => 'Throwing Axes', :team => team, :eq_type => EQUIPMENT_THROWING_AXES, :min_damage => 4, :max_damage => 8, :value => 35)
      when 'buckler'
        Equipment.create(:name => 'Buckler', :team => team, :eq_type => EQUIPMENT_SHIELD, :armor => 2, :value => 40)
      when 'small_shield'
        Equipment.create(:name => 'Small Shield', :team => team, :eq_type => EQUIPMENT_SHIELD, :armor => 3, :str_req => 2, :value => 150)
      when 'kite_shield'
        Equipment.create(:name => 'Kite Shield', :team => team, :eq_type => EQUIPMENT_SHIELD, :armor => 5, :str_req => 5, :value => 500)
      when 'leather_cap'
        Equipment.create(:name => 'Leather Cap', :team => team, :eq_type => EQUIPMENT_HEAD, :armor => 1, :value => 20)
      when 'studded_leather_cap'
        Equipment.create(:name => 'Studded Leather Cap', :team => team, :eq_type => EQUIPMENT_HEAD, :armor => 2, :value => 55)
      when 'chainmail_coif'
        Equipment.create(:name => 'Chainmail Coif', :team => team, :eq_type => EQUIPMENT_HEAD, :armor => 4, :str_req => 3, :value => 200)
      when 'full_helm'
        Equipment.create(:name => 'Full Helm', :team => team, :eq_type => EQUIPMENT_HEAD, :armor => 7, :str_req => 6, :value => 650)
      when 'leather_armor'
        Equipment.create(:name => 'Leather Armor', :team => team, :eq_type => EQUIPMENT_CHEST, :armor => 2, :value => 45)
      when 'studded_leather_armor'
        Equipment.create(:name => 'Studded Leather Armor', :team => team, :eq_type => EQUIPMENT_CHEST, :armor => 4, :str_req => 2, :value => 145)
      when 'chainmail_armor'
        Equipment.create(:name => 'Chainmail Armor', :team => team, :eq_type => EQUIPMENT_CHEST, :armor => 7, :str_req => 4, :value => 400)
      when 'chest_plate'
        Equipment.create(:name => 'Chest Plate', :team => team, :eq_type => EQUIPMENT_CHEST, :armor => 10, :str_req => 8, :value => 900)
      when 'leather_pants'
        Equipment.create(:name => 'Leather Pants', :team => team, :eq_type => EQUIPMENT_LEGS, :armor => 1, :value => 25)
      when 'studded_leather_pants'
        Equipment.create(:name => 'Studded Leather Pants', :team => team, :eq_type => EQUIPMENT_LEGS, :armor => 2, :str_req => 1, :value => 75)
      when 'chainmail_breeches'
        Equipment.create(:name => 'Chainmail Breeches', :team => team, :eq_type => EQUIPMENT_LEGS, :armor => 5, :str_req => 4, :value => 220)
      when 'plate_legs'
        Equipment.create(:name => 'Full Plate Leggings', :team => team, :eq_type => EQUIPMENT_LEGS, :armor => 8, :str_req => 7, :value => 600)
    end
  end

end

