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

  def self.get_class_tooltip(eq_type)
    case eq_type
    when EQUIPMENT_SWORD
      'Swords give a 5% chance to parry melee attacks.'
    when EQUIPMENT_MACE
      'Maces give a 5% chance to stun the opponent, negating their next action.'
    when EQUIPMENT_AXE
      'Axes give a 5% chance to cause the opponent to bleed, causing damage over time.'
    when EQUIPMENT_SPEAR
      'Spears give a 10% bonus to Initiative of weapon based attacks.'
    when EQUIPMENT_THROWING_KNIVES
      'Knives give a 10% bonus to Initiative of weapon based attacks.'
    when EQUIPMENT_JAVELINS
      'Javelins reduce chance of missing with weapon based attacks by 10%.'
    when EQUIPMENT_THROWING_AXES
      'Axes give a 5% chance to cause the opponent to bleed, causing damage over time.'
    end
  end

  def self.get_item_class_tooltip(item)
    case item
      when 'short_sword', 'gladius', 'spatha'
        get_class_tooltip(EQUIPMENT_SWORD)
      when 'club', 'flanged_mace','morning_star'
        get_class_tooltip(EQUIPMENT_MACE)
      when 'small_axe', 'battle_axe', 'ono'
        get_class_tooltip(EQUIPMENT_AXE)
      when 'short_spear', 'spetum', 'winged_spear'
        get_class_tooltip(EQUIPMENT_SPEAR)
      when 'throwing_knives', 'razor_darts', 'trombash'
        get_class_tooltip(EQUIPMENT_THROWING_KNIVES)
      when 'javelins', 'pilum', 'verutum'
        get_class_tooltip(EQUIPMENT_JAVELINS)
      when 'throwing_axes', 'francisca', 'hurlbat'
        get_class_tooltip(EQUIPMENT_THROWING_AXES)
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
      when 'short_sword', 'club', 'small_axe', 'short_spear', 'throwing_knives', 'javelins', 'throwing_axes'
        T1_WEAPON_VALUE
      when 'gladius', 'flanged_mace', 'battle_axe', 'spetum', 'razor_darts', 'pilum', 'francisca'
        T2_WEAPON_VALUE
      when 'spatha', 'morning_star', 'ono', 'winged_spear', 'trombash', 'verutum', 'hurlbat'
        T3_WEAPON_VALUE
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

      #MELEE WEAPONS
      when 'wooden_stick'
        Equipment.create(:name => 'Wooden Stick', :team => team, :eq_type => EQUIPMENT_MACE, :min_damage => 2, :max_damage => 4, :value => 3)
      when 'giant_tusks'
        Equipment.create(:name => 'Giant Tusks', :team => team, :eq_type => EQUIPMENT_AXE, :min_damage => 3, :max_damage => 5)
      when 'short_sword'
        Equipment.create(:name => 'Short Sword', :team => team, :eq_type => EQUIPMENT_SWORD, :min_damage => T1_WEAPON_MIN_DAMAGE, :max_damage => T1_WEAPON_MAX_DAMAGE, :value => T1_WEAPON_VALUE)
      when 'club'
        Equipment.create(:name => 'Club', :team => team, :eq_type => EQUIPMENT_MACE, :min_damage => T1_WEAPON_MIN_DAMAGE, :max_damage => T1_WEAPON_MAX_DAMAGE, :value => T1_WEAPON_VALUE)
      when 'small_axe'
        Equipment.create(:name => 'Small Axe', :team => team, :eq_type => EQUIPMENT_AXE, :min_damage => T1_WEAPON_MIN_DAMAGE, :max_damage => T1_WEAPON_MAX_DAMAGE, :value => T1_WEAPON_VALUE)
      when 'short_spear'
        Equipment.create(:name => 'Short Spear', :team => team, :eq_type => EQUIPMENT_SPEAR, :min_damage => T1_WEAPON_MIN_DAMAGE, :max_damage => T1_WEAPON_MAX_DAMAGE, :value => T1_WEAPON_VALUE)
      when 'gladius'
        Equipment.create(:name => 'Gladius', :team => team, :eq_type => EQUIPMENT_SWORD, :min_damage => T2_WEAPON_MIN_DAMAGE, :max_damage => T2_WEAPON_MAX_DAMAGE, :value => T2_WEAPON_VALUE)
      when 'flanged_mace'
        Equipment.create(:name => 'Flanged Mace', :team => team, :eq_type => EQUIPMENT_MACE, :min_damage => T2_WEAPON_MIN_DAMAGE, :max_damage => T2_WEAPON_MAX_DAMAGE, :value => T2_WEAPON_VALUE)
      when 'battle_axe'
        Equipment.create(:name => 'Battle Axe', :team => team, :eq_type => EQUIPMENT_AXE, :min_damage => T2_WEAPON_MIN_DAMAGE, :max_damage => T2_WEAPON_MAX_DAMAGE, :value => T2_WEAPON_VALUE)
      when 'spetum'
        Equipment.create(:name => 'Spetum', :team => team, :eq_type => EQUIPMENT_SPEAR, :min_damage => T2_WEAPON_MIN_DAMAGE, :max_damage => T2_WEAPON_MAX_DAMAGE, :value => T2_WEAPON_VALUE)
      when 'spatha'
        Equipment.create(:name => 'Spatha', :team => team, :eq_type => EQUIPMENT_SWORD, :min_damage => T3_WEAPON_MIN_DAMAGE, :max_damage => T3_WEAPON_MAX_DAMAGE, :value => T3_WEAPON_VALUE)
      when 'morning_star'
        Equipment.create(:name => 'Morning Star', :team => team, :eq_type => EQUIPMENT_MACE, :min_damage => T3_WEAPON_MIN_DAMAGE, :max_damage => T3_WEAPON_MAX_DAMAGE, :value => T3_WEAPON_VALUE)
      when 'ono'
        Equipment.create(:name => 'Ono', :team => team, :eq_type => EQUIPMENT_AXE, :min_damage => T3_WEAPON_MIN_DAMAGE, :max_damage => T3_WEAPON_MAX_DAMAGE, :value => T3_WEAPON_VALUE)
      when 'winged_spear'
        Equipment.create(:name => 'Winged Spear', :team => team, :eq_type => EQUIPMENT_SPEAR, :min_damage => T3_WEAPON_MIN_DAMAGE, :max_damage => T3_WEAPON_MAX_DAMAGE, :value => T3_WEAPON_VALUE)

      #RANGED WEAPONS
      when 'rusty_cutlery'
        Equipment.create(:name => 'Rusty Cutlery', :team => team, :eq_type => EQUIPMENT_THROWING_KNIVES, :min_damage => 2, :max_damage => 4, :value => 3)
      when 'throwing_knives'
        Equipment.create(:name => 'Throwing Knives', :team => team, :eq_type => EQUIPMENT_THROWING_KNIVES, :min_damage => T1_WEAPON_MIN_DAMAGE, :max_damage => T1_WEAPON_MAX_DAMAGE, :value => T1_WEAPON_VALUE)
      when 'javelins'
        Equipment.create(:name => 'Javelins', :team => team, :eq_type => EQUIPMENT_JAVELINS, :min_damage => T1_WEAPON_MIN_DAMAGE, :max_damage => T1_WEAPON_MAX_DAMAGE, :value => T1_WEAPON_VALUE)
      when 'throwing_axes'
        Equipment.create(:name => 'Throwing Axes', :team => team, :eq_type => EQUIPMENT_THROWING_AXES, :min_damage => T1_WEAPON_MIN_DAMAGE, :max_damage => T1_WEAPON_MAX_DAMAGE, :value => T1_WEAPON_VALUE)
      when 'razor_darts'
        Equipment.create(:name => 'Razor Darts', :team => team, :eq_type => EQUIPMENT_THROWING_KNIVES, :min_damage => T2_WEAPON_MIN_DAMAGE, :max_damage => T2_WEAPON_MAX_DAMAGE, :value => T2_WEAPON_VALUE)
      when 'pilum'
        Equipment.create(:name => 'Pilum', :team => team, :eq_type => EQUIPMENT_JAVELINS, :min_damage => T2_WEAPON_MIN_DAMAGE, :max_damage => T2_WEAPON_MAX_DAMAGE, :value => T2_WEAPON_VALUE)
      when 'francisca'
        Equipment.create(:name => 'Francisca', :team => team, :eq_type => EQUIPMENT_THROWING_AXES, :min_damage => T2_WEAPON_MIN_DAMAGE, :max_damage => T2_WEAPON_MAX_DAMAGE, :value => T2_WEAPON_VALUE)
      when 'trombash'
        Equipment.create(:name => 'Trombash', :team => team, :eq_type => EQUIPMENT_THROWING_KNIVES, :min_damage => T3_WEAPON_MIN_DAMAGE, :max_damage => T3_WEAPON_MAX_DAMAGE, :value => T3_WEAPON_VALUE)
      when 'verutum'
        Equipment.create(:name => 'Verutum', :team => team, :eq_type => EQUIPMENT_JAVELINS, :min_damage => T3_WEAPON_MIN_DAMAGE, :max_damage => T3_WEAPON_MAX_DAMAGE, :value => T3_WEAPON_VALUE)
      when 'hurlbat'
        Equipment.create(:name => 'Hurlbat', :team => team, :eq_type => EQUIPMENT_THROWING_AXES, :min_damage => T3_WEAPON_MIN_DAMAGE, :max_damage => T3_WEAPON_MAX_DAMAGE, :value => T3_WEAPON_VALUE)

      #ARMOR
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

