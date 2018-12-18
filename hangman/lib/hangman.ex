defmodule Hangman do
  alias Hangman.{ Game, Server }

  def new_game() do
    Server.start_link()
  end

  def make_move(game_pid, guess) do
    GenServer.call(game_pid, { :make_move, guess })
  end

  defdelegate tally(game), to: Game

end
