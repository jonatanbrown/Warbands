class CharactersController < ApplicationController

  def update
    @character = Character.find(params[:id])
    @character.name = params[:name]
    @character.save
    render :nothing => true
  end

end

