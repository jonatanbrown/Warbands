$(document).ready(function() {

    $('.battle-character').popover({placement: 'bottom'})

    $('#submit-turn').on("click", submit_turn);
    $('#mass-retreat').on("click", mass_retreat);

    $(".confirm-skill").on("click", function(event) {

        var pos = $(this).attr('data-pos');
        var skill_selector = $('#pos' + pos + '-skill-selector')
        var target_selector = $('#pos' + pos + '-character-selector')

        var skill_id = $('#pos' + pos + '-skill-selector').val()
        var target = target_selector.val()

        if (skill_id)
        {
            var skill_text = $('#pos' + pos + '-skill-selector' + " option[value=" + skill_id + "]").text();
            var skill_ap = $('#pos' + pos + '-skill-selector' + " option[value=" + skill_id + "]").attr('data-ap');

            //Add actions to battle orders
            battle['actions']['' + pos].push({action: skill_id, target: target})

            //Recalculate remaining AP, and update display
            battle['pos' + pos + '_ap'] -= skill_ap
            $('#pos' + pos + '-ap').html('AP: ' + battle['pos' + pos + '_ap'])

            //Append to visible list of actions
            update_action_list(pos);

            //Recalculate action selector options and set selectors
            set_skill_options(skill_selector, pos);
            set_target_options(target_selector, skill_selector.val(), pos)
        }
        return false;
    });

    $(".skill-selector").on("change", function(event) {
        var skill_id = $(this).val()
        var pos = $(this).attr('data-pos');
        var target_selector = $('#pos' + pos + '-character-selector')
        set_target_options(target_selector, skill_id, pos)
    });

    $(".target-selector").each(function(index, selector) {
        var pos = $(selector).attr('data-pos')
        var skill_selector = $('#pos' + pos + '-skill-selector')
        set_target_options($(selector), skill_selector.val(), pos)
    });
});

function update_action_list(pos) {
    $('#pos' + pos + '-actions').html("");
    for (i in battle['actions']['' + pos])
    {
        var skill_id = battle['actions']['' + pos][i]['action'];
        var target_pos = battle['actions']['' + pos][i]['target'];
        var skill_name = battle['skills'][skill_id][0];
        $('#pos' + pos + '-actions').append('<p>' + skill_name + ' at ' + target_pos + ' <a href="#" class="undo-action" data-action-index=' + i + ' data-pos=' + pos + '><span class="red">X</span></a>' + '</p>');
    }
    $('.undo-action').on("click", undo_action);
}

function set_target_options(selector, skill_id, pos) {
    selector.html(" ");
    if (battle.skills[skill_id][3] == 0)
    {
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
    var ap = battle['pos' + pos + '_ap']
    for (i in battle.skills)
    {
        if (ap >= battle.skills[i][2])
        {
            if (battle.skills[i][3] == 1 && !battle.melee_range[pos])
            {
                //Melee skill and char infront, don't add option.
            }
            else
            {
                selector.append('<option value="' + battle.skills[i][1] + '" data-ap="' + battle.skills[i][2] + '">' + battle.skills[i][0] + ' - ' + battle.skills[i][2] + '</option>');
            }
        }
    }
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
    var target_selector = $('#pos' + pos + '-character-selector')

    battle['pos' + pos + '_ap'] += ap_cost
    $('#pos' + pos + '-ap').html('AP: ' + battle['pos' + pos + '_ap'])

    battle['actions']['' + pos].splice(index, 1);

    update_action_list(pos);

    set_skill_options(skill_selector, pos);
    set_target_options(target_selector, skill_selector.val(), pos)

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
        $('#submit-timer').html("Timeout in " + int_data + " seconds.");
        clearInterval(battle_actions_interval_id);
        setInterval(
          function(){
            int_data -= 1;
            $('#submit-timer').html("Timeout in " + int_data + " seconds.");
          },
          1000
        );
      }

    },
    dataType: 'text'
  });
}

