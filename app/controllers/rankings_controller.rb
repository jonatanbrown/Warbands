class RankingsController < ApplicationController
  def index
    teams = Team.all.excludes(:rating => nil)
    @teams = teams.sort_by {|x| x.rating  }
    @teams.reverse!
  end
end

