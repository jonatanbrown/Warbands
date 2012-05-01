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

    action_list += add_actions_to_list(battle1)
    action_list += add_actions_to_list(battle2)

    puts "ACTION LIST"
    puts action_list

  end

  private

  def self.add_actions_to_list(battle)
    list = []
    battle.actions.each do |pos, actions|
      char = battle.user.team.get_char(pos.to_i)
      actions.each do |num, action|
        list.push([action, char, char.get_priority])
      end
    end
    list
  end

end

#Battle 1
#<Battle _id: 4fa0280447911507ca000034, _type: nil, user_id: BSON::ObjectId('4fa020df47911507ca000014'), opponent: BSON::ObjectId('4fa020f047911507ca00001c'), actions: {"pos0"=>{"0"=>{"action"=>"1", "target"=>"0"}, "1"=>{"action"=>"2", "target"=>"2"}}, "pos1"=>{"0"=>{"action"=>"2", "target"=>"2"}}}>
#Battle 2
#<Battle _id: 4fa0280547911507ca000035, _type: nil, user_id: BSON::ObjectId('4fa020f047911507ca00001c'), opponent: BSON::ObjectId('4fa020df47911507ca000014'), actions: {"pos0"=>{"0"=>{"action"=>"2", "target"=>"1"}}, "pos1"=>{"0"=>{"action"=>"2", "target"=>"1"}}, "pos2"=>{"0"=>{"action"=>"2", "target"=>"2"}}}>

