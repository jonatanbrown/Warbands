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

  def battle_character(pos, team)
    char = team.get_char(pos)
    content = ''
    if current_user.team.characters.include?(char)
      content += char.get_stats_text
    end
    content += "</br>"
    content += char.get_effects_text
    result = '<div class="battle-character" rel="popover" data-content="' + content + '" data-original-title="' + char.name + '">'
      if team.get_char(pos).active
        result += render :partial => "characters/battle_character", :locals => { :character => char }
      else
        result += 'Knocked out.'
      end
    result += '</div>'
    result.html_safe
  end

  def edit_team_character(pos, team)
    char = team.get_char(pos)
    content = ''

    content += char.get_stats_text
    content += "</br>"
    content += char.get_skills_text

    result = '<div class="edit-team-character" rel="popover" data-content="' + content + '" data-original-title="' + char.name + '">'
      result += char.name
    result += '</div>'
    result.html_safe
  end

end

