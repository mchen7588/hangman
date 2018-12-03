defmodule TextClient.Player do
    alias TextClient.State

    # possible states:
    # initializing, won, lost, good_guess, bad_guess, invalid_move, already_used

    def play(game = %State{ tally: %{ game_state: :good_guess } }) do
        continue_with_message(game, "good guess")
    end

    def play(game = %State{ tally: %{ game_state: :bad_guess } }) do
        continue_with_message(game, "bad guess")
    end

    def play(game = %State{ tally: %{ game_state: :invalid_move } }) do
        continue_with_message(game, "invalid move")
    end

    def play(game = %State{ tally: %{ game_state: :already_used } }) do
        continue_with_message(game, "already used")
    end
    
    def play(%State{ tally: %{ game_state: :won } }) do
        exit_with_message("you won")
    end
    
    def play(%State{ tally: %{ game_state: :lost } }) do
        exit_with_message("you lost")
    end

    def play(game) do
        continue(game)
    end

    defp continue_with_message(game, message) do
        IO.puts(message)

        continue(game)
    end

    defp continue(game) do
        game
            |> display()
            |> prompt()
            |> make_move()
            |> play()
    end

    defp display(game) do
        game
    end

    defp prompt(game) do
        game
    end

    defp make_move(game) do
        game
    end
    
    defp exit_with_message(message) do
        IO.puts(message)

        exit(:normal)
    end
end