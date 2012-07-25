$(document).ready(function() {

    $(".sell-item-button").tooltip({placement: 'right'});

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
            $('.inner-content').html(data)
            register_switch_char_listeners();
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
            $('.inner-content').html(data)
            register_switch_char_listeners();
            register_equipment_listeners();
          },
          dataType: 'html'
        });
        return false;
    });
}

function register_switch_char_listeners() {
    var sync_count = 0
    var content_data = null
    $(".switch-character-button").on("click", function(event) {
        $('.inner-content').fadeOut(100, function() {
            ++sync_count;
            if(sync_count > 1) {
                $('.inner-content').html(content_data);
                $('.inner-content').fadeIn(100);
                register_switch_char_listeners();
                register_equipment_listeners();
            }
        });
        window.history.replaceState({}, 'Warbands', '/characters/' + $(this).attr('data-char-id') + '/edit');
        $.ajax({
          type: "GET",
          url: '/characters/' + $(this).attr('data-char-id') + '/switch_char',
          success: function(data) {
            ++sync_count;
            content_data = data;
            if(sync_count > 1) {
                $('.inner-content').html(content_data);
                $('.inner-content').fadeIn(100);
                register_switch_char_listeners();
                register_equipment_listeners();
            }
          },
          dataType: 'html'
        });
        return false;
    });
}

