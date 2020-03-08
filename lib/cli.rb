require "readline"
require "thor"

require_relative "session"

class CLI < Thor
  default_task :start

  desc "Start Session", "Start a new gongfu session. Specify plan, or use default of 10 second increments"
  def start
    puts "Get your tea ready!"

    steep_next
  end

  private

  def steep_next
    steep = session.next_steep

    Readline.readline("#{steep.length} >", true)

    puts "steeping..."
    steep.start
    puts "done!"
    puts "\a"

    steep_next
  end

  def default_plan
    [{
      increment: 10
    }]
  end

  def logger
    Logger.new(STDOUT)
  end

  def session
    @session ||= Session.new(plan: plan)
  end

  def plan
    @plan ||= default_plan
  end
end
