require "thor"

require_relative "session"

class CLI < Thor
  default_task :start

  desc "Start Session", "Start a new gongfu session. Specify plan, or use default of 10 second increments"
  def start
    plan = default_plan

    Session
      .new(plan: plan, logger: logger)
      .next
  end

  private

  def default_plan
    [{
      increment: 10
    }]
  end

  def logger
    Logger.new(STDOUT)
  end
end
