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

    action_list += add_actions_to_list(battle1, team2, team1)
    action_list += add_actions_to_list(battle2, team1, team2)

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

  def self.add_actions_to_list(battle, op_team, cur_team)
    list = []
    if battle.actions
      battle.actions.each do |pos, actions|
        char = battle.user.team.get_char(pos.to_i)
        index = 0
        actions.each do |num, action|
          list.push({"target" => {"team" => action['friendly'] == 'true' ? cur_team : op_team, "pos" => action['target']}, "skill" => action['action'],"char" => char, "prio" => char.get_priority(index, action['action'].to_i)})
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
        char.effects << [EFFECT_DEFENSIVE_POSTURE, 1, nil, nil]
        char.save
        result += "<p>#{char.name} takes on a defensive posture.</p>"

      #Cover
      when '5'
        char.effects << [EFFECT_COVER, 1, nil, nil]
        char.save
        result += "<p>#{char.name} takes cover.</p>"

      #Shield Wall
      when '11'
        char.effects << [EFFECT_SHIELD_WALL, 1, nil, nil]
        char.save
        result += "<p>#{char.name} forms a shield wall.</p>"

      end
    end

    if char.active and target and target.active
      case action['skill']
      #Strike
      when '0'

        hit = true

        if new_target = target.is_protected?
          result += "<p>#{new_target.name} protects #{target.name} and takes the hit from #{char.name}</p>"
          target = new_target
        end

        if target.melee_dodge?
          hit = false
          result += "<p>#{char.name} strikes at #{target.name} but #{target.name} gets out of the way.</p>"
          result += check_counterstrike(char, target)
        end

        if hit and target.defensive_posture_dodge?
          hit = false
          result += "<p>#{char.name} strikes at #{target.name} but #{target.name}'s defensive posture allows a dodge.</p>"
          result += check_counterstrike(char, target)
        end

        if hit
          damage = (rand(4..8) + ((char.final_str + char.strike)/2.0)).round(0)
          damage -= (target.final_tgh/2.0).round(0)

          if damage < 0
            damage = 0
          end
          target.current_hp -= damage

          result += "<p>#{char.name} strikes #{target.name} for <span class='red'>#{damage}</span> damage.</p>"

          result += target.check_knockout
        end

      #Throw
      when '1'

        hit = true
        result_set = false

        hit = char.ranged_hit?(1)

        targetability = target.team.position_targetability_ranged(target.position)
        hit = penalty_roll_miss?(targetability)

        if waller = target.behind_shield_wall?
          result += "<p>#{char.name} throws a stone at #{target.name} but #{target.name} is protected by a shield wall from #{waller}.</p>"
          result_set = true
          hit = false
        end

        if (target.effects.map {|x| x[0] }).include?(EFFECT_SHIELD_WALL) and target.shield_wall_successful?
          result += "<p>#{char.name} throws a stone at #{target.name} but #{target.name} has a shield wall up.</p>"
          hit = false
          result_set = true
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

          result += target.check_knockout

        elsif !result_set
          result += "<p>#{char.name} throws a stone at #{target.name} but misses.</p>"
        end
      #Kick Dirt
      when '3'

        hit = true
        result_set = false

        hit = char.ranged_hit?(3)

        targetability = target.team.position_targetability_ranged(target.position)
        hit = penalty_roll_miss?(targetability)

        if waller = target.behind_shield_wall?
          result += "<p>#{char.name} kicks dirt at #{target.name} but #{target.name} is protected by a shield wall from #{waller}.</p>"
          result_set = true
          hit = false
        end

        if (target.effects.map {|x| x[0] }).include?(EFFECT_SHIELD_WALL) and target.shield_wall_successful?
          result += "<p>#{char.name} kicks dirt at #{target.name} but #{target.name} has a shield wall up.</p>"
          hit = false
          result_set = true
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
          target.effects << [EFFECT_BLINDED, duration, nil, nil]
          target.save
          result += "<p>#{char.name} throws dirt into the eyes of #{target.name}. <span class='red'>#{target.name} is blinded!</p></span>"
        elsif !result_set
          result += "<p>#{char.name} attempts to throw dirt into the eyes of #{target.name} but misses.</p>"
        end

      #Quick Strike
      when '6'
        hit = true

        if new_target = target.is_protected?
          result += "<p>#{new_target.name} protects #{target.name} and takes the hit from #{char.name}</p>"
          target = new_target
        end

        if target.melee_dodge?
          hit = false
          result += "<p>#{char.name} quickly strikes at #{target.name} but #{target.name} gets out of the way.</p>"
          result += check_counterstrike(char, target)
        end

        if hit and target.defensive_posture_dodge?
          hit = false
          result += "<p>#{char.name} does a quick strike at #{target.name} but #{target.name}'s defensive posture allows a dodge.</p>"
          result += check_counterstrike(char, target)
        end

        if hit
          damage = ((rand(4..8) + ((char.final_str + char.quick_strike)/2.0)) * 0.8).round(0)
          damage -= (target.final_tgh/2.0).round(0)

          if damage < 0
            damage = 0
          end

          target.current_hp -= damage

          result += "<p>#{char.name} quickly strikes #{target.name} for <span class='red'>#{damage}</span> damage.</p>"

          result += target.check_knockout
        end

      #Heavy Strike
      when '7'
        hit = true

        if new_target = target.is_protected?
          result += "<p>#{new_target.name} protects #{target.name} and takes the hit from #{char.name}</p>"
          target = new_target
        end

        if target.melee_dodge?
          hit = false
          result += "<p>#{char.name} does a heavy strike at #{target.name} but #{target.name} gets out of the way.</p>"
          result += check_counterstrike(char, target)
        end

        if hit and target.defensive_posture_dodge?
          hit = false
          result += "<p>#{char.name} does a heavy strike at #{target.name} but #{target.name}'s defensive posture allows a dodge.</p>"
          result += check_counterstrike(char, target)
        end

        if hit
          damage = ((rand(4..8) + ((char.final_str + char.heavy_strike)/2.0)) * 1.2).round(0)
          damage -= (target.final_tgh/2.0).round(0)

          if damage < 0
            damage = 0
          end

          target.current_hp -= damage

          result += "<p>#{char.name} does a heavy strike at #{target.name} for <span class='red'>#{damage}</span> damage.</p>"

          result += target.check_knockout
        end

      #Accurate Strike
      when '8'

        if new_target = target.is_protected?
          result += "<p>#{new_target.name} protects #{target.name} and takes the hit from #{char.name}</p>"
          target = new_target
        end

        damage = (rand(4..8) + ((char.final_str + char.accurate_strike)/2.0)).round(0)
        damage -= (target.final_tgh/2.0).round(0)

        if damage < 0
          damage = 0
        end

        target.current_hp -= damage

        result += "<p>#{char.name} does an accurate strike at #{target.name} for <span class='red'>#{damage}</span> damage.</p>"

        result += target.check_knockout

      #Finishing Strike
      when '9'
        hit = true

        if new_target = target.is_protected?
          result += "<p>#{new_target.name} protects #{target.name} and takes the hit from #{char.name}</p>"
          target = new_target
        end

        if target.melee_dodge?
          hit = false
          result += "<p>#{char.name} does a finishing strike at #{target.name} but #{target.name} gets out of the way.</p>"
          result += check_counterstrike(char, target)
        end

        if hit and target.defensive_posture_dodge?
          hit = false
          result += "<p>#{char.name} does a finishing strike at #{target.name} but #{target.name}'s defensive posture allows a dodge.</p>"
          result += check_counterstrike(char, target)
        end

        if hit
          damage = ((rand(4..8) + ((char.final_str + char.finishing_strike)/2.0)) * 1.7).round(0)
          damage -= (target.final_tgh/2.0).round(0)

          if damage < 0
            damage = 0
          end
          target.current_hp -= damage

          result += "<p>#{char.name} does a finishing strike at #{target.name} for <span class='red'>#{damage}</span> damage.</p>"

          result += target.check_knockout
        end

      #Protect
      when '10'
        target.effects << [EFFECT_PROTECTED, 1, nil, char._id]
        target.save
        result += "<p>#{char.name} protects #{target.name}.</p>"
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

  def self.penalty_roll_miss?(targetability)
    if targetability == 1 and rand(1..4) > 3
      return false
    elsif targetability == 2 and rand(1..4) > 2
      return false
    end
    true
  end

  def self.check_counterstrike(char, target)
    cs_damage = target.counterstrike_damage(char)
    result = ''
    if cs_damage
      result = "<p>#{target.name} counterstrikes #{char.name} for <span class='red'>#{cs_damage}</span> damage.</p>"
      char.current_hp -= cs_damage
      result += char.check_knockout
    end
    result
  end

end

