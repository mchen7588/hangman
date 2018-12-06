defmodule Dictionary.WordList do
    @me __MODULE__

    def start_link() do
        Agent.start_link(&start/0, name: @me)
    end

    def start() do
        "../../assets/words.txt"
            |> Path.expand(__DIR__)
            |> File.read!
            |> String.split(~r/\n/)
    end

    def random_word() do
        Agent.get(@me, &Enum.random/1)
    end
    
end