class BattleSync
  include Mongoid::Document

  has_many :users

  field :state, :type => String, :default => 'orders'

  field :submit_count, :type => Integer, :default => 0

  field :turn_events, :type => String, :default => ""

  field :turn, :type => Integer, :default => 1

  field :submit_time, :type => Time

  field :pvp, :type => Boolean, :default => true

  def seconds_since_submit
    if submit_time
      (Time.now - submit_time).to_i
    else
      -1
    end
  end

  def self.perform(bs_id)

    #DEBUG
    puts "################################################################"
    puts "Performing turn resolution"
    puts Time.now
    puts "################################################################"

    bs = BattleSync.find(bs_id)
    battle = bs.users[0].battle
    if bs.pvp
      op_battle = bs.users[1].battle
      turn_events = Battle.resolve_turn(battle, op_battle)
    else
      turn_events = Battle.resolve_turn(battle, nil)
    end
    #DEBUG
    puts "################################################################"
    puts "Resolution performed"
    puts Time.now
    puts "################################################################"
    bs.update_attributes(submit_count: 0, state: 'orders', turn_events: turn_events, turn: bs.turn + 1, submit_time: nil)
    #DEBUG
    puts "################################################################"
    puts "Updated BattleSync attributes"
    puts Time.now
    puts "################################################################"
  end

end

