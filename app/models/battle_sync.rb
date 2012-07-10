class BattleSync
  include Mongoid::Document

  has_many :users

  field :state, :type => String, :default => 'orders'

  field :submit_count, :type => Integer, :default => 0

  field :turn_events, :type => String, :default => ""

  field :turn, :type => Integer, :default => 1

  field :submit_time, :type => Time

  def seconds_since_submit
    (Time.now - submit_time).to_i
  end

end

