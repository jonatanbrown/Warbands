module ApplicationHelper

  def battle_button(text)
    if current_user.battle and current_user.battle.submitted
      link_to ("<span class='red'><b>" + text + "</b></span>").html_safe, waiting_for_turn_path
    elsif current_user.battle and !current_user.battle.submitted and current_user.battle_sync
      link_to ("<span class='red'><b>" + text + "</b></span>").html_safe, next_turn_path
    elsif current_user.battle and !current_user.battle.submitted
      link_to ("<span class='red'><b>" + text + "</b></span>").html_safe, battle_path
    end
  end

end

