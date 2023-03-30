players = [
    {
      first_name: "Hikaru",
      last_name: "Nakamura",
      age: 35,
      elo: 2400,
    },
    {
      first_name: "Magnus",
      last_name: "Carlsen",
      age: 32,
      elo: 2800,
    },
    {
      first_name: "Andrea",
      last_name: "Botez",
      age: 20,
      elo: 2000,
    },
    {
      first_name: "Garry",
      last_name: "Kasparov",
      age: 59,
      elo: 2230,
    },
]

def find_champions(players)
  champions = []
  players.each do |player|
    next if champions.any? {|champion|
      (champion[:elo] > player[:elo] && champion[:age] <= player[:age]) ||
      (champion[:elo] >= player[:elo] && champion[:age] < player[:age])}
    champions << player
    champions.delete_if do |champion|
      (champion[:elo] < player[:elo] && champion[:age] >= player[:age]) ||
      (champion[:elo] <= player[:elo] && champion[:age] > player[:age])
    end
  end
  champions
end