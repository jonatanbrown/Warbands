$(document).ready(function() {

    $("#reroll-characters").on("click", function(event) {
        var team_id = $(this).attr('data-id')
        $.ajax({
          type: "POST",
          url: '/teams/' + team_id + '/roll_stats',
          success: function(data) {
            $("#characters-table").html(data);
          },
          dataType: 'html'
        });
        return false;
    });

    $(".sell-item-button").on("click", function(event) {
        team_id = $('#team-info').attr('data-id');
        item_id = $(this).attr('data-id');
        $.ajax({
            url: '/teams/' + team_id + '/sell_item/' + item_id,
            success: function(data) {

            },
            dataType: 'script'
        });
        $(this).closest('.equipment-info').remove()
        $('.tooltip').remove()
        return false;
    });

    register_edit_team_listeners();

    $(".decrease-stat-button").on("click", function(event) {
        var pos = $(this).parent().attr('data-pos');
        var stat = $(this).parent().attr('data-stat');

        var label = $(this).parent().find('.stat-label');
        var input = $(this).parent().find('.stat-value');

        var current_label = parseInt(label.html());
        var current_value = parseInt(input.val());

        if(current_value > -5)
        {

            //Need to send -1 here because it is the previous stat point we need the cost for.
            var cost = calc_stat_cost(current_value - 1);
            var change = 1;

            if(stat == 'hp')
                change = 3;

            Warbands.team_points['char' + pos + '_points'] += cost;
            var new_label = current_label - change;
            label.html(new_label);
            input.val(current_value -= 1);
            $(this).closest('.create-character').find('.points').html('' + Warbands.team_points['char' + pos + '_points']);
        }
    });

    $(".increase-stat-button").on("click", function(event) {
        var pos = $(this).parent().attr('data-pos');
        var stat = $(this).parent().attr('data-stat');

        var label = $(this).parent().find('.stat-label');
        var input = $(this).parent().find('.stat-value');

        var current_label = parseInt(label.html());
        var current_value = parseInt(input.val());

        if(current_value < 10)
        {

            var cost = calc_stat_cost(current_value);
            var change = 1;

            if(stat == 'hp')
                change = 3

            if(Warbands.team_points['char' + pos + '_points'] >= cost)
            {
                Warbands.team_points['char' + pos + '_points'] -= cost;
                var new_label = current_label + change;
                label.html(new_label);
                input.val(current_value += 1);
                $(this).closest('.create-character').find('.points').html('' + Warbands.team_points['char' + pos + '_points']);
            }
        }
    });

    $(".decrease-skill-button").on("click", function(event) {
        var pos = $(this).parent().attr('data-pos');
        var stat = $(this).parent().attr('data-skill');

        var label = $(this).parent().find('.skill-label');
        var input = $(this).parent().find('.skill-value');

        var current_label = parseInt(label.html());
        var current_value = parseInt(input.val());

        //Need to send -1 here because it is the previous skill point we need the cost for.
        var cost = calc_skill_cost(current_value - 1);

        if(current_value > 0)
        {
            Warbands.team_points['char' + pos + '_points'] += cost;
            var new_label = current_label - 1;
            label.html(new_label);
            input.val(current_value -= 1);
            $(this).closest('.create-character').find('.points').html('' + Warbands.team_points['char' + pos + '_points']);
        }
    });

    $(".increase-skill-button").on("click", function(event) {
        var pos = $(this).parent().attr('data-pos');
        var stat = $(this).parent().attr('data-skill');

        var label = $(this).parent().find('.skill-label');
        var input = $(this).parent().find('.skill-value');

        var current_label = parseInt(label.html());
        var current_value = parseInt(input.val());

        if(current_value < 15)
        {
            var cost = calc_skill_cost(current_value);

            if(Warbands.team_points['char' + pos + '_points'] >= cost)
            {
                Warbands.team_points['char' + pos + '_points'] -= cost;
                var new_label = current_label + 1;
                label.html(new_label);
                input.val(current_value += 1);
                $(this).closest('.create-character').find('.points').html('' + Warbands.team_points['char' + pos + '_points']);
            }
        }
    });

});

