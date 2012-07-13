class Battle
  include Mongoid::Document

  belongs_to :user

  field :opponent

  field :actions

  field :result, :type => Integer, :default => 0

  field :turn, :type => Integer, :default => 1

  field :submitted, :type => Boolean

  field :formation, :type => Integer, :default => 0

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

    all_chars = team1.characters + team2.characters

    all_chars.each do |char|
      char.effects.delete_if do |effect|
        effect[1] -= 1
        effect[1] <= 0
      end
      char.save
    end

    turn_events

  end

  private

  def self.add_actions_to_list(battle, target_team)
    list = []
    if battle.actions
      battle.actions.each do |pos, actions|
        char = battle.user.team.get_char(pos.to_i)
        index = 0
        actions.each do |num, action|
          list.push({"target" => {"team" => target_team, "pos" => action['target']}, "skill" => action['action'],"char" => char, "prio" => char.get_priority(index)})
          index += 1
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
    if action['target']['pos'] != 'null'
      target = Character.find(action['target']['team'].get_char(action['target']['pos'])._id)
    else
      target = nil
    end

    result = ''

    if char.active
      case action['skill']

      #Retreat
      when '2'
        char.update_attribute(:active, false)
        result += "<p>#{char.name} has retreated from combat.</p>"

      #Defensive Posture
      when '4'
        char.effects << [EFFECT_DEFENSIVE_POSTURE, 1, nil]
        char.save
        result += "<p>#{char.name} takes on a defensive posture.</p>"

      #Cover
      when '5'
        char.effects << [EFFECT_COVER, 1, nil]
        char.save
        result += "<p>#{char.name} takes cover.</p>"
      end
    end

    if char.active and target and target.active
      case action['skill']
      #Strike
      when '0'

        hit = true
        result_set = false

        if rand(1..100) <= (100*target.final_dex)/(100+target.final_dex)
          hit = false
        end

        if (target.effects.map {|x| x[0] }).include?(EFFECT_DEFENSIVE_POSTURE) and rand(1..10) <= 3
          result += "<p>#{char.name} strikes at #{target.name} but #{target.name}'s defensive posture allows a dodge.</p>"
          hit = false
          result_set = true
        end

        if
          damage = rand(4..8) + ((char.final_str + char.strike)/2.0).round(0) - (target.final_tgh/2.0).round(0)
          if damage < 0
            damage = 0
          end
          target.current_hp -= damage

          result += "<p>#{char.name} strikes #{target.name} for <span class='red'>#{damage}</span> damage.</p>"
          target.active = target.is_active?
          if !target.active
            result += "<p>#{target.name} has been knocked out!</p>"
          end
          target.save
        elsif !result_set
          result += "<p>#{char.name} strikes at #{target.name} but #{target.name} gets out of the way.</p>"
        end

      #Throw
      when '1'

        hit = true
        result_set = false

        if rand(1..100) > (100*(char.final_dex + char.thrown))/(5+(char.final_dex + char.thrown))
          hit = false
        end

        targetability = target.team.position_targetability_ranged(target.position)
        if targetability == 1
          if rand(1..4) > 3
            hit = false
          end
        elsif targetability == 2
          if rand(1..4) > 2
            hit = false
          end
        end

        #Check if char has cover and there are chars in front.
        if (target.effects.map {|x| x[0] }).include?(EFFECT_COVER)
          if target.team.position_targetability_ranged(target.position) != NO_PENALTY
            hit = false
            result_set = true
            result += "<p>#{char.name} throws a stone at #{target.name} but #{target.name} has taken cover.</p>"
          elsif hit
            result += "<p>#{target.name} attempts to take cover from #{char.name}'s attack but there is no one to hide behind!</p>"
          end
        end

        if hit
          damage = rand(4..8) + ((char.final_str + char.thrown)/4.0).round(0) + ((char.final_dex + char.thrown)/4.0).round(0) - (target.final_tgh/2.0).round(0)
          if damage < 0
            damage = 0
          end
          target.current_hp -= damage
          result += "<p>#{char.name} throws a stone at #{target.name} for <span class='red'>#{damage}</span> damage.</p>"
          target.active = target.is_active?
          if !target.active
            result += "<p>#{target.name} has been knocked out!</p>"
          end
          target.save
        elsif !result_set
          result += "<p>#{char.name} throws a stone at #{target.name} but misses.</p>"
        end
      #Kick Dirt
      when '3'

        hit = true
        result_set = false

        if rand(1..100) > (100*(char.final_dex + char.dirt))/(5+(char.final_dex + char.dirt))
          hit = false
        end

        targetability = target.team.position_targetability_ranged(target.position)
        if targetability == 1
          if rand(1..4) > 3
            hit = false
          end
        elsif targetability == 2
          if rand(1..4) > 2
            hit = false
          end
        end

        #Check if char has cover and there are chars in front.
        if (target.effects.map {|x| x[0] }).include?(EFFECT_COVER)
          if target.team.position_targetability_ranged(target.position) != NO_PENALTY
            hit = false
            result_set = true
            result += "<p>#{char.name} throws dirt at #{target.name} but #{target.name} has taken cover.</p>"
          elsif hit
            result += "<p>#{target.name} attempts to take cover from #{char.name}'s attack but there is no one to hide behind!</p>"
          end
        end

        if hit
          duration = rand(2..4)
          target.effects << [EFFECT_BLINDED, duration, nil]
          target.save
          result += "<p>#{char.name} throws dirt into the eyes of #{target.name}. <span class='red'>#{target.name} is blinded!</p></span>"
        elsif !result_set
          result += "<p>#{char.name} attempts to throw dirt into the eyes of #{target.name} but misses.</p>"
        end
      end
    end

    result
  end

  def self.check_if_lost(team, op_team)
    if !team.characters.where(:active => true).any?
      team.user.battle.update_attribute(:result, BATTLE_LOST)
      team.update_attribute(:points, team.points - 1)
      op_team.user.battle.update_attribute(:result, BATTLE_WON)
      op_team.update_attribute(:points, op_team.points + 1)
    end
  end

  def self.validate_actions(char_actions, team, op_team)
    if char_actions
      char_actions.each do |pos, actions|
        char = team.get_char(pos.to_i)
        total_ap = char.ap
        actions.each do |num, action|
          #Check if char can use action
          unless char.action_available?(action['action'].to_i)
            return false
          end
          if Constant.get_skill_targeting(action['action'].to_i) == MELEE
            #Check if char is in melee range
            unless team.position_targetability_melee(pos.to_i)
              return false
            end
            #Check if target is in melee range
            unless op_team.position_targetability_melee(action['target'].to_i)
              return false
            end
          end
          total_ap -= Constant.get_skill_ap(action['action'].to_i)
        end
        #Check if AP adds up
        if total_ap < 0
          return false
        end
      end
    else
      true
    end
  end
end

