$(document).ready(function() {
    $(".item-button").on("mouseover", function(event) {
        result = get_item_description($(this).attr('data-item'));
        $("#smithy-item-view").html(result);
        $(".weapon-class").tooltip({placement: 'right'})
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

    $('.smithy-tab').on('click', function() {
        $("#smithy-item-view").html('');
    })

    $(".buy-item-button").tooltip({placement: 'right'})
});

function get_item_description(item) {
    result = '';
    switch(item)
    {
    case 'short_sword':
        result += '<h3>Short Sword</h3>';
        result += '<p>Class: <span class="weapon-class" rel="tooltip" data-original-title="Swords give a 5% chance to parry melee attacks.">Sword</span></p>'
        result += '<p>Range: Melee</p>'
        result += '<p>Damage: 4-8</p>'
        result += '<p><b>Cost: ' + get_item_cost(item) + ' Gold</b></p>'
        break;
    case 'club':
        result += '<h3>Club</h3>';
        result += '<p>Class: <span class="weapon-class" rel="tooltip" data-original-title="Maces give a 5% chance to stun the opponent, negating their next action.">Mace</span></p>'
        result += '<p>Range: Melee</p>'
        result += '<p>Damage: 4-8</p>'
        result += '<p><b>Cost: ' + get_item_cost(item) + ' Gold</b></p>'
        break;
    case 'small_axe':
        result += '<h3>Small Axe</h3>';
        result += '<p>Class: <span class="weapon-class" rel="tooltip" data-original-title="Axes give a 5% chance to cause the opponent to bleed, causing damage over time.">Axe</span></p>'
        result += '<p>Range: Melee</p>'
        result += '<p>Damage: 4-8</p>'
        result += '<p><b>Cost: ' + get_item_cost(item) + ' Gold</b></p>'
        break;
    case 'short_spear':
        result += '<h3>Short Spear</h3>';
        result += '<p>Class: <span class="weapon-class" rel="tooltip" data-original-title="Spears give a 10% bonus to Initiative of weapon based attacks.">Spear</span></p>'
        result += '<p>Range: Melee</p>'
        result += '<p>Damage: 4-8</p>'
        result += '<p><b>Cost: ' + get_item_cost(item) + ' Gold</b></p>'
        break;
    case 'throwing_knives':
        result += '<h3>Throwing Knives</h3>';
        result += '<p>Class: <span class="weapon-class" rel="tooltip" data-original-title="Knives give a 10% bonus to Initiative of weapon based attacks.">Knife</span></p>'
        result += '<p>Range: Ranged</p>'
        result += '<p>Damage: 4-8</p>'
        result += '<p><b>Cost: ' + get_item_cost(item) + ' Gold</b></p>'
        break;
    case 'javelins':
        result += '<h3>Javelins</h3>';
        result += '<p>Class: <span class="weapon-class" rel="tooltip" data-original-title="Javelins reduce chance of missing with weapon based attacks by 10%.">Javelin</span></p>'
        result += '<p>Range: Ranged</p>'
        result += '<p>Damage: 4-8</p>'
        result += '<p><b>Cost: ' + get_item_cost(item) + ' Gold</b></p>'
        break;
    case 'throwing_axes':
        result += '<h3>Throwing Axes</h3>';
        result += '<p>Class: <span class="weapon-class" rel="tooltip" data-original-title="Axes give a 5% chance to cause the opponent to bleed, causing damage over time.">Axe</span></p>'
        result += '<p>Range: Ranged</p>'
        result += '<p>Damage: 4-8</p>'
        result += '<p><b>Cost: ' + get_item_cost(item) + ' Gold</b></p>'
        break;
    case 'buckler':
        result += '<h3>Buckler</h3>';
        result += '<p>Armor: 2</p>'
        result += '<p><b>Cost: ' + get_item_cost(item) + ' Gold</b></p>'
        break;
    case 'small_shield':
        result += '<h3>Small Shield</h3>';
        result += '<p>Armor: 3</p>'
        result += '<p>Required Str: 2</p>'
        result += '<p><b>Cost: ' + get_item_cost(item) + ' Gold</b></p>'
        break;
    case 'kite_shield':
        result += '<h3>Kite Shield</h3>';
        result += '<p>Armor: 5</p>'
        result += '<p>Required Str: 5</p>'
        result += '<p><b>Cost: ' + get_item_cost(item) + ' Gold</b></p>'
        break;
    case 'leather_cap':
        result += '<h3>Leather Cap</h3>';
        result += '<p>Armor: 1</p>'
        result += '<p><b>Cost: ' + get_item_cost(item) + ' Gold</b></p>'
        break;
    case 'studded_leather_cap':
        result += '<h3>Studded Leather Cap</h3>';
        result += '<p>Armor: 2</p>'
        result += '<p><b>Cost: ' + get_item_cost(item) + ' Gold</b></p>'
        break;
    case 'chainmail_coif':
        result += '<h3>Chainmail Coif</h3>';
        result += '<p>Armor: 4</p>'
        result += '<p>Required Str: 3</p>'
        result += '<p><b>Cost: ' + get_item_cost(item) + ' Gold</b></p>'
        break;
    case 'full_helm':
        result += '<h3>Full Helm</h3>';
        result += '<p>Armor: 7</p>'
        result += '<p>Required Str: 6</p>'
        result += '<p><b>Cost: ' + get_item_cost(item) + ' Gold</b></p>'
        break;
    case 'leather_armor':
        result += '<h3>Leather Armor</h3>';
        result += '<p>Armor: 2</p>'
        result += '<p><b>Cost: ' + get_item_cost(item) + ' Gold</b></p>'
        break;
    case 'studded_leather_armor':
        result += '<h3>Studded Leather Armor</h3>';
        result += '<p>Armor: 4</p>'
        result += '<p>Required Str: 2</p>'
        result += '<p><b>Cost: ' + get_item_cost(item) + ' Gold</b></p>'
        break;
    case 'chainmail_armor':
        result += '<h3>Chainmail Armor</h3>';
        result += '<p>Armor: 7</p>'
        result += '<p>Required Str: 4</p>'
        result += '<p><b>Cost: ' + get_item_cost(item) + ' Gold</b></p>'
        break;
    case 'chest_plate':
        result += '<h3>Chest Plate</h3>';
        result += '<p>Armor: 10</p>'
        result += '<p>Required Str: 8</p>'
        result += '<p><b>Cost: ' + get_item_cost(item) + ' Gold</b></p>'
        break;
    case 'leather_pants':
        result += '<h3>Leather Pants</h3>';
        result += '<p>Armor: 1</p>'
        result += '<p><b>Cost: ' + get_item_cost(item) + ' Gold</b></p>'
        break;
    case 'studded_leather_pants':
        result += '<h3>Studded Leather Pants</h3>';
        result += '<p>Armor: 2</p>'
        result += '<p>Required Str: 1</p>'
        result += '<p><b>Cost: ' + get_item_cost(item) + ' Gold</b></p>'
        break;
    case 'chainmail_breeches':
        result += '<h3>Chainmail Breeches</h3>';
        result += '<p>Armor: 5</p>'
        result += '<p>Required Str: 4</p>'
        result += '<p><b>Cost: ' + get_item_cost(item) + ' Gold</b></p>'
        break;
    case 'plate_legs':
        result += '<h3>Full Plate Leggings</h3>';
        result += '<p>Armor: 8</p>'
        result += '<p>Required Str: 7</p>'
        result += '<p><b>Cost: ' + get_item_cost(item) + ' Gold</b></p>'
        break;
    default:
    break;
    }
    return result;
}

function get_item_cost(item){
    result = '';
    switch(item)
    {
    case 'short_sword':
        result = 35
        break;
    case 'club':
        result = 35
        break;
    case 'small_axe':
        result = 35
        break;
    case 'short_spear':
        result = 35
        break;
    case 'throwing_knives':
        result = 35
        break;
    case 'javelins':
        result = 35
        break;
    case 'throwing_axes':
        result = 35
        break;
    case 'buckler':
        result = 40
        break;
    case 'small_shield':
        result = 150
        break;
    case 'kite_shield':
        result = 500
        break;
    case 'leather_cap':
        result = 20
        break;
    case 'studded_leather_cap':
        result = 55
        break;
    case 'chainmail_coif':
        result = 200
        break;
    case 'full_helm':
        result = 650
        break;
    case 'leather_armor':
        result = 45
        break;
    case 'studded_leather_armor':
        result = 145
        break;
    case 'chainmail_armor':
        result = 400
        break;
    case 'chest_plate':
        result = 900
        break;
    case 'leather_pants':
        result = 25
        break;
    case 'studded_leather_pants':
        result = 75
        break;
    case 'chainmail_breeches':
        result = 220
        break;
    case 'plate_legs':
        result = 600
        break;
    default:
    break;
    }
    return result;
}

