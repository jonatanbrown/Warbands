class BattlesController < ApplicationController

  def queue

    if current_user.battle
      redirect_to next_turn_path
      return
    end

    if battle = Battle.where(opponent: current_user._id).first
      b = Battle.create(user: current_user, opponent: battle.user._id )
      redirect_to battle_path
    elsif q = BattleQueue.all.first and q.user != current_user
      #CONCURRENCY ISSUE HERE, NEEDS TO BE FIXED. Two people can check condition at same time!
      q.destroy
      b = Battle.create(user: current_user, opponent: q.user._id )
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

    if @battle.result == BATTLE_LOST
      redirect_to lost_battle_path
    elsif @battle.result == BATTLE_WON
      redirect_to won_battle_path
    else
      render 'battle'
    end
  end

  def leave_queue
    current_user.battle_queue.destroy
    redirect_to root_path
  end

  def confirm_turn

    #Validate input actions so they aren't cheating!

    @battle = current_user.battle
    @battle.actions = params[:actions]
    bs = current_user.battle_sync
    bs.submit_count += 1
    bs.state = 'waiting'
    bs.save
    @battle.save

    @op_battle = @op_team = User.find(@battle.opponent).battle

    battle_sync = BattleSync.collection.find_and_modify(query: { '$or' => [{ reference_id: current_user._id } , { reference_id: @battle.opponent }], submit_count: 2, state: 'waiting' }, update: {'$set' => {state: 'resolving'}}, :new => true)

    if battle_sync
      #Resolve turn
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
      battle.update_attribute(:turn, battle.turn + 1)
      redirect_to next_turn_path
    end
  end

  def won_battle
    bs = current_user.battle_sync
    battle = current_user.battle
    @turn_events = bs.turn_events
    current_user.battle_sync = nil
    current_user.save
    if !bs.users.any?
      bs.destroy
    end
    battle.destroy
    current_user.team.reset_battle_stats
  end

  def lost_battle
    bs = current_user.battle_sync
    battle = current_user.battle
    @turn_events = bs.turn_events
    current_user.battle_sync = nil
    current_user.save
    if !bs.users.any?
      bs.destroy
    end
    battle.destroy
    current_user.team.reset_battle_stats
  end

end

