class TeamsController < ApplicationController
  def new
    @team = Team.new
    current_user.team = @team
    @team.update_attribute(:name, "The Team")
    current_user.save
    @team.create_characters
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
    puts "params is"
    puts params
   @team.update_attribute(:name, params[:team][:name])
   redirect_to @team
  end

  def edit
    @team = current_user.team
  end

end

