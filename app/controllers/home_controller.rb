class HomeController < ApplicationController
  def index
  end

  def home
    @user = current_user
  end

  def smithy
    @team = current_user.team
  end

  def arena
    if current_user.battle_queue
      redirect_to queue_path
    elsif current_user.battle and current_user.battle.submitted
      redirect_to waiting_for_turn_path
    elsif current_user.battle and !current_user.battle.submitted
      redirect_to battle_path
    end
  end

  def report_bugs
    @bug_report = BugReport.new()
  end

  def submit_bug_report
    flash[:notice] = "Thanks for your help!"
    bug_report = BugReport.create(params[:bug_report])
    bug_report.user = current_user
    bug_report.save
    redirect_to :report_bugs
  end
end

