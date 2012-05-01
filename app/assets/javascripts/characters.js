$(document).ready(function() {
    $(".submit-character").on("click", function(event) {
        var char_id = $(this).attr('data-id')
        var name = $("#"+char_id).val()
        $.ajax({
          type: "POST",
          url: '/characters/' + char_id + '/update',
          data: 'name=' + name,
          success: function(data) {
          },
          dataType: 'html'
        });
        return false;
    });
});

