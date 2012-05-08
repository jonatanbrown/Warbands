class Battle
  include Mongoid::Document

  belongs_to :user

  field :opponent

  field :actions

  def self.resolve_turn(battle1, battle2)

    team1 = battle1.user.team
    team2 = battle2.user.team

    team1_chars = team1.characters
    team2_chars = team2.characters

    action_list = []

    action_list += add_actions_to_list(battle1, team2)
    action_list += add_actions_to_list(battle2, team1)

    action_list = sort_order(action_list)

    turn_events = ""

    action_list.each do |a|
      turn_events += resolve_action(a)
    end

    turn_events

  end

  private

  def self.add_actions_to_list(battle, target_team)
    list = []
    if battle.actions
      battle.actions.each do |pos, actions|
        char = battle.user.team.get_char(pos.to_i)
        actions.each do |num, action|
          list.push({"target" => {"team" => target_team, "pos" => action['target']}, "skill" => action['action'],"char" => char, "prio" => char.get_priority})
        end
      end
    end
    list
  end

  def self.sort_order(list)
    list.sort {|x, y| y['prio'] <=> x['prio']}
  end

  def self.resolve_action(action)
    char = action['char']
    target = action['target']['team'].get_char(action['target']['pos'])
    result = ''
    if char.active and target.active
      puts "#{char.name} is using #{Constant.get_skill_name(action['skill'].to_i)} on #{target.name} at prio #{action['prio']}"
      case action['skill']
      when '1'
        damage = 5
        target.current_hp -= damage
        result += "<p>#{char.name} strikes #{target.name} for #{damage} damage.</p>"
        target.active = target.is_active?
        if !target.active
          result += "<p>#{target.name} has been knocked out!</p>"
        end
        target.save
      when '2'
        damage = 7
        target.current_hp -= damage
        result += "<p>#{char.name} throws a stone at #{target.name} for #{damage} damage.</p>"
        target.active = target.is_active?
        if !target.active
          result += "<p>#{target.name} has been knocked out!</p>"
        end
        target.save
      end
    end
    result
  end

end

#Action is
#{"target"=>{"team"=>1, "pos"=>"2"}, "skill"=>"1", "char"=>#<Character _id: 4fa020f247911507ca000022, _type: nil, team_id: BSON::ObjectId('4fa020f247911507ca00001d'), name: "FF 5", str: 10, dex: 7, tgh: 13, ini: 19, int: 12, mem: 5, ap: 9, strike: 6, thrown: 6, projectile: 3, dodge: 9, block: 8, poison: 7, dirt: 1, defensive: 3, destructive: 4, buffs: 9, debuffs: 10, position: 4>, "prio"=>19}

#Action is
#{"target"=>{"team"=>2, "pos"=>"2"}, "skill"=>"2", "char"=>#<Character _id: 4fa020e247911507ca000016, _type: nil, team_id: BSON::ObjectId('4fa020e247911507ca000015'), name: "C 1", str: 11, dex: 7, tgh: 14, ini: 10, int: 11, mem: 7, ap: 11, strike: 4, thrown: 10, projectile: 10, dodge: 7, block: 2, poison: 10, dirt: 6, defensive: 9, destructive: 7, buffs: 1, debuffs: 3, position: 0>, "prio"=>10}

