class CharactersController < ApplicationController

  def edit
    @character = Character.find(params[:id])
  end

  def update
    @character = Character.find(params[:id])
    @character.name = params[:name]
    @character.save
    render :nothing => true
  end

end

