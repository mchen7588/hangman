defmodule Hangman.Server do
    use GenServer
    alias Hangman.Game

    def start_link() do
        GenServer.start_link(__MODULE__, nil)
    end

    def init(_) do
        { :ok, Game.new_game() }
    end

    def handle_call({ :make_move, guess }, _from, state) do
        IO.inspect(state)
        { state, tally } = Game.make_move(state, guess)

        { :reply, tally, state }
        
    end

    
end