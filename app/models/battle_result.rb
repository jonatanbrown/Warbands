class BattleResult
  include Mongoid::Document

  belongs_to :user

  field :last_turn_info, :type => String

  field :result, :type => Integer

end

