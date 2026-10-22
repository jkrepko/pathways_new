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

  lib_root = Path.join(project_root, "lib")
  demo_root = Path.join(project_root, "demo")
  test_root = Path.join(project_root, "test")
  
  lib_demo_root  = Path.join(lib_root, "demo")
  domain_root = Path.join(lib_root, "domain")
  #DSL_root = Path.join(root, "DSL")

  if File.exists?(project_root) do
    Mix.raise("Application already exists: #{project_root}")
  end

  File.mkdir_p!(project_root)

  create_directories(lib_root, demo_root, lib_demo_root, test_root, domain_root)

  create_files(project_root, lib_root, demo_root, lib_demo_root, test_root, domain_root, domain, module)

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

  defp create_directories(lib_root, demo_root, lib_demo_root, test_root, domain_root) do
    [
      lib_root,
      Path.join(lib_root, "signals"),
      Path.join(lib_root, "mechanisms"),
      Path.join(lib_root, "interventions"),
      Path.join(lib_root, "regimens"),
      Path.join(lib_root, "indicated_agents"),
      Path.join(lib_root, "conditions"),
      test_root,
      domain_root,
      demo_root,
      lib_demo_root
    ]
    |> Enum.each(&File.mkdir_p!/1)
  end
  

  defp create_files(project_root, demo_root, lib_demo_root, lib_root, test_root, domain_root, domain, module) do
    
    write!(
      Path.join(project_root, "mix.exs"),
      PathwaysNew.Templates.Mix.render(module, domain)
    )
    
    write!(
      Path.join(lib_root, "#{domain}.ex"),
      PathwaysNew.Templates.Domain.render(module)
    )
    
    write!(
      Path.join(lib_root, "dsl.ex"),
      # Templates.pathway(domain, module)
      PathwaysNew.Templates.DSL.render(module)
    )
    
    write!(
      Path.join(lib_root, "fact.ex"),
      # Templates.pathway(domain, module)
      PathwaysNew.Templates.Fact.render(module)
    )
    
    write!(
      Path.join(lib_root, "entity.ex"),
      # Templates.pathway(domain, module)
      PathwaysNew.Templates.Entity.render(module)
    )
    
    write!(
      Path.join(lib_root, "entities.ex"),
      # Templates.pathway(domain, module)
      PathwaysNew.Templates.Entities.render(module)
    )
    
    write!(
      Path.join(lib_root, "graph.ex"),
      # Templates.pathway(domain, module)
      PathwaysNew.Templates.Graph.render(module)
    )
    
    write!(
      Path.join(lib_root, "collection.ex"),
      # Templates.pathway(domain, module)
      PathwaysNew.Templates.Collection.render(module)
    )
    
    write!(
      Path.join(lib_root, "role.ex"),
      # Templates.pathway(domain, module)
      PathwaysNew.Templates.Domain.Role.render(module)
    )
  
    
    write!(
      Path.join(demo_root, "demo.exs"),
      Demo.render(module)
    )
    
    write!(
      Path.join(lib_demo_root, "basic_pathway.ex"),
      # Templates.pathway(domain, module)
      BasicPathway.render(module)
    )
    
    write!(
      Path.join(lib_demo_root, "domain_demo.ex"),
      # Templates.pathway(domain, module)
      Demo.render(module)
    )
    
    write!(
      Path.join(lib_demo_root, "text_renderer.ex"),
      # Templates.pathway(domain, module)
      TextRenderer.render(module)
    )
    
    write!(
      Path.join(lib_demo_root, "html_renderer.ex"),
      # Templates.pathway(domain, module)
      HtmlRenderer.render(module)
    )
    
    write!(
      Path.join(test_root, "test_helper.exs"),
      PathwaysNew.Templates.TestHelper.render()
    )
    
    
    write!(
      Path.join(test_root, "#{domain}_test.exs"),
      PathwaysNew.Templates.Test.render(module)
    )

    write!(
      Path.join(lib_root, "pathway.ex"),
      # Templates.pathway(domain, module)
      PathwaysNew.Templates.Domain.Pathway.render(module)
    )
    
    write!(
      Path.join(domain_root, "signal.ex"),
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
      Path.join([lib_root, "signals", "signals.ex"]),
      # Templates.signals(module)
      PathwaysNew.Templates.Signals.render(module)
    )

    write!(
      Path.join([lib_root, "mechanisms", "mechanisms.ex"]),
      # Templates.mechanisms(module)
      PathwaysNew.Templates.Mechanisms.render(module)
    )

    write!(
      Path.join([lib_root, "interventions", "interventions.ex"]),
      # Templates.interventions(module)
      PathwaysNew.Templates.Interventions.render(module)
    )
    
    write!(
      Path.join([lib_root, "indicated_agents", "indicated_agents.ex"]),
      # Templates.signals(module)
      PathwaysNew.Templates.IndicatedAgents.render(module)
    )
    

    write!(
      Path.join([lib_root, "regimens", "regimens.ex"]),
      # Templates.regimens(module)
      PathwaysNew.Templates.Regimens.render(module)
    )

    write!(
      Path.join(lib_root, "aliases.ex"),
      # Templates.aliases(module)
      PathwaysNew.Templates.Aliases.render(module)
    )
    
    write!(
      Path.join(lib_root, "conditions.ex"),
      # Templates.aliases(module)
      PathwaysNew.Templates.Conditions.render(module)
    )

    write!(
      Path.join(lib_root, "sources.ex"),
      # Template.sources(module)
      PathwaysNew.Templates.Sources.render(module)
    )

  end

  defp write!(path, contents) do
    File.write!(path, contents)
    Mix.shell().info("* creating #{path}")
  end
end