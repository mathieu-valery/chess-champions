require 'faker'

class Player
  attr_reader :first_name, :last_name, :age, :elo
  def initialize(first_name, last_name)
    @first_name = first_name
    @last_name = last_name
    @age = rand 18..75
    @elo = rand 1000..3000
  end
end

players = []

for i in 0..1_000_000
  players << Player.new(Faker::Name.first_name, Faker::Name.last_name)
end

def find_champions(players)
  time_at_starting = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  champions = []
  players.each do |player|
    next if champions.any? {|champion|
      (champion.elo > player.elo && champion.age <= player.age) ||
      (champion.elo >= player.elo && champion.age < player.age)}
    champions << player
    champions.delete_if do |champion|
      (champion.elo < player.elo && champion.age >= player.age) ||
      (champion.elo <= player.elo && champion.age > player.age)
    end
  end
  time_at_ending = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  time_elapsed = time_at_ending - time_at_starting
  puts "find_champions: time time_elapsed #{time_elapsed} seconds"
  champions
end
