class TeamsController < ApplicationController
  def new
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
    render :partial => "character", :collection => @team.characters
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
end

