defmodule Hangman.Game do
    defstruct(
        turns_left: 7,
        game_state: :initializing,
        letters: [],
        used: MapSet.new()
    )

    # Public

    def new_game() do
        new_game(Dictionary.random_word())
    end

    def new_game(input_word) do
        %Hangman.Game{
            letters: input_word |> String.codepoints()
        }
    end

    def make_move(game, guess) do
        game = calculate_game_state(game, guess)

        { game, tally(game) }
    end

    def tally(game) do
        %{
            game_state: game.game_state,
            turns_left: game.turns_left,
            letters: game.letters |> reveal_guessed(game.used),
            used: game.used
        }
    end


    # Private

    defp calculate_game_state(game = %{ game_state: game_state }, _guess) when game_state in [ :won, :lost ] do
        game
    end

    defp calculate_game_state(game, guess) do
        accept_move(game, String.downcase(guess), MapSet.member?(game.used, guess))
    end

    defp accept_move(game, _guess, _already_guessed = true) do
        Map.put(game, :game_state, :already_used)
    end

    defp accept_move(game, guess, _already_guessed = false) do
        Map.put(game, :used, MapSet.put(game.used, guess))
            |> score_guess(Enum.member?(game.letters, guess))
    end

    defp score_guess(game, _letter_exist = true) do
        new_game_state = MapSet.new(game.letters)
            |> MapSet.subset?(game.used)
            |> maybe_won()

        Map.put(game, :game_state, new_game_state)
    end

    defp score_guess(game = %{ turns_left: 1 }, _letter_not_exist) do
        Map.put(game, :game_state, :lost)
    end

    defp score_guess(game = %{ turns_left: turns_left }, _letter_not_exist) do
        %{ game | 
            game_state: :bad_guess,
            turns_left: turns_left - 1 }
    end

    defp reveal_guessed(letters, used) do
        letters 
            |> Enum.map(fn (letter) -> reveal_letter(letter, MapSet.member?(used, letter)) end)
    end

    defp reveal_letter(letter, _in_word = true), do: letter
    defp reveal_letter(_letter, _not_in_word), do: "_"

    defp maybe_won(true), do: :won
    defp maybe_won(_), do: :good_guess
end