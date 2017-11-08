# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs

alias ExOnK8s.{Repo, Musician}

database = Application.get_env(:exonk8s, ExOnK8s.Repo)[:database]

if database == "exonk8s_prod" do
  #exit(:hey_careful_man_theres_a_production_environment_here!)
  IO.puts "Hey, careful man, theres a production environment here!"
end

Repo.delete_all(Musician)

[
  %Musician{name: "Andy McKee", instrument: "guitar"},
  %Musician{name: "Ravi Shankar", instrument: "sitar"},
  %Musician{name: "Toumani Diabate", instrument: "kora"}
] |> Enum.each(&Repo.insert/1)
