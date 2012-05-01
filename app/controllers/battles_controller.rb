class BattlesController < ApplicationController

  def queue

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

    #Create battlesync unless it exists
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

    battle = current_user.battle
    battle.actions = params[:actions]
    bs = current_user.battle_sync
    bs.submit_count += 1
    bs.save
    battle.save

    render :nothing => true
  end

  def waiting_for_turn

    @battle = current_user.battle
    @op_battle = @op_team = User.find(@battle.opponent).battle

    battle_sync = BattleSync.collection.find_and_modify(query: { '$or' => [{ reference_id: current_user._id } , { reference_id: @battle.opponent }], submit_count: 2, resolving: false }, update: {'$set' => {resolving: true}}, :new => true)

    if battle_sync
      puts "RESOLVING TURN YEAH"
      #Resolve turn
      Battle.resolve_turn(@battle, @op_battle)


    end
  end

end

