class HomeController < ApplicationController
  def index
  end

  def home
    @user = current_user
  end

  def smithy
    @team = current_user.team
  end

  def arena
    if current_user.battle_queue
      redirect_to queue_path
    elsif current_user.battle and current_user.battle.submitted
      redirect_to waiting_for_turn_path
    elsif current_user.battle and !current_user.battle.submitted and current_user.battle_sync
      redirect_to next_turn_path
    elsif current_user.battle and !current_user.battle.submitted
      redirect_to battle_path
    end
  end
end

