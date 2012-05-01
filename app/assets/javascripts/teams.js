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
});

