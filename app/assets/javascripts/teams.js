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

});

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

