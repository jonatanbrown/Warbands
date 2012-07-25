class CharactersController < ApplicationController

  def edit
    @character = Character.find(params[:id])
    @team = current_user.team
    unused_equipment = @team.unused_equipment
    @unused_weapons = unused_equipment.where(:eq_type => 0..6)
    @unused_shields = unused_equipment.where(:eq_type => EQUIPMENT_SHIELD)
    @unused_head = unused_equipment.where(:eq_type => EQUIPMENT_HEAD)
    @unused_chest = unused_equipment.where(:eq_type => EQUIPMENT_CHEST)
    @unused_legs = unused_equipment.where(:eq_type => EQUIPMENT_LEGS)
    @unused_equipment = unused_equipment
  end

  def switch_char
    @character = Character.find(params[:id])
    @team = current_user.team
    unused_equipment = @team.unused_equipment
    @unused_weapons = unused_equipment.where(:eq_type => 0..6)
    @unused_shields = unused_equipment.where(:eq_type => EQUIPMENT_SHIELD)
    @unused_head = unused_equipment.where(:eq_type => EQUIPMENT_HEAD)
    @unused_chest = unused_equipment.where(:eq_type => EQUIPMENT_CHEST)
    @unused_legs = unused_equipment.where(:eq_type => EQUIPMENT_LEGS)
    @unused_equipment = unused_equipment
    render :edit, :layout => false
  end

  def update
    @character = Character.find(params[:id])
    @character.name = params[:name]
    @character.save
    render :nothing => true
  end

  def change_item
    @character = Character.find(params[:id])
    if !current_user.battle
      equipment = Equipment.find(params[:equipment_id])
      @character.change_item(equipment)
      @character = Character.find(params[:id])
    else
      @character.errors.add(:equipments, "Cannot change equipment during battle.")
    end
    @team = current_user.team
    unused_equipment = @team.unused_equipment
    @unused_weapons = unused_equipment.where(:eq_type => 0..6)
    @unused_shields = unused_equipment.where(:eq_type => EQUIPMENT_SHIELD)
    @unused_head = unused_equipment.where(:eq_type => EQUIPMENT_HEAD)
    @unused_chest = unused_equipment.where(:eq_type => EQUIPMENT_CHEST)
    @unused_legs = unused_equipment.where(:eq_type => EQUIPMENT_LEGS)
    @unused_equipment = unused_equipment
    render :edit, :layout => false
  end

  def skillup
    @character = Character.find(params[:id])
  end

  def select_skill
    character = Character.find(params[:id])
    character.select_skill(params[:skill_id].to_i)
    character.save
    render :nothing => true
  end
end

