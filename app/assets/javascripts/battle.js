$(document).ready(function() {

    $('#submit-turn').on("click", submit_turn);

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
        var skill_name = battle['skills'][skill_id - 1][0];
        $('#pos' + pos + '-actions').append('<p>' + skill_name + ' at ' + target_pos + '</p>');
    }
}

function set_target_options(selector, skill_id, pos) {
    selector.html(" ");
    if (battle.skills[skill_id - 1][3] == 0)
    {
    }
    else
    {
        for (i in battle.op_chars_pos)
        {
            var info = ""
            var target = battle.op_chars_pos[i]
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
    ap = battle['pos' + pos + '_ap']
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
        success: function() {
            window.location.replace('/battles/waiting_for_turn');
        },
        dataType: 'html'
    });
    return false;
}

function skill_can_target_pos(skill_id, char_pos, formation, target_pos) {

    //Ranged Skill
    if(battle.skills[skill_id - 1][3] == 2)
    {
        return true;
    }

    //Melee skill
    else if(battle.skills[skill_id - 1][3] == 1)
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

