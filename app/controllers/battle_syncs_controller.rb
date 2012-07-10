class BattleSyncsController < ApplicationController

  def refresh_waiting_status
    bs = current_user.battle_sync
    if bs.submit_count == 0
      render :text => "true"
    else
      if bs.seconds_since_submit > 60 and current_user.battle.submitted
        battle = current_user.battle
        opponent = User.find(battle.opponent)
        op_battle = opponent.battle

        bs.update_attribute(:turn_events, "")
        op_battle.update_attribute(:result, TIMED_OUT)
        opponent.team.update_attribute(:points, opponent.team.points - 1)
        battle.update_attribute(:result, OPPONENT_TIMED_OUT)
        current_user.team.update_attribute(:points, current_user.team.points + 1)
        render :text => "true"
      else
        render :text => "false"
      end
    end
  end

end

