class BattlesController < ApplicationController

  def queue

    @team = current_user.team

    if br = current_user.battle_result
      br.destroy
    end

    if current_user.battle
      redirect_to battle_path
      return
    elsif q = BattleQueue.collection.find_and_modify(query: { '$nor' => [ {user_id: current_user._id} ]}, :remove => true)
      bq = BattleQueue.instantiate(q)
      opponent = User.find(bq.user_id)
      Battle.create(user: current_user, opponent: bq.user_id )
      Battle.create(user: opponent, opponent: current_user._id)
      bs = BattleSync.create(reference_id: current_user._id)
      bs.users << current_user
      bs.users << opponent
      bs.save
      redirect_to battle_path
    elsif !BattleQueue.all.any?
      @queue = BattleQueue.create(user: current_user)
    end

  end

  def cage

    if br = current_user.battle_result
      br.destroy
    end

    ai_team = Team.create_ai_team(params[:format])
    Battle.create(user: current_user, opponent: ai_team._id )
    bs = BattleSync.create(reference_id: current_user._id, pvp: false)
    bs.users << current_user
    bs.save
    redirect_to battle_path
  end

  def battle
    @battle = current_user.battle
    @team = current_user.team
    bs = current_user.battle_sync

    if @battle.result != BATTLE_UNDECIDED
      redirect_to battle_finished_path
      return
    elsif @battle.submitted
      redirect_to waiting_for_turn_path
      return
    end

    if bs.pvp
      @op_team = User.find(@battle.opponent).team
    else
      @op_team = Team.find(@battle.opponent)
    end

    @chars = (@team.characters.where(:active => true)).sort {|a, b| a.position <=> b.position}
    @op_chars = @op_team.characters.where(:active => true)

    @turn_events = bs.turn_events

    render 'battle'
  end

  def leave_queue
    if current_user.battle_queue
      current_user.battle_queue.destroy
    end
    redirect_to arena_path
  end

  def confirm_turn

    @battle = current_user.battle

    if @battle.result != BATTLE_UNDECIDED
      redirect_location = '/battles/battle_finished'
    elsif @battle.submitted
      redirect_location = '/battles/waiting_for_turn'
    else

      if current_user.battle_sync.pvp
        op_team = User.find(@battle.opponent).team
      else
        op_team = Team.find(@battle.opponent)
      end

      unless Battle.validate_actions(params[:actions], current_user.team, op_team)
        params[:actions] = nil
      end

      @battle.actions = params[:actions]

      #IF PLAYING OTHER HUMAN
      if current_user.battle_sync.pvp

          @battle.submitted = true
          @battle.save

          op_user = User.find(@battle.opponent)

          battle_sync = BattleSync.collection.find_and_modify(query: { '$or' => [{ reference_id: current_user._id } , { reference_id: @battle.opponent }], '$or' => [{ state: 'orders' } , { state: 'waiting' }] }, update: {'$set' => {state: 'waiting'}}, :new => true)

          if battle_sync
            #DEBUG
            puts "################################################################"
            puts "Found bs in Waiting or Orders. Setting state to waiting and incrementing submit_count!"
            puts Time.now
            puts "################################################################"
            bs = BattleSync.instantiate(battle_sync)
            bs.submit_count += 1
            unless bs.submit_time
              bs.submit_time = Time.now
            end
            bs.save
          end

          @op_battle = op_user.battle

          battle_sync = BattleSync.collection.find_and_modify(query: { '$or' => [{ reference_id: current_user._id } , { reference_id: @battle.opponent }], submit_count: 2, state: 'waiting' }, update: {'$set' => {state: 'resolving'}}, :new => true)

          if battle_sync
          #DEBUG
          puts "################################################################"
          puts "Both users have submitted. Queuing turn resolution!"
          puts Time.now
          puts "Submit count is"
          puts battle_sync.submit_count
          puts "################################################################"
            Qu.enqueue BattleSync, battle_sync['_id']
          end

          redirect_location = '/battles/waiting_for_turn'

      #IF PLAYING AI
      else
        @battle.submitted = true
        @battle.save

        battle_sync = current_user.battle_sync
        battle_sync.update_attribute(:state, 'waiting')
        Qu.enqueue BattleSync, battle_sync['_id']
        redirect_location = '/battles/waiting_for_turn'
      end
    end
    render :text => redirect_location
  end

  def waiting_for_turn
    bs = current_user.battle_sync
    battle = current_user.battle

    if battle.result != BATTLE_UNDECIDED
      redirect_to battle_finished_path
      return
    end

    if bs.turn > battle.turn
      battle.update_attributes(turn: battle.turn + 1, submitted: false)
      redirect_to battle_path
      return
    end

    @team = current_user.team
    if bs.pvp
      @op_team = User.find(battle.opponent).team
    else
      @op_team = Team.find(battle.opponent)
    end
    @turn_events = bs.turn_events
  end

  def battle_finished
    if battle_result = current_user.battle_result
      bs = current_user.battle_sync
      if bs
        bs.update_attribute(:reference_id, nil)
        battle_result.update_attribute(:last_turn_info, bs.turn_events)
      end
      battle = current_user.battle
      if bs and !bs.pvp
        team = Team.find(current_user.battle.opponent)
        team.characters.destroy_all
        team.destroy
      end
      current_user.battle_sync = nil
      current_user.battle = nil
      current_user.save
      if bs and !bs.users.any?
        bs.destroy
      end
      if battle
        battle.destroy
      end
      current_user.team.reset_battle_stats

      @result = battle_result.result
      @learning_results = battle_result.learning_results
      @turn_events = battle_result.last_turn_info
      @rating_change = battle_result.rating_change
      @gold_change = battle_result.gold_change
    else
      redirect_to battle_path
    end

  end

end

