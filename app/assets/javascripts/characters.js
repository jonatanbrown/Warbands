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

    register_equipment_listeners();
});

function register_equipment_listeners() {
    $('.equipment-selector').on("change", function(event) {
        var equipment_id = $(this).val()
        var char_id = $('#character-equipment').attr('data-id')
        $.ajax({
          type: "POST",
          url: '/characters/' + char_id + '/change_item/' + equipment_id,
          success: function(data) {
            $('#character-equipment').html(data)
            register_equipment_listeners();
          },
          dataType: 'html'
        });
        return false;
    });

    $('.unequip-item').on("click", function(event) {
        var equipment_id = $(this).attr('data-id')
        var char_id = $('#character-equipment').attr('data-id')
        $.ajax({
          type: "GET",
          url: '/characters/' + char_id + '/change_item/' + equipment_id,
          success: function(data) {
            $('#character-equipment').html(data)
            register_equipment_listeners();
          },
          dataType: 'html'
        });
        return false;
    });
}

