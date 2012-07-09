class BattlesController < ApplicationController

  def queue

    if current_user.battle_result
      br = current_user.battle_result
      br.destroy
    end

    if current_user.battle
      if current_user.battle_sync
        redirect_to next_turn_path
        return
      else
        redirect_to battle_path
        return
      end

    elsif q = BattleQueue.collection.find_and_modify(query: { '$nor' => [ {user_id: current_user._id} ]}, :remove => true)
      bq = BattleQueue.instantiate(q)
      opponent = User.find(bq.user_id)
      Battle.create(user: current_user, opponent: bq.user_id )
      Battle.create(user: opponent, opponent: current_user._id)
      redirect_to battle_path
    elsif !BattleQueue.all.any?
      @queue = BattleQueue.create(user: current_user)
    end

  end

  def battle
    @battle = current_user.battle
    @team = current_user.team
    @op_team = User.find(@battle.opponent).team

    @chars = @team.characters.where(:active => true)
    @op_chars = @op_team.characters.where(:active => true)

    #Create battlesync unless it already exists
    BattleSync.collection.find_and_modify(query: { '$or' => [ { reference_id: current_user._id } , { reference_id: @battle.opponent } ] }, update: {'$set' => {reference_id: current_user._id}}, :upsert => true, :new => true)

    bs = BattleSync.where(:reference_id.in => [current_user._id, @battle.opponent]).first

    bs.users << current_user
    bs.save

    @turn_events = ""
  end

  def next_turn

    @battle = current_user.battle
    @team = current_user.team
    @op_team = User.find(@battle.opponent).team

    @chars = @team.characters.where(:active => true)
    @op_chars = @op_team.characters.where(:active => true)

    bs = current_user.battle_sync

    @turn_events = bs.turn_events

    if @battle.result != BATTLE_UNDECIDED
      redirect_to battle_finished_path
    else
      render 'battle'
    end
  end

  def leave_queue
    current_user.battle_queue.destroy
    redirect_to root_path
  end

  def confirm_turn

    @battle = current_user.battle
    op_user = User.find(@battle.opponent)

    unless Battle.validate_actions(params[:actions], current_user.team, op_user.team)
      params[:actions] = nil
    end

    @battle.actions = params[:actions]
    @battle.submitted = true
    bs = current_user.battle_sync
    bs.submit_count += 1
    bs.state = 'waiting'
    bs.save
    @battle.save

    @op_battle = op_user.battle

    battle_sync = BattleSync.collection.find_and_modify(query: { '$or' => [{ reference_id: current_user._id } , { reference_id: @battle.opponent }], submit_count: 2, state: 'waiting' }, update: {'$set' => {state: 'resolving'}}, :new => true)

    if battle_sync
      turn_events = Battle.resolve_turn(@battle, @op_battle)
      bs = BattleSync.instantiate(battle_sync)
      bs.update_attributes(submit_count: 0, state: 'orders', turn_events: turn_events, turn: bs.turn + 1)
    end

    render :nothing => true
  end

  def waiting_for_turn
    bs = current_user.battle_sync
    battle = current_user.battle

    if bs.turn > battle.turn
      battle.update_attributes(turn: battle.turn + 1, submitted: false)
      redirect_to next_turn_path
    end
  end

  def battle_finished
    if current_user.battle_result
      battle_result = current_user.battle_result
    else
      bs = current_user.battle_sync
      battle = current_user.battle
      battle_result = BattleResult.create(last_turn_events: bs.turn_events, result: battle.result)
      current_user.battle_result = battle_result
      current_user.battle_sync = nil
      current_user.battle = nil
      current_user.save
      if !bs.users.any?
        bs.destroy
      end
      battle.destroy
      current_user.team.reset_battle_stats
    end

    @turn_events = battle_result.last_turn_events
    if battle_result.result == BATTLE_WON
      render 'won_battle'
    else
      render 'lost_battle'
    end
  end

end

