ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Oiseau.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Oiseau.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(Oiseau.Repo)

