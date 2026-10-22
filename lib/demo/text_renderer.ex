defmodule TextRenderer do
  @moduledoc false

  def render(module) do
	"""
	  defmodule #{module}.Demo.TextRenderer do
	  @moduledoc false
	
	  alias #{module}.Demo.#{module}Demo
	
	  def render(demos) do
		demos
		|> Enum.map(&render_demo/1)
		|> Enum.join("\n\n")
	  end
	
	  defp render_demo(demo) do

		============================================================
	    \#{"Pathways Example: #{module}"}
		============================================================
	
		Queries: To understand the system, we can ask some questions about #{module}:
		-------
		
	    \#{render_queries(demo.queries)}
	   
	   
		Domain definition
		-----------------
	
		Mechanisms:
	    \#{render_mechanisms(demo.mechanisms)}
		
		Interventions:
	    \#{render_interventions(demo.interventions)}
	
		Signals:
	    \#{render_items(demo.signals)}
	
		Regimens:
	    \#{render_regimens(demo.regimens)}
	
		Conditions:
	    \#{render_conditions(demo.conditions)}
	
	  end
	
	  defp render_items([]), do: "  none yet"
	
	  defp render_items(items) do
	  items
	  |> Enum.map(fn item ->
		item
		|> #{module}Demo.get(:name, item)
		|> english_name()
	  end)
	  |> Enum.sort_by(&String.downcase/1)
	  |> Enum.map(&"  - \#{&1}")
	  |> Enum.join("\n")
	  end
	
	  defp render_mechanisms([]), do: "  none yet"
	
	  defp render_mechanisms(mechanisms) do
		mechanisms
		|> Enum.sort_by(fn mechanism ->
		  mechanism
		  |>#{module}Demo.get(:name, :unnamed_mechanism)
		  |> english_name()
		  |> String.downcase()
		end)
		|> Enum.map(&render_mechanism/1)
		|> Enum.join("\n\n")
	  end
	
	  defp render_mechanism(m) do
		\"\"\"
		  - \#{english_name(#{module}Demo.get(m, :name, :unnamed_mechanism))}
			description:  \#{#{module}Demo.get(m, :description, :none_given)}
			consumes:    \#{english_list(#{module}Demo.get(m, :consumes, []))}
			produces:    \#{english_list(#{module}Demo.get(m, :produces, []))}
			explains:    \#{english_list(#{module}Demo.get(m, :explains, []))}
			inhibits:    \#{english_list(#{module}Demo.get(m, :inhibits, []))}
			inhibited by: \#{english_list(#{module}Demo.get(m, :inhibited_by, []))}
		\"\"\"
	  end
	
	
	  defp render_conditions([]), do: "  none yet"
	
		defp render_conditions(conditions) do
		  conditions
		  |> Enum.map(&render_condition/1)
		  |> Enum.join("\n\n")
		end
	
		defp render_condition(m) do
		  \"\"\"
		  - \#{english_name(#{module}Demo.get(m, :name, :unnamed_condition))}
			effects:    \#{english_list(#{module}Demo.get(m, :effects, []))}
			mechanisms:    \#{english_list(#{module}Demo.get(m, :mechanisms, []))}
			explains:    \#{english_list(#{module}Demo.get(m, :explains, []))}
			signals: \#{english_list(#{module}Demo.get(m, :signals, []))}
			interventions: \#{english_list(#{module}Demo.get(m, :interventions, []))}
			confidence:  \#{#{module}Demo.get(m, :confidence, :unknown)}
          \"\"\"
	    end
	
	
	 defp render_interventions([]), do: "  none yet"
	
	 defp render_interventions(interventions) do
	  interventions
	  |> Enum.sort_by(fn intervention ->
		intervention
		|> #{module}Demo.get(:name, :unnamed_intervention)
		|> english_name()
		|> String.downcase()
	  end)
	  |> Enum.map(&render_intervention/1)
	  |> Enum.join("\n\n")
	 end
	
	 defp render_intervention(m) do
	 \"\"\"
	  - \#{english_name(#{module}Demo.get(m, :name, :unnamed_intervention)}
		  enhances:      \#{english_list(#{module}Demo.get(m, :enhances, []))}
		  inhibits:      \#{english_list(#{module}Demo.get(m, :inhibits, []))}
		  reduces:       \#{english_list(#{module}Demo.get(m, :reduces, []))}
		  increases_risk_of: \#{english_list(#{module}Demo.get(m, :increases_risk_of, []))}
		  indicated_agents: \#{english_list(#{module}Demo.get(m, :indicated_agents, []))}
	  \"\"\""
	 end
	
	  defp render_regimens([]), do: "  none yet"
	
	  defp render_regimens(regimens) do
		regimens
		|> Enum.map(&render_regimen/1)
		|> Enum.join("\n\n")
	  end
	
	  defp render_regimen(m) do
		\"\"\"
		  - \#{english_name(#{module}Demo.get(m, :name, :unnamed_regimen))}
			interventions:    \#{english_list(#{module}Demo.get(m, :interventions, []))}
			risks:      \#{english_list(#{module}Demo.get(m, :risks, []))}
		\"\"\"
	  end
	
	  defp render_queries(queries) do
		queries
		|> Enum.map(fn q ->
		  \"\"\"
		  Q: \#{q.question}
		  A:
	      \#{render_query_answer(q.answer)}
		  \"\"\"
		end)
		|> Enum.join("\n")
	  end
	
	
	  defp render_query_answer([]), do: "  No results found yet."
	
	  defp render_query_answer(items) when is_list(items) do
		items
		|> Enum.map(&render_query_item/1)
		|> Enum.join("\n")
	  end
	
	  defp render_query_answer(item), do: render_query_item(item)
	  
	  defp humanize(atom) when is_atom(atom) do
		atom
		|> Atom.to_string()
		|> humanize()
	  end
	  
	  defp humanize(text) when is_binary(text) do
		text
		|> String.replace("_", " ")
	  end
	
	  defp render_query_item(%{name: name, description: description}) do
		\"\"\"
		- \#{humanize(name)}
	\#{description}
		\"\"\"
	  end
	  
	  defp render_query_item({name, opts}) when is_atom(name) and is_list(opts) do
		when_value = Keyword.get(opts, :when)
		direction = Keyword.get(opts, :direction)
	  
		"\#{name} (when: \#{when_value}, direction: \#{direction})"
	  end
	  
	
	  defp render_query_item(%{name: name}) when not is_nil(name) do
		"  - \#{humanize(name)}"
	  end
	
		defp render_query_item(atom) when is_atom(atom) do
		"  - \#{atom |> Atom.to_string() |> humanize()}"
	  end
	
	  defp render_query_item(binary) when is_binary(binary) do
		"  - \#{humanize(binary)}"
	  end
	  
	
	
	  defp english_list([]), do: "none"
	  defp english_list(nil), do: "none"
	
	  defp english_list(items) do
		items
		|> List.wrap()
		|> Enum.map(&english_name/1)
		|> Enum.join(", ")
	  end
	
	  defp english_name(values) when is_list(values) do
		values
		|> Enum.map(&english_name/1)
		|> Enum.join(", ")
	  end
	
	  defp english_name(atom) when is_atom(atom) do
		atom
		|> Atom.to_string()
		|> String.replace("_", " ")
	  end
	
	  defp english_name(value), do: to_string(value)
	end
	"""
  end
end