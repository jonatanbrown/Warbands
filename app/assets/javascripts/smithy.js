$(document).ready(function() {
    $(".item-button").on("mouseover", function(event) {
        result = get_item_description($(this).attr('data-item'));
        $("#smithy-item-view").html(result);
    });

    $(".item-button").on("mouseenter", function(event) {
        $(this).parent().find('.buy-item-button').show(200);
    });

    $(".smithy-btn-container").on("mouseleave", function(event) {
        $(this).find('.buy-item-button').hide();
    });

    $(".buy-item-button").on("click", function(event) {
        team_id = $('#team-info').attr('data-id')
        $.ajax({
            url: '/teams/' + team_id + '/purchase_item/' + $(this).attr('data-item'),
            success: function(data) {

            },
            dataType: 'script'
        });
        return false;
    });
});

function get_item_description(item) {
    console.log("getting item desc");
    result = '';
    switch(item)
    {
    case 'short_sword':
        result += '<h3>Short Sword</h3>';
        result += '<p>Class: Sword</p>'
        result += '<p>Range: Melee</p>'
        result += '<p>Damage: 4-8</p>'
        result += '<p><b>Cost: 35 Gold</b></p>'
        break;
    case 'club':
        result += '<h3>Club</h3>';
        result += '<p>Class: Mace</p>'
        result += '<p>Range: Melee</p>'
        result += '<p>Damage: 4-8</p>'
        result += '<p><b>Cost: 35 Gold</b></p>'
        break;
    case 'small_axe':
        result += '<h3>Small Axe</h3>';
        result += '<p>Class: Axe</p>'
        result += '<p>Range: Melee</p>'
        result += '<p>Damage: 4-8</p>'
        result += '<p><b>Cost: 35 Gold</b></p>'
        break;
    case 'short_spear':
        result += '<h3>Short Spear</h3>';
        result += '<p>Class: Spear</p>'
        result += '<p>Range: Melee</p>'
        result += '<p>Damage: 4-8</p>'
        result += '<p><b>Cost: 35 Gold</b></p>'
        break;
    case 'throwing_knives':
        result += '<h3>Throwing Knives</h3>';
        result += '<p>Class: Knife</p>'
        result += '<p>Range: Ranged</p>'
        result += '<p>Damage: 4-8</p>'
        result += '<p><b>Cost: 35 Gold</b></p>'
        break;
    case 'javelins':
        result += '<h3>Javelins</h3>';
        result += '<p>Class: Javelin</p>'
        result += '<p>Range: Ranged</p>'
        result += '<p>Damage: 4-8</p>'
        result += '<p><b>Cost: 35 Gold</b></p>'
        break;
    case 'throwing_axes':
        result += '<h3>Throwing Axes</h3>';
        result += '<p>Class: Axe</p>'
        result += '<p>Range: Ranged</p>'
        result += '<p>Damage: 4-8</p>'
        result += '<p><b>Cost: 35 Gold</b></p>'
        break;
    case 'buckler':
        result += '<h3>Buckler</h3>';
        result += '<p>Armor: 2</p>'
        result += '<p><b>Cost: 40 Gold</b></p>'
        break;
    case 'small_shield':
        result += '<h3>Small Shield</h3>';
        result += '<p>Armor: 3</p>'
        result += '<p>Required Str: 2</p>'
        result += '<p><b>Cost: 150 Gold</b></p>'
        break;
    case 'kite_shield':
        result += '<h3>Kite Shield</h3>';
        result += '<p>Armor: 5</p>'
        result += '<p>Required Str: 5</p>'
        result += '<p><b>Cost: 500 Gold</b></p>'
        break;
    case 'leather_cap':
        result += '<h3>Leather Cap</h3>';
        result += '<p>Armor: 1</p>'
        result += '<p><b>Cost: 20 Gold</b></p>'
        break;
    case 'studded_leather_cap':
        result += '<h3>Studded Leather Cap</h3>';
        result += '<p>Armor: 2</p>'
        result += '<p><b>Cost: 55 Gold</b></p>'
        break;
    case 'chainmail_coif':
        result += '<h3>Chainmail Coif</h3>';
        result += '<p>Armor: 4</p>'
        result += '<p>Required Str: 3</p>'
        result += '<p><b>Cost: 200 Gold</b></p>'
        break;
    case 'full_helm':
        result += '<h3>Full Helm</h3>';
        result += '<p>Armor: 7</p>'
        result += '<p>Required Str: 6</p>'
        result += '<p><b>Cost: 650 Gold</b></p>'
        break;
    case 'leather_armor':
        result += '<h3>Leather Armor</h3>';
        result += '<p>Armor: 2</p>'
        result += '<p><b>Cost: 45 Gold</b></p>'
        break;
    case 'studded_leather_armor':
        result += '<h3>Studded Leather Armor</h3>';
        result += '<p>Armor: 4</p>'
        result += '<p>Required Str: 2</p>'
        result += '<p><b>Cost: 145 Gold</b></p>'
        break;
    case 'chainmail_armor':
        result += '<h3>Chainmail Armor</h3>';
        result += '<p>Armor: 7</p>'
        result += '<p>Required Str: 4</p>'
        result += '<p><b>Cost: 400 Gold</b></p>'
        break;
    case 'chest_plate':
        result += '<h3>Chest Plate</h3>';
        result += '<p>Armor: 10</p>'
        result += '<p>Required Str: 8</p>'
        result += '<p><b>Cost: 900 Gold</b></p>'
        break;
    case 'leather_pants':
        result += '<h3>Leather Pants</h3>';
        result += '<p>Armor: 1</p>'
        result += '<p><b>Cost: 25 Gold</b></p>'
        break;
    case 'studded_leather_pants':
        result += '<h3>Studded Leather Pants</h3>';
        result += '<p>Armor: 2</p>'
        result += '<p>Required Str: 1</p>'
        result += '<p><b>Cost: 75 Gold</b></p>'
        break;
    case 'chainmail_breeches':
        result += '<h3>Chainmail Breeches</h3>';
        result += '<p>Armor: 5</p>'
        result += '<p>Required Str: 4</p>'
        result += '<p><b>Cost: 220 Gold</b></p>'
        break;
    case 'plate_legs':
        result += '<h3>Full Plate Leggings</h3>';
        result += '<p>Armor: 8</p>'
        result += '<p>Required Str: 7</p>'
        result += '<p><b>Cost: 600 Gold</b></p>'
        break;
    default:
    break;
    }
    return result;
}

