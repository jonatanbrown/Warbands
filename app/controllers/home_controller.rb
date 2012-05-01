class HomeController < ApplicationController
  def index
  end

  def home
    @user = current_user
  end
end

