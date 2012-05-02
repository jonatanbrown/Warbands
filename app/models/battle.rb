class Battle
  include Mongoid::Document

  belongs_to :user

  field :opponent

  field :actions

  def self.resolve_turn(battle1, battle2)

    team1_chars = battle1.user.team.characters
    team2_chars = battle2.user.team.characters

    puts "Team chars"
    puts team1_chars
    puts team2_chars

    action_list = []

    action_list += add_actions_to_list(battle1, 1)
    action_list += add_actions_to_list(battle2, 2)

    action_list = sort_order(action_list)

    action_list.each do |a|
      resolve_action(a)
    end

  end

  private

  def self.add_actions_to_list(battle, team_nr)
    list = []
    battle.actions.each do |pos, actions|
      char = battle.user.team.get_char(pos.to_i)
      actions.each do |num, action|
        list.push({"target" => {"team" => (team_nr.divmod(2)[1] + 1), "pos" => action['target']}, "skill" => action['action'],"char" => char, "prio" => char.get_priority})
      end
    end
    list
  end

  def self.sort_order(list)
    list.sort {|x, y| y['prio'] <=> x['prio']}
  end

  def self.resolve_action(action)
    puts "Action is"
    puts action
  end

end

#Action is
#{"target"=>{"team"=>1, "pos"=>"2"}, "skill"=>"1", "char"=>#<Character _id: 4fa020f247911507ca000022, _type: nil, team_id: BSON::ObjectId('4fa020f247911507ca00001d'), name: "FF 5", str: 10, dex: 7, tgh: 13, ini: 19, int: 12, mem: 5, ap: 9, strike: 6, thrown: 6, projectile: 3, dodge: 9, block: 8, poison: 7, dirt: 1, defensive: 3, destructive: 4, buffs: 9, debuffs: 10, position: 4>, "prio"=>19}

i83y4ki83y4k
#Action is
#{"target"=>{"team"=>2, "pos"=>"2"}, "skill"=>"2", "char"=>#<Character _id: 4fa020e247911507ca000016, _type: nil, team_id: BSON::ObjectId('4fa020e247911507ca000015'), name: "C 1", str: 11, dex: 7, tgh: 14, ini: 10, int: 11, mem: 7, ap: 11, strike: 4, thrown: 10, projectile: 10, dodge: 7, block: 2, poison: 10, dirt: 6, defensive: 9, destructive: 7, buffs: 1, debuffs: 3, position: 0>, "prio"=>10}

