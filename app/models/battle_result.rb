class BattleResult
  include Mongoid::Document

  belongs_to :user

  field :last_turn_info, :type => String

  field :result, :type => Integer

  field :learning_results, :type => String

  field :rating_change, :type => Integer

  field :gold_change, :type => Integer

end

