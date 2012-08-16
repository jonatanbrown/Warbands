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

function generate_weapon_description(title, class_description, class_name, range, damage, cost) {
    result = '';
    result += '<h3>' + title + '</h3>';
    result += '<p>Class: <span class="weapon-class" rel="tooltip" data-original-title="' + class_description + '">' + class_name + '</span></p>'
    result += '<p>Range: ' + range + '</p>'
    result += '<p>Damage: ' + damage + '</p>'
    result += '<p><b>Cost: ' + cost + ' Gold</b></p>'
}

function get_item_description(item) {
    switch(item)
    {
    case 'short_sword':
        generate_weapon_description('Short Sword', Warbands.item_class_descriptions.sword, 'Sword', 'Melee', Warbands.weapon_damage.t1, Warbands.weapon_value.t1)
        break;
    case 'club':
        generate_weapon_description('Club', Warbands.item_class_descriptions.mace, 'Mace', 'Melee', Warbands.weapon_damage.t1, Warbands.weapon_value.t1)
        break;
    case 'small_axe':
        generate_weapon_description('Small Axe', Warbands.item_class_descriptions.axe, 'Axe', 'Melee', Warbands.weapon_damage.t1, Warbands.weapon_value.t1)
        break;
    case 'short_spear':
        generate_weapon_description('Short Spear', Warbands.item_class_descriptions.spear, 'Spear', 'Melee', Warbands.weapon_damage.t1, Warbands.weapon_value.t1)
        break;
    case 'gladius':
        generate_weapon_description('Gladius', Warbands.item_class_descriptions.sword, 'Sword', 'Melee', Warbands.weapon_damage.t2, Warbands.weapon_value.t2)
        break;
    case 'flanged_mace':
        generate_weapon_description('Flanged Mace', Warbands.item_class_descriptions.mace, 'Mace', 'Melee', Warbands.weapon_damage.t2, Warbands.weapon_value.t2)
        break;
    case 'battle_axe':
        generate_weapon_description('Battle Axe', Warbands.item_class_descriptions.axe, 'Axe', 'Melee', Warbands.weapon_damage.t2, Warbands.weapon_value.t2)
        break;
    case 'spetum':
        generate_weapon_description('Spetum', Warbands.item_class_descriptions.spear, 'Spear', 'Melee', Warbands.weapon_damage.t2, Warbands.weapon_value.t2)
        break;
    case 'spatha':
        generate_weapon_description('Spatha', Warbands.item_class_descriptions.sword, 'Sword', 'Melee', Warbands.weapon_damage.t3, Warbands.weapon_value.t3)
        break;
    case 'morning_star':
        generate_weapon_description('Morning Star', Warbands.item_class_descriptions.mace, 'Mace', 'Melee', Warbands.weapon_damage.t3, Warbands.weapon_value.t3)
        break;
    case 'ono':
        generate_weapon_description('Ono', Warbands.item_class_descriptions.axe, 'Axe', 'Melee', Warbands.weapon_damage.t3, Warbands.weapon_value.t3)
        break;
    case 'winged_spear':
        generate_weapon_description('Winged Spear', Warbands.item_class_descriptions.spear, 'Spear', 'Melee', Warbands.weapon_damage.t3, Warbands.weapon_value.t3)
        break;


    case 'throwing_knives':
        generate_weapon_description('Throwing Knives', Warbands.item_class_descriptions.throwing_knives, 'Throwing Knives', 'Ranged', Warbands.weapon_damage.t1, Warbands.weapon_value.t1)
        break;
    case 'javelins':
        generate_weapon_description('Javelins', Warbands.item_class_descriptions.javelins, 'Javelins', 'Ranged', Warbands.weapon_damage.t1, Warbands.weapon_value.t1)
        break;
    case 'throwing_axes':
       generate_weapon_description('Throwing Axes', Warbands.item_class_descriptions.throwing_axes, 'Axe', 'Ranged', Warbands.weapon_damage.t1, Warbands.weapon_value.t1)
        break;
    case 'razor_darts':
       generate_weapon_description('Razor Darts', Warbands.item_class_descriptions.throwing_knives, 'Throwing Knives', 'Ranged', Warbands.weapon_damage.t2, Warbands.weapon_value.t2)
        break;
    case 'pilum':
       generate_weapon_description('Pilum', Warbands.item_class_descriptions.javelins, 'Javelins', 'Ranged', Warbands.weapon_damage.t2, Warbands.weapon_value.t2)
        break;
    case 'francisca':
       generate_weapon_description('Francisca', Warbands.item_class_descriptions.throwing_axes, 'Axe', 'Ranged', Warbands.weapon_damage.t2, Warbands.weapon_value.t2)
        break;
    case 'trombash':
       generate_weapon_description('Trombash', Warbands.item_class_descriptions.throwing_knives, 'Throwing Knives', 'Ranged', Warbands.weapon_damage.t3, Warbands.weapon_value.t3)
        break;
    case 'verutum':
       generate_weapon_description('Verutum', Warbands.item_class_descriptions.javelins, 'Javelins', 'Ranged', Warbands.weapon_damage.t3, Warbands.weapon_value.t3)
        break;
    case 'hurlbat':
       generate_weapon_description('Hurlbat', Warbands.item_class_descriptions.throwing_axes, 'Axe', 'Ranged', Warbands.weapon_damage.t3, Warbands.weapon_value.t3)
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

