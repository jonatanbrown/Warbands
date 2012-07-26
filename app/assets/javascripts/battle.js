$(document).ready(function() {

    $(window).on("click", function(event) {
        if(battle.skill_selected != null)
            battle.skill_selected = null
            $('.skill-button-container').removeClass('selected');
    });

    $('.battle-character').popover({placement: 'bottom'})
    $('.skill-icon-image').tooltip({placement: 'top'});

    $('#submit-turn').on("click", submit_turn);
    $('#mass-retreat').on("click", mass_retreat);
});

function listen_select_skill_buttons(selector) {
    $(selector).on("click", function(event) {
        skill_selector = $(this).closest('.skill-select')
        pos = skill_selector.attr('data-pos')
        skill_id = $(this).attr('data-skill-id')
        targetability = battle.skills[skill_id][3]

        $('.skill-button-container').removeClass('selected');

        $(this).closest('.skill-button-container').addClass('selected')
        battle['skill_selected'] = {pos: pos, skill_id: skill_id}

        if(targetability == 0){
            confirm_skill(pos, skill_id, null, skill_selector)
        }
        return false
    });
    $('.skill-icon-image').tooltip({placement: 'top'});
}

function confirm_skill(pos, skill_id, target, skill_selector) {

    var skill_ap = battle.skills[skill_id][2]

    //Add actions to battle orders
    if (battle.skills[skill_id][3] == 3 || battle.skills[skill_id][3] == 4)
        battle['actions']['' + pos].push({action: skill_id, target: target, friendly: true})
    else
        battle['actions']['' + pos].push({action: skill_id, target: target, friendly: false})

    //Recalculate remaining AP, and update display
    battle['pos' + pos + '_ap'] -= skill_ap
    $('#pos' + pos + '-ap').html('AP: ' + battle['pos' + pos + '_ap'])

    //Append to visible list of actions
    update_action_list(pos);

    //Recalculate action selector options and set selectors
    set_skill_options(skill_selector, pos);
}

function update_action_list(pos) {
    $('#pos' + pos + '-actions').html("");
    for (var i = 0; i < battle['actions']['' + pos].length; i++) {
        var skill_id = battle['actions']['' + pos][i]['action'];
        var target_pos = battle['actions']['' + pos][i]['target'];
        var skill_name = battle['skills'][skill_id][0];
        var friendly = battle['actions']['' + pos][i]['friendly'];
        var target_name = ''
        if (friendly) {
            for (var n = 0; n < battle.chars.length; n++) {
                if(battle.chars[n][1] == target_pos)
                    target_name += ' at ' + battle.chars[n][0]
            }
        }
        else {
            for (var n = 0; n < battle.op_chars.length; n++) {
                if(battle.op_chars[n][1] == target_pos)
                    target_name += ' at ' + battle.op_chars[n][0]
            }
        }
        $('#pos' + pos + '-actions').append('<p>' + skill_name + target_name + ' <a href="#" class="undo-action" data-action-index=' + i + ' data-pos=' + pos + '><span class="red">X</span></a>' + '</p>');
    }
    $('.undo-action').on("click", undo_action);
}

function set_target_options(selector, skill_id, pos) {
    selector.html(" ");
    //Check what targets are legal
    if (battle.skills[skill_id][3] == 0 || battle.skills[skill_id][3] == 5)
    {
    }
    else if (battle.skills[skill_id][3] == 4)
    {
        for (i in battle.chars)
        {
            var target = battle.chars[i]
            if (pos != target[1])
            {
                selector.append('<option value="' + target[1] + '">' + target[0] + '</option>');
            }
        }
    }
    else
    {
        for (i in battle.op_chars)
        {
            var info = ""
            var target = battle.op_chars[i]
            if (battle.pos_targetability[target[1]][1] == 1)
                info = "Slight penalty";
            else if (battle.pos_targetability[target[1]][1] == 2)
                info = "Severe penalty";
            if (skill_can_target_pos(skill_id, pos, battle.formation, target[1]))
            {
                selector.append('<option value="' + target[1] + '">' + target[0] + " " + info +'</option>');
            }
        }
    }
}

function set_skill_options(selector, pos) {
    selector.html(" ");
    $('.tooltip').remove()
    var ap = battle['pos' + pos + '_ap']
    for (i in battle.skills)
    {
        skill_level = battle['pos' + pos + '_skills'][i]
        skill = battle.skills[i]
        if (ap >= skill[2] && skill_level > 0)
        {
            if (skill[3] == 1 && !battle.melee_range[pos])
            {
                //Melee skill and char infront, don't add option.
            }
            else
            {
                selector.append('<div class="skill-button-container left"><a href="#" class="select-skill-button" data-skill-id="' + skill[1] + '"><img class="skill-icon-image" rel="tooltip" src="/images/' + skill[4] + '" data-original-title="'+ skill[0] + ' - lvl ' + skill_level + ' - ' + skill[2] + ' ap"></a></div>')
            }
        }
    }
    listen_select_skill_buttons("#pos" + pos + "-skill-selector .select-skill-button");
}

function submit_turn() {
    delete battle['skills'];
    $.ajax({
        url: 'confirm_turn',
        data: battle,
        success: function(data) {
            window.location.replace(data);
        },
        dataType: 'text'
    });
    return false;
}

function undo_action() {

    var index = $(this).attr('data-action-index');
    var pos = $(this).attr('data-pos');
    var skill_id = battle['actions']['' + pos][index].action

    var ap_cost = battle.skills[skill_id][2]

    var skill_selector = $('#pos' + pos + '-skill-selector')

    battle['pos' + pos + '_ap'] += ap_cost
    $('#pos' + pos + '-ap').html('AP: ' + battle['pos' + pos + '_ap'])

    battle['actions']['' + pos].splice(index, 1);

    update_action_list(pos);

    set_skill_options(skill_selector, pos);

    return false;
}

function mass_retreat() {
    for (x = 0; x < 5; ++x){
        battle['actions']['' + x].push({action: '2', target: null})
    }
    submit_turn()
    return false;
}

function skill_can_target_pos(skill_id, char_pos, formation, target_pos) {

    //Ranged Skill
    if(battle.skills[skill_id][3] == 2)
    {
        return true;
    }

    //Melee skill
    else if(battle.skills[skill_id][3] == 1)
    {
        if(battle.pos_targetability[target_pos][0] == true)
            return true;
        else
            return false;
    }

    //Other skill
    else
        return true;
}

function update_timeout_clock(){
  $.ajax({
    type: "GET",
    url: '/battle_syncs/seconds_left/',
    success: function(data) {
      if(data == '-1')
        $('#submit-timer').html("Opponent has not yet confirmed actions.");
      else
      {
        var int_data = parseInt(data);
        $('#submit-timer').html("<b><span class='red'>Timeout in " + int_data + " seconds.</span></b>");
        clearInterval(battle_actions_interval_id);
        setInterval(
          function(){
            int_data -= 1;
            $('#submit-timer').html("<b><span class='red'>Timeout in " + int_data + " seconds.</span></b>");
          },
          1000
        );
      }

    },
    dataType: 'text'
  });
}

