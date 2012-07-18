class HomeController < ApplicationController
  def index
  end

  def home
    @user = current_user
  end

  def smithy
    @team = current_user.team
  end
end

