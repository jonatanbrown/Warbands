$(document).ready(function() {

    $('#submit-turn').on("click", submit_turn);

    $(".confirm-skill").on("click", function(event) {

        var pos = $(this).attr('data-pos');
        var selector = $('#pos' + pos + '-skill-selector')

        var skill_id = $('#pos' + pos + '-skill-selector').val()
        var target = $('#pos' + pos + '-character-selector').val()

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

            //Recalculate action selector options
            set_options(selector, pos);
        }
        return false;
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

function set_options(selector, pos) {
    selector.html(" ");
    ap = battle['pos' + pos + '_ap']
    for (i in battle.skills)
    {
        if (ap >= battle.skills[i][2])
        {
            selector.append('<option value="' + battle.skills[i][1] + '" data-ap="' + battle.skills[i][2] + '">' + battle.skills[i][0] + ' - ' + battle.skills[i][2] + '</option>');
        }
    }
}

function submit_turn() {
    console.log("submitting turn");
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

