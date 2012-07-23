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

    $(".select-skill-button").on("click", function(event) {
        $.ajax({
          type: "POST",
          url: '/characters/' + character_id + '/select_skill',
          data: 'skill_id=' + $(this).attr('data-skill-id'),
          success: function(data) {
            window.location.reload()
          },
          dataType: 'html'
        });
        return false;
    });

    register_switch_char_listeners();

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

function register_switch_char_listeners() {
    $(".switch-character-button").on("click", function(event) {
        $('.inner-content').fadeOut(200);
        window.history.replaceState({}, 'Warbands', '/characters/' + $(this).attr('data-char-id') + '/edit');
        $.ajax({
          type: "GET",
          url: '/characters/' + $(this).attr('data-char-id') + '/switch_char',
          success: function(data) {
            $('.inner-content').html(data);
            register_switch_char_listeners();
            register_equipment_listeners();
            $('.inner-content').fadeIn(200);
          },
          dataType: 'html'
        });
        return false;
    });
}

