class BattlesController < ApplicationController

  def queue

    current_user.team.reset_battle_stats

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

    #Create battlesync unless it already exists
    BattleSync.collection.find_and_modify(query: { '$or' => [ { reference_id: current_user._id } , { reference_id: @battle.opponent } ] }, update: {'$set' => {reference_id: current_user._id}}, :upsert => true, :new => true)

    bs = BattleSync.where(:reference_id.in => [current_user._id, @battle.opponent]).first

    bs.users << current_user
    bs.save

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
      Battle.resolve_turn(@battle, @op_battle)
      bs = BattleSync.instantiate(battle_sync)
      bs.update_attributes(submit_count: 0, state: 'orders')
    end

    render :nothing => true
  end

  def waiting_for_turn
    bs = current_user.battle_sync

    if bs.state == 'orders'
      redirect_to battle_path
    end
  end

end

