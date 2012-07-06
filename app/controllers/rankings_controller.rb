class RankingsController < ApplicationController
  def index
    teams = Team.all
    @teams = teams.sort_by {|x| x.points  }
    @teams.reverse!
  end
end

