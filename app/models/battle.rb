class Battle
  include Mongoid::Document

  belongs_to :user

  field :opponent

  field :actions

  field :result, :type => Integer, :default => 0

  field :turn, :type => Integer, :default => 1

  field :submitted, :type => Boolean

  field :formation, :type => Integer, :default => 0

  field :learning_results, :type => String

  def self.resolve_turn(battle1, battle2)

    turn_events = ""

    team1 = battle1.user.team
    team2 = battle2.user.team

    active_chars = team1.characters.where(:active => true) + team2.characters.where(:active => true)

    action_list = []

    action_list += add_actions_to_list(battle1, team2, team1)
    action_list += add_actions_to_list(battle2, team1, team2)

    action_list = sort_order(action_list)

    #Do pre-action combat events.
    active_chars.each do |char|
      char.effects.each do |effect|
        if effect[0] == EFFECT_BLEEDING
          damage = rand(2..4)
          char.current_hp -= damage
          turn_events += "<p>#{char.name} bleeds for <span class='red'>#{damage}</span> damage.</p>"
          turn_events += char.check_knockout
        end
      end
    end

    action_list.each do |a|
      turn_events += resolve_action(a)
    end

    if rand(0..1) == 0
      lost = check_if_lost(team1, team2)
      unless lost
        check_if_lost(team2, team1)
      end
    else
      lost = check_if_lost(team2, team1)
      unless lost
        check_if_lost(team1, team2)
      end
    end

    active_chars = team1.characters.where(:active => true) + team2.characters.where(:active => true)

    active_chars.each do |char|
      char.effects.delete_if do |effect|
        effect[1] -= 1
        effect[1] <= 0
      end

      if char.skill_available?(SKILL_UNDISTURBED) and !char.taken_damage
        if char.skill_roll_successful?(SKILL_UNDISTURBED)
          char.effects << [EFFECT_UNDISTURBED, 1, nil, nil]
          char.roll_learning(SKILL_UNDISTURBED)
          turn_events += "<p>#{char.name} is undisturbed and his speed <span class='green'>increases</span> for the next turn.</p>"
        else
          turn_events += "<p>#{char.name} is undisturbed but <span class='red'>fails</span> to read the situation correctly.</p>"
        end
      end

      char.taken_damage = false
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

    stunned = false
    char.effects.delete_if do |effect|
      if effect[0] == EFFECT_STUNNED
        stunned = true
        true
      else
        false
      end
    end

    #If stunned, ignore action completely.
    if stunned
      char.save
      return "<p>#{char.name} was incapacitated and took some time to recover.</p>"
    end

    if char.active
      case action['skill']

      #Retreat
      when '2'
        char.update_attribute(:active, false)
        result += "<p>#{char.name} has retreated from combat.</p>"

      #Defensive Posture
      when '4'
        char.effects << [EFFECT_DEFENSIVE_POSTURE, 1, nil, nil]
        char.roll_learning(SKILL_DEFENSIVE_POSTURE)
        char.save
        result += "<p>#{char.name} takes on a defensive posture.</p>"

      #Cover
      when '5'
        char.effects << [EFFECT_COVER, 1, nil, nil]
        char.roll_learning(SKILL_COVER)
        char.save
        result += "<p>#{char.name} takes cover.</p>"

      #Shield Wall
      when '11'
        char.effects << [EFFECT_SHIELD_WALL, 1, nil, nil]
        char.roll_learning(SKILL_SHIELD_WALL)
        char.save
        result += "<p>#{char.name} forms a shield wall.</p>"

      #Fling
      when '13'

        opponent_chars = User.find(char.team.user.battle.opponent).team.characters.where(:active => true)
        if opponent_chars.any?
          target = opponent_chars[rand(0..(opponent_chars.length - 1))]

          hit = true

          res = ranged_skill_hit(char, target, SKILL_FLING)

          hit = res[:hit]
          result += res[:text]

          if hit
            damage = char.equipped_weapon.roll_damage + ((char.final_dex + char.fling)/2.0)
            damage -= (target.final_tgh/2.0)
            damage -= (target.armor/2.0)
            if damage < 0
              damage = 0
            end
            damage = damage.round(0)
            target.current_hp -= damage
            target.taken_damage = true

            result += "<p>#{char.name} flings a stone at #{target.name} for <span class='red'>#{damage}</span> damage.</p>"
            result += target.check_if_poisoned(char)

            result += check_weapon_procs(char, target)

            char.roll_learning(SKILL_FLING)

            result += target.check_knockout

            char.effects.delete_if {|effect| effect[0] == EFFECT_TAKEN_AIM}

            char.effects << [EFFECT_TAKEN_AIM, 1, nil, target._id]
            char.roll_learning(SKILL_TAKE_AIM)
            char.save
          end
        end
      #Mind Poison
      when '19'
        if char.skill_roll_successful?(SKILL_MIND_POISON)
          char.effects << [EFFECT_APPLIED_MIND_POISON, rand(3..5), nil, nil]
          char.roll_learning(SKILL_MIND_POISON)
          char.save
          result += "<p>#{char.name} applies mind poison.</p>"
        else
          result += "<p>#{char.name} attempts do apply mind poison but fails.</p>"
        end

      #Paralyzing Poison
      when '20'
        if char.skill_roll_successful?(SKILL_PARALYZING_POISON)
          char.effects << [EFFECT_APPLIED_PARALYZING_POISON, rand(3..5), nil, nil]
          char.roll_learning(SKILL_PARALYZING_POISON)
          char.save
          result += "<p>#{char.name} applies paralyzing poison.</p>"
        else
          result += "<p>#{char.name} attempts do apply paralyzing poison but fails.</p>"
        end

      #Weakness Poison
      when '21'
        if char.skill_roll_successful?(SKILL_WEAKNESS_POISON)
          char.effects << [EFFECT_APPLIED_WEAKNESS_POISON, rand(3..5), nil, nil]
          char.roll_learning(SKILL_WEAKNESS_POISON)
          char.save
          result += "<p>#{char.name} applies weakness poison.</p>"
        else
          result += "<p>#{char.name} attempts do apply weakness poison but fails.</p>"
        end

      end
    end

    if char.active and target and target.active
      case action['skill']
      #Strike
      when '0'

        if new_target = target.is_protected?
          result += "<p>#{new_target.name} protects #{target.name} and takes the hit from #{char.name}</p>"
          target = new_target
        end

        hit = true

        res = melee_skill_miss_roll(char, target, SKILL_STRIKE)

        hit = res[:hit]
        result += res[:text]

        if hit
          damage = (char.equipped_weapon.roll_damage + ((char.final_str + char.strike)/2.0))
          damage -= (target.final_tgh/2.0)
          damage -= (target.armor/2.0)

          if damage < 0
            damage = 0
          end
          damage = damage.round(0)
          target.current_hp -= damage
          target.taken_damage = true

          result += "<p>#{char.name} strikes #{target.name} for <span class='red'>#{damage}</span> damage.</p>"

          result += target.check_if_poisoned(char)

          result += check_weapon_procs(char, target)

          char.roll_learning(SKILL_STRIKE)

          result += target.check_knockout
          char.save

        end

      #Throw
      when '1'

        hit = true

        res = ranged_skill_hit(char, target, SKILL_THROWN)

        hit = res[:hit]
        result += res[:text]

        if hit
          damage = char.equipped_weapon.roll_damage + ((char.final_dex + char.thrown)/2.0)
          damage -= (target.final_tgh/2.0)
          damage -= (target.armor/2.0)
          if damage < 0
            damage = 0
          end
          damage = damage.round(0)
          target.current_hp -= damage
          target.taken_damage = true
          result += "<p>#{char.name} throws a stone at #{target.name} for <span class='red'>#{damage}</span> damage.</p>"

          result += target.check_if_poisoned(char)

          result += check_weapon_procs(char, target)

          char.roll_learning(SKILL_THROWN)

          result += target.check_knockout

          char.effects.delete_if {|effect| effect[0] == EFFECT_TAKEN_AIM}

          char.effects << [EFFECT_TAKEN_AIM, 1, nil, target._id]
          char.roll_learning(SKILL_TAKE_AIM)
          char.save
        end

      #Kick Dirt
      when '3'

        hit = true

        res = ranged_skill_hit(char, target, SKILL_DIRT)

        hit = res[:hit]
        result += res[:text]

        if hit
          duration = rand(2..4)
          target.effects << [EFFECT_BLINDED, duration, nil, nil]
          target.save
          result += "<p>#{char.name} throws dirt into the eyes of #{target.name}. <span class='red'>#{target.name} is blinded!</p></span>"

          char.effects.delete_if {|effect| effect[0] == EFFECT_TAKEN_AIM}

          char.roll_learning(SKILL_DIRT)

          char.effects << [EFFECT_TAKEN_AIM, 1, nil, target._id]
          char.roll_learning(SKILL_TAKE_AIM)
          char.save
        end

      #Quick Strike
      when '6'

        if new_target = target.is_protected?
          result += "<p>#{new_target.name} protects #{target.name} and takes the hit from #{char.name}</p>"
          target = new_target
        end

        hit = true

        res = melee_skill_miss_roll(char, target, SKILL_QUICK_STRIKE)

        hit = res[:hit]
        result += res[:text]

        if hit
          damage = ((char.equipped_weapon.roll_damage + ((char.final_str + char.quick_strike)/2.0)) * 0.8)
          damage -= (target.final_tgh/2.0)
          damage -= (target.armor/2.0)
          if damage < 0
            damage = 0
          end
          damage = damage.round(0)
          target.current_hp -= damage
          target.taken_damage = true

          result += "<p>#{char.name} quickly strikes #{target.name} for <span class='red'>#{damage}</span> damage.</p>"

          result += target.check_if_poisoned(char)

          result += check_weapon_procs(char, target)

          char.roll_learning(SKILL_QUICK_STRIKE)

          result += target.check_knockout
          char.save
        end

      #Heavy Strike
      when '7'

        if new_target = target.is_protected?
          result += "<p>#{new_target.name} protects #{target.name} and takes the hit from #{char.name}</p>"
          target = new_target
        end

        hit = true

        res = melee_skill_miss_roll(char, target, SKILL_HEAVY_STRIKE)

        hit = res[:hit]
        result += res[:text]

        if hit
          damage = ((char.equipped_weapon.roll_damage + ((char.final_str + char.heavy_strike)/2.0)) * 1.2)
          damage -= (target.final_tgh/2.0)
          damage -= (target.armor/2.0)

          if damage < 0
            damage = 0
          end
          damage = damage.round(0)
          target.current_hp -= damage
          target.taken_damage = true

          result += "<p>#{char.name} does a heavy strike at #{target.name} for <span class='red'>#{damage}</span> damage.</p>"

          result += target.check_if_poisoned(char)

          result += check_weapon_procs(char, target)

          char.roll_learning(SKILL_HEAVY_STRIKE)

          result += target.check_knockout
          char.save
        end

      #Accurate Strike
      when '8'

        if new_target = target.is_protected?
          result += "<p>#{new_target.name} protects #{target.name} and takes the hit from #{char.name}</p>"
          target = new_target
        end

        damage = (char.equipped_weapon.roll_damage + ((char.final_str + char.accurate_strike)/2.0))
        damage -= (target.final_tgh/2.0).
        damage -= (target.armor/2.0)

        if damage < 0
          damage = 0
        end
        damage = damage.round(0)
        target.current_hp -= damage
        target.taken_damage = true

        result += "<p>#{char.name} does an accurate strike at #{target.name} for <span class='red'>#{damage}</span> damage.</p>"

        result += target.check_if_poisoned(char)

        result += check_weapon_procs(char, target)

        char.roll_learning(SKILL_ACCURATE_STRIKE)

        result += target.check_knockout
        char.save

      #Finishing Strike
      when '9'

        if new_target = target.is_protected?
          result += "<p>#{new_target.name} protects #{target.name} and takes the hit from #{char.name}</p>"
          target = new_target
        end

        hit = true

        res = melee_skill_miss_roll(char, target, SKILL_FINISHING_STRIKE)

        hit = res[:hit]
        result += res[:text]

        if hit
          damage = ((char.equipped_weapon.roll_damage + ((char.final_str + char.finishing_strike)/2.0)) * 1.7)
          damage -= (target.final_tgh/2.0)
          damage -= (target.armor/2.0)

          if damage < 0
            damage = 0
          end
          damage = damage.round(0)
          target.current_hp -= damage
          target.taken_damage = true

          result += "<p>#{char.name} does a finishing strike at #{target.name} for <span class='red'>#{damage}</span> damage.</p>"

          result += target.check_if_poisoned(char)

          result += check_weapon_procs(char, target)

          char.roll_learning(SKILL_FINISHING_STRIKE)

          result += target.check_knockout
          char.save

        end

      #Protect
      when '10'
        target.effects << [EFFECT_PROTECTED, 1, nil, char._id]
        char.roll_learning(SKILL_PROTECT)
        char.save
        target.save
        result += "<p>#{char.name} protects #{target.name}.</p>"


      #Quick Throw
      when '14'

        hit = true

        res = ranged_skill_hit(char, target, SKILL_QUICK_THROW)

        hit = res[:hit]
        result += res[:text]

        if hit
          damage = (char.equipped_weapon.roll_damage + ((char.final_dex + char.quick_throw)/2.0)) * 0.8
          damage -= (target.final_tgh/2.0)
          damage -= (target.armor/2.0)
          if damage < 0
            damage = 0
          end
          damage = damage.round(0)
          target.current_hp -= damage
          target.taken_damage = true
          result += "<p>#{char.name} quickly throws a stone at #{target.name} for <span class='red'>#{damage}</span> damage.</p>"

          result += target.check_if_poisoned(char)

          result += check_weapon_procs(char, target)

          char.roll_learning(SKILL_QUICK_THROW)

          result += target.check_knockout

          char.effects.delete_if {|effect| effect[0] == EFFECT_TAKEN_AIM}

          char.effects << [EFFECT_TAKEN_AIM, 1, nil, target._id]
          char.roll_learning(SKILL_TAKE_AIM)
          char.save
        end

      #Heavy Throw
      when '15'

        hit = true

        res = ranged_skill_hit(char, target, SKILL_HEAVY_THROW)

        hit = res[:hit]
        result += res[:text]

        if hit
          damage = ((char.equipped_weapon.roll_damage + ((char.final_dex + char.heavy_throw)/2.0)) * 1.2)
          damage -= (target.final_tgh/2.0)
          damage -= (target.armor/2.0)
          if damage < 0
            damage = 0
          end
          damage = damage.round(0)
          target.current_hp -= damage
          target.taken_damage = true
          result += "<p>#{char.name} throws a stone heavily at #{target.name} for <span class='red'>#{damage}</span> damage.</p>"

          result += target.check_if_poisoned(char)

          result += check_weapon_procs(char, target)

          char.roll_learning(SKILL_HEAVY_THROW)

          result += target.check_knockout

          char.effects.delete_if {|effect| effect[0] == EFFECT_TAKEN_AIM}

          char.effects << [EFFECT_TAKEN_AIM, 1, nil, target._id]
          char.roll_learning(SKILL_TAKE_AIM)
          char.save
        end

      #Bola
      when '18'

        hit = true

        res = ranged_skill_hit(char, target, SKILL_BOLA)

        hit = res[:hit]
        result += res[:text]

        if hit
          target.effects << [EFFECT_STUNNED, 1, nil, nil]
          target.save
          result += "<p>#{char.name} throws a bola at #{target.name}. <span class='red'>#{target.name} is entangled!</p></span>"

          char.effects.delete_if {|effect| effect[0] == EFFECT_TAKEN_AIM}

          char.roll_learning(SKILL_BOLA)

          char.effects << [EFFECT_TAKEN_AIM, 1, nil, target._id]
          char.roll_learning(SKILL_TAKE_AIM)
          char.save
        end

      end
    end

    result
  end

  def self.check_if_lost(team, op_team)
    if !team.characters.where(:active => true).any?

      do_battle_results(team, op_team, BATTLE_LOST, BATTLE_WON)
      return true

    end
    false
  end

  def self.validate_actions(char_actions, team, op_team)
    if char_actions
      char_actions.each do |pos, actions|
        char = team.get_char(pos.to_i)
        total_ap = char.final_ap
        actions.each do |num, action|
          #Check if char can use action
          unless char.skill_available?(action['action'].to_i)
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

  #Function for checking standard ranged skill miss rolls.
  def self.ranged_skill_hit(char, target, skill_id)

    hit = true
    result = ''

    if hit and waller = target.behind_shield_wall?
      hit = false
      result += "<p>#{char.name} #{Constant.get_skill_text(skill_id)} #{target.name} but #{target.name} is protected by a shield wall from #{waller}.</p>"
    end

    if hit and (target.effects.map {|x| x[0] }).include?(EFFECT_SHIELD_WALL) and target.skill_roll_successful?(SKILL_SHIELD_WALL)
      hit = false
      result += "<p>#{char.name} #{Constant.get_skill_text(skill_id)} #{target.name} but #{target.name} has a shield wall up.</p>"
    end

    #Check if char has cover and there are chars in front.
    if hit and (target.effects.map {|x| x[0] }).include?(EFFECT_COVER)
      if target.team.position_targetability_ranged(target.position) != NO_PENALTY
        if target.skill_roll_successful?(SKILL_COVER)
          hit = false
          result += "<p>#{char.name} #{Constant.get_skill_text(skill_id)} #{target.name} but #{target.name} has taken cover.</p>"
        else
          result += "<p>#{target.name} attempts to take cover from #{char.name}'s attack but fails.</p>"
        end
      elsif hit
        result += "<p>#{target.name} attempts to take cover from #{char.name}'s attack but there is no one to hide behind!</p>"
      end
    end

    targetability = target.team.position_targetability_ranged(target.position)
    if hit and (!char.ranged_hit?(skill_id) or penalty_roll_miss?(targetability))
      aimed_char = char.aim_success?
      if aimed_char and aimed_char == target._id
        result += "<p>#{char.name} has taken aim at #{target.name} and hits thanks to it.</p>"
    elsif weapon = char.equipped_weapon and weapon.eq_type == EQUIPMENT_JAVELINS and rand(1..10) == 1
        #Hit thanks to using javelin. No need for extra text.
      else
        hit = false
        result += "<p>#{char.name} #{Constant.get_skill_text(skill_id)} #{target.name} but misses.</p>"
      end
    end

    return {hit: hit, text: result}

  end

  #Function for checking standard melee skill miss rolls.
  def self.melee_skill_miss_roll(char, target, skill_id)

    hit = true
    result = ''

    if target.melee_dodge?
      hit = false
      result += "<p>#{char.name} #{Constant.get_skill_text(skill_id)} #{target.name} but #{target.name} gets out of the way.</p>"
      result += check_counterstrike(char, target)
    end

    if hit and target.defensive_posture_dodge?
      hit = false
      result += "<p>#{char.name} #{Constant.get_skill_text(skill_id)} #{target.name} but #{target.name}'s defensive posture allows a dodge.</p>"
      result += check_counterstrike(char, target)
    end

    if hit and weapon = target.equipped_weapon and weapon.eq_type == EQUIPMENT_SWORD and target.parry_roll
      hit = false
      result += "<p>#{char.name} #{Constant.get_skill_text(skill_id)} #{target.name} but #{target.name} parries the attack.</p>"
    end

    return {hit: hit, text: result}

  end

  def self.check_weapon_procs(char, target)
    result = ''
    if weapon = char.equipped_weapon and weapon.eq_type == EQUIPMENT_MACE and rand(1..20) == 1
      target.effects << [EFFECT_STUNNED, 1, nil, nil]
      target.save
      result += "<p>#{target.name} is <span class='red'>stunned</span> by the powerful blow.</p>"
    elsif weapon = char.equipped_weapon and weapon.eq_type == EQUIPMENT_AXE and rand(1..20) == 1
      target.effects << [EFFECT_BLEEDING, rand(3..5), nil, nil]
      target.save
      result += "<p>#{target.name} takes a serious hit and is <span class='red'>bleeding!</span></p>"
    elsif weapon = char.equipped_weapon and weapon.eq_type == EQUIPMENT_THROWING_AXES and rand(1..20) == 1
      target.effects << [EFFECT_BLEEDING, rand(3..5), nil, nil]
      target.save
      result += "<p>#{target.name} takes a serious hit and is <span class='red'>bleeding!</span></p>"
    end
    result
  end

  def self.penalty_roll_miss?(targetability)
    if targetability == 1 and rand(1..4) > 3
      return true
    elsif targetability == 2 and rand(1..4) > 2
      return true
    end
    false
  end

  def self.check_counterstrike(char, target)
    cs_damage = target.counterstrike_damage(char)
    result = ''
    if cs_damage
      result = "<p>#{target.name} counterstrikes #{char.name} for <span class='red'>#{cs_damage}</span> damage.</p>"
      char.current_hp -= cs_damage
      target.roll_learning(SKILL_COUNTERSTRIKE)
      target.save
      result += char.check_knockout
    end
    result
  end

  def self.do_battle_results(loser_team, winner_team, loss_result, win_result)

    rating_change_loser = calc_rating_change(0, winner_team.rating - loser_team.rating)
    rating_change_winner = calc_rating_change(1, loser_team.rating - winner_team.rating)

      #Do Loser

      loser = loser_team.user

      learning_results = ''
      loser_team.characters.each do |char|
        learning_results += char.apply_learnings
        char.learnings = []
        char.save
      end

      loser.battle.update_attributes(:result => loss_result)
      loser_team.update_attributes(:rating => (loser_team.rating + rating_change_loser), :gold => (loser_team.gold + 10))

      battle_result = BattleResult.create(last_turn_events: loser.battle_sync.turn_events, result: loser.battle.result, learning_results: learning_results, :rating_change => rating_change_loser, :gold_change => 10)
      loser.battle_result = battle_result
      loser.save

      # Do Winner
      winner = winner_team.user

      learning_results = ''
      winner_team.characters.each do |char|
        learning_results += char.apply_learnings
        char.learnings = []
        char.save
      end

      winner.battle.update_attributes(:result => win_result)
      winner_team.update_attributes(:rating => (winner_team.rating + rating_change_winner), :gold => (winner_team.gold + 50))

      battle_result = BattleResult.create(last_turn_events: winner.battle_sync.turn_events, result: winner.battle.result, learning_results: learning_results, :rating_change => rating_change_winner, :gold_change => 50)
      winner.battle_result = battle_result
      winner.save

  end

  def self.calc_rating_change(score, diff)
    change = 16.0 * (score - ( 1.0/(1.0 + (10.0 ** (diff/400.0)))))
    change.round(0)
  end
end

