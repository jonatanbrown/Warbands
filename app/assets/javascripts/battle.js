$(document).ready(function() {

    $('.battle-character').popover({placement: 'bottom'})

    $('#submit-turn').on("click", submit_turn);
    $('#mass-retreat').on("click", mass_retreat);

    $('.battle-character').on('click', function() {
        if(!$(this).hasClass('disabled') && !$(this).hasClass('knocked-out') && battle.skill_selected != null){
            confirm_skill(battle.skill_selected.pos, battle.skill_selected.skill_id, $(this).attr('data-position'))
            return false;
        }
    });
});

function listen_select_skill_buttons(selector) {
    $(selector).on("click", function(event) {
        skill_selector = $(this).closest('.skill-select')
        pos = skill_selector.attr('data-pos')
        skill_id = $(this).attr('data-skill-id')
        targetability = battle.skills[skill_id][3]

        $('.skill-button-container').removeClass('selected');
        $('.battle-character').removeClass('disabled legal-target slight-penalty-target severe-penalty-target');

        $(this).closest('.skill-button-container').addClass('selected')
        battle['skill_selected'] = {pos: parseInt(pos), skill_id: parseInt(skill_id)}

        if(targetability == 0 || targetability == 5){
            confirm_skill(pos, skill_id, null)
        }
        else if(targetability == 1) {
        $('#opponent-team').find('.battle-character[data-targetability-melee="false"]').addClass('disabled');
        $('#opponent-team').find('.battle-character[data-targetability-melee="true"]').addClass('legal-target');
        $('#home-team').find('.battle-character').addClass('disabled');
        }
        else if(targetability == 2) {
            $('#home-team').find('.battle-character').addClass('disabled');
            $('#opponent-team').find('.battle-character[data-targetability-ranged="0"]').addClass('legal-target');
            $('#opponent-team').find('.battle-character[data-targetability-ranged="1"]').addClass('slight-penalty-target');
            $('#opponent-team').find('.battle-character[data-targetability-ranged="2"]').addClass('severe-penalty-target');
        }
        else if(targetability == 3) {
            $('#opponent-team').find('.battle-character').addClass('disabled');
            $('#home-team').find('.battle-character').addClass('legal-target');
        }
        else if(targetability == 4) {
            $('#opponent-team').find('.battle-character').addClass('disabled');
            $('#home-team').find('.battle-character').addClass('legal-target');
            $('#home-team').find('.battle-character[data-position="' + pos + '"]').addClass('disabled').removeclass('legal-target');
        }
        return false
    });
    $(selector).find('.skill-icon-image').tooltip({placement: 'top', delay: {show: 500, hide: 100}});
}

function confirm_skill(pos, skill_id, target) {

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
    skill_selector = $('#pos' + pos + '-skill-selector');
    set_skill_options(skill_selector, pos);

    battle.skill_selected = null;
}

function update_action_list(pos) {

    $('.skill-button-container').removeClass('selected');
    $('.battle-character').removeClass('disabled legal-target slight-penalty-target severe-penalty-target');

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
    $('.undo-action[data-pos*="' + pos + '"]').on("click", undo_action);
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
                selector.append('<div class="skill-button-container left"><a href="#" class="select-skill-button" data-skill-id="' + skill[1] + '"><img class="skill-icon-image" rel="tooltip" src="/images/' + skill[4] + '" data-original-title="<b>'+ skill[0] + ' - lvl ' + skill_level + ' - ' + skill[2] + ' ap </b></br> ' + skill[5] + '"></a></div>')
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
    $(this).parent().html("<img src='/images/spinner.gif'/>");
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
    submit_turn();
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
            if(int_data % 2 == 0) {
                var color = 'red'
            }
            else {
                var color = ''
            }

            $('#submit-timer').html("<b><span class='" + color + "'>Timeout in " + int_data + " seconds.</span></b>");

            if(int_data < 0)
                submit_turn();
          },
          1000
        );
      }

    },
    dataType: 'text'
  });
}

