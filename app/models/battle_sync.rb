class BattleSync
  include Mongoid::Document

  has_many :users

  field :state, :type => String, :default => 'orders'

  field :submit_count, :type => Integer, :default => 0

  field :turn_events, :type => String, :default => ""

end

