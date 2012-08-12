class RankingsController < ApplicationController
  def index
    teams = Team.all.excludes(:rating => nil)
    @rating_teams = teams.sort_by {|x| x.rating  }
    @rating_teams.reverse!
    @monster_teams = teams.sort_by {|x| x.monster_beaten  }
    @monster_teams.reverse!
  end
end

