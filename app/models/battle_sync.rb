class BattleSync
  include Mongoid::Document

  has_many :users

  field :resolving, :type => Boolean, :default => false

  field :submit_count, :type => Integer, :default => 0

end

