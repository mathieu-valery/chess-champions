require 'faker'

class Player
  attr_reader :first_name, :last_name, :age, :elo
  attr_accessor :champion_by_age, :champion_by_elo
  def initialize(first_name, last_name)
    @first_name = first_name
    @last_name = last_name
    @age = rand 18..75
    @elo = rand 1000..3000
    @champion_by_age = false
    @champion_by_elo = false
  end
end

players = []

for i in 0..1_000_000
  players << Player.new(Faker::Name.first_name, Faker::Name.last_name)
end

def find_champions1(players)
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
  puts "Number of champions: #{champions.length}"
  champions
end

def find_champions2(players)
  time_at_starting = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  players_by_age = players.sort_by { |player| player.age }
  players_by_elo = players.sort_by { |player| player.elo }.reverse

  youngest_champion = nil
  players_by_age.each do |player|
    if youngest_champion.nil? || player.elo > youngest_champion.elo || (player.age == youngest_champion.age && player.elo == youngest_champion.elo)
      youngest_champion = player
    end
    player.champion_by_age = youngest_champion == player
  end

  strongest_champion = nil
  players_by_elo.each do |player|
    if strongest_champion.nil? || player.age < strongest_champion.age || (player.age == youngest_champion.age && player.elo == youngest_champion.elo)
      strongest_champion = player
    end
    player.champion_by_elo = strongest_champion == player
  end

  champions = players.select do |player|
    player.champion_by_age && player.champion_by_elo
  end
  time_at_ending = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  time_elapsed = time_at_ending - time_at_starting
  puts "find_champions: time time_elapsed #{time_elapsed} seconds"
  puts "Number of champions: #{champions.length}"
  champions
end