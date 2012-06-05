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

    $("#formation-selector").on("change", function(event) {
        var team_id = $(this).attr('data-id')
        var formation_num = $(this).val()
        $.ajax({
          type: "POST",
          url: '/teams/' + team_id + '/set_formation/' + formation_num,
          success: function(data) {
            $("#team-formation").html(data)
          },
          dataType: 'html'
        });
    });

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
          },
          dataType: 'html'
        });
        return false;
    });
});

