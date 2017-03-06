require "./controller/connect_four"
loop do
  game = ConnectFour.new
  game.play
  if game.winner
    5.times do
      puts "\nCongradulations #{game.winner.name} you WIN!"
    end
    sleep(5)
  end
  break if game.quit?
end
puts "\nTHANKS FOR PLAYING"