function calc_stat_cost(val) {
    var cost = 1;
    if(val >= 8)
        cost = 4;
    else if(val >= 6)
        cost = 3;
    else if(val >= 3)
        cost = 2;
    return cost;
}

function calc_skill_cost(val) {
    var cost = 1;
    if(val >= 13)
        cost = 4;
    else if(val >= 11)
        cost = 3;
    else if(val >= 8)
        cost = 2;
    return cost;
}

function register_edit_team_listeners() {

    $('.edit-team-character').popover({placement: 'bottom'})

    register_formation_listener();

    $("#submit-character-positions").on("click", function(event) {
        var team_id = $(this).attr('data-id')
        var pos0_char = $("#position0_character").val()
        var pos1_char = $("#position1_character").val()
        var pos2_char = $("#position2_character").val()
        var pos3_char = $("#position3_character").val()
        var pos4_char = $("#position4_character").val()
        var positions = {
            0: pos0_char,
            1: pos1_char,
            2: pos2_char,
            3: pos3_char,
            4: pos4_char,
        }
        $.ajax({
          type: "POST",
          url: '/teams/' + team_id + '/set_character_positions/',
          data: {positions: positions},
          success: function(data) {
            $("#char-positions").html(data)
            $.ajax({
              type: "GET",
              url: '/teams/' + team_id + '/formation/',
              success: function(data) {
                $("#team-formation").html(data)
                $('.edit-team-character').popover({placement: 'bottom'})
              },
              dataType: 'html'
            });
          },
          dataType: 'html'
        });
        return false;
    });

    $('.character-selector').on('change', function() {
        var pos_changed = $(this).attr('data-pos')
        var char_selected = $(this).val()
        var previous_char_pos, char_replaced = null
        for (var i = 0; i < Warbands.team_characters.length; i++)
        {
            if(Warbands.team_characters[i][1] == char_selected)
            {
                previous_char_pos = Warbands.team_characters[i][0]
            }
            if(Warbands.team_characters[i][0] == pos_changed)
            {
                char_replaced = Warbands.team_characters[i][1]
            }
        }
        $("#position" + previous_char_pos + "_character").val(char_replaced)
        for (var i = 0; i < Warbands.team_characters.length; i++)
        {
            if(Warbands.team_characters[i][0] == previous_char_pos)
            {
               Warbands.team_characters[i][1] = char_replaced;
            }
            if(Warbands.team_characters[i][0] == pos_changed)
            {
                Warbands.team_characters[i][1] = char_selected;
            }
        }
    });

    $("#submit-character-names").on("click", function(event) {
        var team_id = $('#team-info').attr('data-id');
        var name_fields = $('.character-name-field');
        var names = {}
        console.log(name_fields)
        for (var i = 0; i < name_fields.length; i++)
        {
            names[$(name_fields[i]).attr('data-id') + ''] = $(name_fields[i]).val();
        }
        $.ajax({
          type: "POST",
          url: '/teams/' + team_id + '/set_character_names/',
          data: {names: names},
          success: function(data) {
            $(".inner-content").html(data)
            register_edit_team_listeners();
          },
          dataType: 'html'
        });
        return false;
    });

    $("#destroy-team").on("click", function(event) {
        var team_id = $('#team-info').attr('data-id');
        if(confirm('Are you sure you want to delete your team?'))
        {
            $.ajax({
              type: "DELETE",
              url: '/teams/' + team_id,
              success: function(data) {

              },
              dataType: 'script'
            });
        }
        return false;
    });
}

function register_formation_listener() {
    $("#formation-selector").on("change", function(event) {
        var team_id = $(this).attr('data-id')
        var formation_num = $(this).val()
        $.ajax({
          type: "POST",
          url: '/teams/' + team_id + '/set_formation/' + formation_num,
          success: function(data) {
            $("#edit-formation").html(data);
            $('.edit-team-character').popover({placement: 'bottom'});
            register_formation_listener();
          },
          dataType: 'html'
        });
    });
}

