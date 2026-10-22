defmodule Mix.Tasks.Pathways.New do
  use Mix.Task

  @shortdoc "Creates a new Pathways domain"

  @moduledoc """
  Creates a new Pathways domain.

      mix pathways.new osteoporosis

  This creates the standard directory structure and starter modules
  for a Pathways domain.
  """

  @impl Mix.Task
  def run(args) do
    case args do
      [domain_name] ->
        generate(domain_name)

      _ ->
        Mix.raise("""
        Usage:

            mix pathways.new <domain>

        Example:

            mix pathways.new osteoporosis
        """)
    end
  end


defp generate(domain_name) do
  domain = normalize_domain_name(domain_name)
  module = Macro.camelize(domain)

  project_root =
    Path.expand(Path.join("..", domain), File.cwd!())

  root = Path.join([project_root, "lib", domain])
  demo_root = Path.join(project_root, "demo")
  test_root = Path.join(project_root, "test")
  domain_root = Path.join(root, "domain")
  #DSL_root = Path.join(root, "DSL")

  if File.exists?(project_root) do
    Mix.raise("Application already exists: #{project_root}")
  end

  File.mkdir_p!(project_root)

  create_directories(root, demo_root, test_root, domain_root)

  create_files(project_root, demo_root, root, test_root, domain_root, domain, module)

  Mix.shell().info("""

  Created Pathways application: #{module}clear
  

  Location: #{project_root}

  Next steps:

      cd ../#{domain}
      mix compile
      mix test

  """)
end


  defp normalize_domain_name(name) do
    name
    |> Macro.underscore()
    |> String.trim()
  end

  # defp ensure_does_not_exist!(root) do
  #   if File.exists?(root) do
  #     Mix.raise("Pathways domain already exists: #{root}")
  #   end
  # end

  defp create_directories(root, demo_root, test_root, domain_root) do
    [
      root,
      Path.join(root, "signals"),
      Path.join(root, "mechanisms"),
      Path.join(root, "interventions"),
      Path.join(root, "regimens"),
      Path.join(root, "indicated_agents"),
      Path.join(root, "conditions"),
      test_root,
      domain_root,
      demo_root
    ]
    |> Enum.each(&File.mkdir_p!/1)
  end
  

  defp create_files(project_root, demo_root, root, test_root, domain_root, domain, module) do
    
    write!(
      Path.join(project_root, "mix.exs"),
      PathwaysNew.Templates.Mix.render(module, domain)
    )
    
    write!(
      Path.join(root, "#{domain}.ex"),
      PathwaysNew.Templates.Domain.render(module)
    )
    
    write!(
      Path.join(root, "dsl.ex"),
      # Templates.pathway(domain, module)
      PathwaysNew.Templates.DSL.render(module)
    )
    
    write!(
      Path.join(root, "fact.ex"),
      # Templates.pathway(domain, module)
      PathwaysNew.Templates.Fact.render(module)
    )
    
    write!(
      Path.join(root, "entity.ex"),
      # Templates.pathway(domain, module)
      PathwaysNew.Templates.Entity.render(module)
    )
    
    write!(
      Path.join(root, "entities.ex"),
      # Templates.pathway(domain, module)
      PathwaysNew.Templates.Entities.render(module)
    )
    
    write!(
      Path.join(root, "graph.ex"),
      # Templates.pathway(domain, module)
      PathwaysNew.Templates.Graph.render(module)
    )
    
    write!(
      Path.join(root, "collection.ex"),
      # Templates.pathway(domain, module)
      PathwaysNew.Templates.Collection.render(module)
    )
    
    write!(
      Path.join(root, "role.ex"),
      # Templates.pathway(domain, module)
      PathwaysNew.Templates.Domain.Role.render(module)
    )
    
    write!(
      Path.join(test_root, "test_helper.exs"),
      PathwaysNew.Templates.TestHelper.render()
    )
    write!(
      Path.join(test_root, "domain_story.exs"),
      PathwaysNew.DomainStory.Demo.render(module)
    )
    
    write!(
      Path.join(demo_root, "#{domain}_test.exs"),
      PathwaysNew.Templates.DomainTest.render(module, domain)
    )

    write!(
      Path.join(root, "pathway.ex"),
      # Templates.pathway(domain, module)
      PathwaysNew.Templates.Domain.Pathway.render(module)
    )
    
    write!(
      Path.join([domain_root, "signal.ex"]),
      # Templates.signals(module)
      PathwaysNew.Templates.Domain.Signal.render(module)
    )
    
    write!(
      Path.join([domain_root, "condition.ex"]),
      # Templates.signals(module)
      PathwaysNew.Templates.Domain.Condition.render(module)
    )
    
    write!(
      Path.join([domain_root, "indicated_agent.ex"]),
      # Templates.signals(module)
      PathwaysNew.Templates.Domain.IndicatedAgent.render(module)
    )
    
    write!(
      Path.join([domain_root, "regimen.ex"]),
      # Templates.signals(module)
      PathwaysNew.Templates.Domain.Regimen.render(module)
    )
    
    write!(
      Path.join([domain_root, "mechanism.ex"]),
      # Templates.signals(module)
      PathwaysNew.Templates.Domain.Mechanism.render(module)
    )
    
    write!(
      Path.join([domain_root, "intervention.ex"]),
      # Templates.signals(module)
      PathwaysNew.Templates.Domain.Intervention.render(module)
    )
    
    write!(
      Path.join([root, "conditions", "conditions.ex"]),
      # Templates.signals(module)
      PathwaysNew.Templates.Conditions.render(module)
    )

    write!(
      Path.join([root, "signals", "signals.ex"]),
      # Templates.signals(module)
      PathwaysNew.Templates.Signals.render(module)
    )

    write!(
      Path.join([root, "mechanisms", "mechanisms.ex"]),
      # Templates.mechanisms(module)
      PathwaysNew.Templates.Mechanisms.render(module)
    )

    write!(
      Path.join([root, "interventions", "interventions.ex"]),
      # Templates.interventions(module)
      PathwaysNew.Templates.Interventions.render(module)
    )
    
    write!(
      Path.join([root, "indicated_agents", "indicated_agents.ex"]),
      # Templates.signals(module)
      PathwaysNew.Templates.IndicatedAgents.render(module)
    )
    

    write!(
      Path.join([root, "regimens", "regimens.ex"]),
      # Templates.regimens(module)
      PathwaysNew.Templates.Regimens.render(module)
    )

    write!(
      Path.join(root, "aliases.ex"),
      # Templates.aliases(module)
      PathwaysNew.Templates.Aliases.render(module)
    )

    write!(
      Path.join(root, "sources.ex"),
      # Template.sources(module)
      PathwaysNew.Templates.Sources.render(module)
    )

  end

  defp write!(path, contents) do
    File.write!(path, contents)
    Mix.shell().info("* creating #{path}")
  end
end