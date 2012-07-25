class TeamsController < ApplicationController
  def new
    if current_user.team
      current_user.team.characters.destroy_all
      current_user.team.destroy
    end
    @team = Team.new
    current_user.team = @team
    @team.update_attribute(:name, "The Team")
    current_user.save
    @team.create_characters
    @team.reset_battle_stats
  end

  def roll_stats
    @team = Team.find(params[:id])
    @team.characters.each do |c|
      c.roll_char
      c.save
    end
    render :partial => "characters/character", :collection => @team.characters
  end

  def show
    @team = Team.find(params[:id])
  end

  def update
    @team = Team.find(params[:id])
    @team.update_attribute(:name, params[:team][:name])
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
    @team.destroy
    redirect_to root_path
  end
end

