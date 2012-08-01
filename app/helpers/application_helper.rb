module ApplicationHelper

  def battle_button
    if current_user.battle_queue
      link_to "<img src='/images/green_swords.png' class='battle-button' border='0' rel='tooltip' data-original-title='In Queue'/>".html_safe, queue_path
    elsif current_user.battle and current_user.battle.submitted
      link_to "<img src='/images/red_swords.png' class='battle-button' border='0' rel='tooltip' data-original-title='In Battle!'/>".html_safe, waiting_for_turn_path
    elsif current_user.battle and !current_user.battle.submitted
      link_to "<img src='/images/red_swords.png' class='battle-button' border='0' rel='tooltip' data-original-title='In Battle!'/>".html_safe, battle_path
    else
      "<img src='/images/grey_swords.png' class='battle-button' border='0' rel='tooltip' data-original-title='Not in Queue' />".html_safe
    end
  end

  def battle_character(pos, team)
    char = team.get_char(pos)
    if team.get_char(pos).active
      content = '<b>'
      if current_user.team.characters.include?(char)
        content += char.get_stats_text
        content += "</br>"
        content += char.get_gear_text
      else
        content += char.get_cryptic_stats_text
      end
      content += "</br>"
      content += char.get_effects_text
      content += '</b>'
      result = '<div class="battle-character" rel="popover" data-targetability-melee="' + team.position_targetability_melee(pos).to_s + '" data-targetability-ranged="' + team.position_targetability_ranged(pos).to_s + '" data-content="' + content + '" data-original-title="' + char.name + '" data-position="'+ pos.to_s + '">'
      result += render :partial => "characters/battle_character", :locals => { :character => char }
    else
      result = '<div class="battle-character knocked-out">'
      result += 'Knocked out.'
    end
    result += '</div>'
    result.html_safe
  end

  def edit_team_character(pos, team)
    char = team.get_char(pos)
    content = "<b>"
    content += char.get_stats_text
    content += "</br>"
    content += char.get_skills_text
    content += "</b>"

    result = '<div class="edit-team-character" rel="popover" data-content="' + content + '" data-original-title="' + char.name + '">'
      result += '<div class="position-number">' + (pos + 1).to_s + '</div>'
      result += char.name
      if weapon = char.equipped_weapon
        if weapon.melee?
          result += '</br><img src="/images/icon_melee.png"/>'
        else
          result += '</br><img src="/images/icon_ranged.png"/>'
        end
      else
        result += '</br>Unarmed'
      end
    result += '</div>'
    result.html_safe
  end

end

