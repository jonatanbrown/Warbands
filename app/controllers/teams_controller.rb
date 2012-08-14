class TeamsController < ApplicationController
  def new
    if current_user.team
      redirect_to root_path
    end
    @team = Team.create(:name => "The Team")
    @team.create_characters
    @team.reset_battle_stats
    @points = 20
  end

  def roll_stats
    @team = Team.find(params[:id])
    @team.equipments = []
    @team.characters.each do |c|
      c.roll_char
      c.create_basic_gear
      c.save
    end
    render :partial => "characters/character", :collection => @team.characters
  end

  def show
    @team = Team.find(params[:id])
  end

  def update
    @team = Team.find(params[:id])
    @team.update_attributes(:name => params[:team][:name], :user => current_user)
    redirect_to @team
  end

  def edit
    @team = current_user.team
  end

  def set_formation
    @team = Team.find(params[:id])

    if @team.set_formation(params[:formation_num])
      @team.save
    end
    render "_formation", :layout => false

  end

  def set_character_positions
    @team = Team.find(params[:id])
    if @team.set_character_positions(params["positions"])
      @team.save
    end
    render "_char_positions", :layout => false
  end

  def set_character_names
    @team = Team.find(params[:id])
    @team.set_character_names(params["names"])
    @team.save
    render :edit, :layout => false
  end

  def in_battle
    team = Team.find(params[:id])
    if team.user.battle
      render :text => "true"
    else
      render :text => "false"
    end
  end

  def formation
    @team = Team.find(params[:id])
    render "_formation", :layout => false
  end

  def purchase_item
    @team = Team.find(params[:id])
    cost = Equipment.get_cost(params[:item])
    if cost > @team.gold
      @result = '<span class="red">Not enough gold.</span>'
    else
      @team.gold -= cost
      @team.save
      item = Equipment.create_item(params[:item], @team)
      @result = "Purchased #{item.name} for #{cost} gold."
    end
    render "purchase_item"
  end

  def sell_item
    @team = Team.find(params[:id])
    equipment = Equipment.find(params[:item_id])
    @team.update_attribute(:gold, @team.gold + (equipment.value / 3.0).round(0))
    equipment.destroy
    render "sell_item"
  end

  def destroy
    @team = Team.find(params[:id])
    unless @team.user.battle
      @team.characters.destroy_all
      @team.destroy
      render 'delete_success', :formats => [:js]
    else
      render 'delete_error', :formats => [:js]
    end
  end
end

