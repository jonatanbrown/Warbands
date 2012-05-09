class Battle
  include Mongoid::Document

  belongs_to :user

  field :opponent

  field :actions

  field :result, :type => Integer

  field :turn, :type => Integer, :default => 1

  def self.resolve_turn(battle1, battle2)

    turn_events = ""

    team1 = battle1.user.team
    team2 = battle2.user.team

    action_list = []

    action_list += add_actions_to_list(battle1, team2)
    action_list += add_actions_to_list(battle2, team1)

    action_list = sort_order(action_list)

    action_list.each do |a|
      turn_events += resolve_action(a)
    end

    check_if_lost(team1, team2)
    check_if_lost(team2, team1)

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
    char = Character.find(action['char']._id)
    target = Character.find(action['target']['team'].get_char(action['target']['pos'])._id)
    result = ''

    if char.active
      case action['skill']

      #Retreat
      when '3'
        char.update_attribute(:active, false)
        result += "<p>#{char.name} has retreated from combat.</p>"
      end
    end

    if char.active and target.active
      case action['skill']
      #Strike
      when '1'
        damage = 20
        target.current_hp -= damage
        result += "<p>#{char.name} strikes #{target.name} for <span class='red'>#{damage}</span> damage.</p>"
        target.active = target.is_active?
        if !target.active
          result += "<p>#{target.name} has been knocked out!</p>"
        end
        target.save
      #Throw
      when '2'
        damage = 7
        target.current_hp -= damage
        result += "<p>#{char.name} throws a stone at #{target.name} for <span class='red'>#{damage}</span> damage.</p>"
        target.active = target.is_active?
        if !target.active
          result += "<p>#{target.name} has been knocked out!</p>"
        end
        target.save
      end
    end

    result
  end

  def self.check_if_lost(team, op_team)
    if !team.characters.where(:active => true).any?
      team.user.battle.update_attribute(:result, BATTLE_LOST)
      op_team.user.battle.update_attribute(:result, BATTLE_WON)
    end
  end

end

