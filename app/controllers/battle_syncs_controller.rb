class BattleSyncsController < ApplicationController

  def refresh_waiting_status
    bs = current_user.battle_sync
    if bs.submit_count == 0
      render :text => "true"
    else
      if bs.seconds_since_submit > 60 and current_user.battle.submitted
        team = current_user.team
        op_team = User.find(team.user.battle.opponent).team

        bs.update_attribute(:turn_events, "")
        Battle.do_battle_results(op_team, team, TIMED_OUT, OPPONENT_TIMED_OUT)
        render :text => "true"
      else
        render :text => "false"
      end
    end
  end

  def seconds_left
    bs = current_user.battle_sync

    result = bs.seconds_since_submit

    if result != -1
      render :text => (60 - result).to_s
    else
      render :text => -1
    end
  end

end

