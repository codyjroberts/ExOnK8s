Path.join(["rel", "plugins", "*.exs"])
|> Path.wildcard()
|> Enum.map(&Code.eval_file(&1))

use Mix.Releases.Config,
    default_release: :exonk8s,
    default_environment: :prod

environment :prod do
  set pre_start_hook: "script/pre_start.sh"
  set dev_mode: false
  set include_erts: false
  set include_src: false
  set overlays: [
    {:template, "rel/templates/vm.args.eex", "releases/<%= release_version %>/vm.args"}
  ]
  set commands: [
    migrate: "rel/commands/migrate.sh",
    seed: "rel/commands/seed.sh"
  ]
  set cookie: :nowarn
end

release :exonk8s do
  set version: current_version(:exonk8s)
  set applications: [
    :runtime_tools
  ]
end
