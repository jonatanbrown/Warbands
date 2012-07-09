class BattleSyncsController < ApplicationController

  def both_submitted
    bs = current_user.battle_sync
    if bs.submit_count == 0
      render :text => "true"
    else
      render :text => "false"
    end
  end

end

