defmodule TextRenderer do

  @moduledoc false

  def render(module) do

	~S'''


	  defmodule OsteoTest.Demo.TextRenderer do
		  @moduledoc """
		  Renders text for demo display, or for passing to HtmlRenderer
		  """
		
		  alias OsteoTest.Demo.OsteoTestDemo
		
		  def render(demos) do
			demos
			|> Enum.map(&render_demo/1)
			|> Enum.join("\n\n")
		  end
		
		  defp render_demo(demo) do
			"""
			============================================================
			#{"Pathways Example: OsteoTest"}
			============================================================
		
			Queries: To understand the system, let's ask some questions about OsteoTest:
			-------
			
			#{render_queries(demo.queries)}
		   
		   
			Domain definition
			-----------------
		
			Mechanisms:
			#{render_mechanisms(demo.mechanisms)}
			
			Interventions:
			#{render_interventions(demo.interventions)}
		
			Signals:
			#{render_items(demo.signals)}
		
			Regimens:
			#{render_regimens(demo.regimens)}
		
			Conditions:
			#{render_conditions(demo.conditions)}
		
		
			"""
		  end
		
		#   defp render_items([]), do: "  none yet"
		# 
		#   defp render_items(items) do
		#     items
		#     |> Enum.map(fn item ->
		#       "  - #{english_name(OsteoTestDemo.get(item, :name, item))}"
		#     end)
		#     |> Enum.join("\n")
		#   end
		
		defp render_items([]), do: "  none yet"
		
		defp render_items(items) do
		  items
		  |> Enum.map(fn item ->
			item
			|> OsteoTestDemo.get(:name, item)
			|> english_name()
		  end)
		  |> Enum.sort_by(&String.downcase/1)
		  |> Enum.map(&"  - #{&1}")
		  |> Enum.join("\n")
		end
		
		  defp render_mechanisms([]), do: "  none yet"
		
		  defp render_mechanisms(mechanisms) do
			mechanisms
			|> Enum.sort_by(fn mechanism ->
			  mechanism
			  |>OsteoTestDemo.get(:name, :unnamed_mechanism)
			  |> english_name()
			  |> String.downcase()
			end)
			|> Enum.map(&render_mechanism/1)
			|> Enum.join("\n\n")
		  end
		
		  defp render_mechanism(m) do
			"""
			   - #{english_name(OsteoTestDemo.get(m, :name, :unnamed_mechanism))}
				description:  #{OsteoTestDemo.get(m, :description, :none_given)}
				consumes:    #{english_list(OsteoTestDemo.get(m, :consumes, []))}
				produces:    #{english_list(OsteoTestDemo.get(m, :produces, []))}
				explains:    #{english_list(OsteoTestDemo.get(m, :explains, []))}
				inhibits:    #{english_list(OsteoTestDemo.get(m, :inhibits, []))}
				inhibited by: #{english_list(OsteoTestDemo.get(m, :inhibited_by, []))}
			"""
		  end
		
		
		  defp render_conditions([]), do: "  none yet"
		
			defp render_conditions(conditions) do
			  conditions
			  |> Enum.map(&render_condition/1)
			  |> Enum.join("\n\n")
			end
		
			defp render_condition(m) do
			  """
			  - #{english_name(OsteoTestDemo.get(m, :name, :unnamed_condition))}
				  effects:    #{english_list(OsteoTestDemo.get(m, :effects, []))}
				  mechanisms:    #{english_list(OsteoTestDemo.get(m, :mechanisms, []))}
				  explains:    #{english_list(OsteoTestDemo.get(m, :explains, []))}
				  signals: #{english_list(OsteoTestDemo.get(m, :signals, []))}
				  interventions: #{english_list(OsteoTestDemo.get(m, :interventions, []))}
				  confidence:  #{OsteoTestDemo.get(m, :confidence, :unknown)}
			  """
			end
		
		
		defp render_interventions([]), do: "  none yet"
		
		defp render_interventions(interventions) do
		  interventions
		  |> Enum.sort_by(fn intervention ->
			intervention
			|> OsteoTestDemo.get(:name, :unnamed_intervention)
			|> english_name()
			|> String.downcase()
		  end)
		  |> Enum.map(&render_intervention/1)
		  |> Enum.join("\n\n")
		end
		
		defp render_intervention(m) do
		  """
		  - #{english_name(OsteoTestDemo.get(m, :name, :unnamed_intervention))}
			  enhances:      #{english_list(OsteoTestDemo.get(m, :enhances, []))}
			  inhibits:      #{english_list(OsteoTestDemo.get(m, :inhibits, []))}
			  reduces:       #{english_list(OsteoTestDemo.get(m, :reduces, []))}
			  increases_risk_of: #{english_list(OsteoTestDemo.get(m, :increases_risk_of, []))}
			  indicated_agents: #{english_list(OsteoTestDemo.get(m, :indicated_agents, []))}
		  """
		end
		
		  defp render_regimens([]), do: "  none yet"
		
		  defp render_regimens(regimens) do
			regimens
			|> Enum.map(&render_regimen/1)
			|> Enum.join("\n\n")
		  end
		
		  defp render_regimen(m) do
			"""
			   - #{english_name(OsteoTestDemo.get(m, :name, :unnamed_regimen))}
				interventions:    #{english_list(OsteoTestDemo.get(m, :interventions, []))}
				risks:      #{english_list(OsteoTestDemo.get(m, :risks, []))}
			"""
		  end
		
		  defp render_queries(queries) do
			queries
			|> Enum.map(fn q ->
			  """
			  Q: #{q.question}
			  A:
			  #{render_query_answer(q.answer)}
			  """
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
			"""
			- #{humanize(name)}
				#{description}
			"""
		  end
		  
		  defp render_query_item({name, opts}) when is_atom(name) and is_list(opts) do
			when_value = Keyword.get(opts, :when)
			direction = Keyword.get(opts, :direction)
		  
			"#{name} (when: #{when_value}, direction: #{direction})"
		  end
		  
		
		  defp render_query_item(%{name: name}) when not is_nil(name) do
			"  - #{humanize(name)}"
		  end
		
			defp render_query_item(atom) when is_atom(atom) do
			"  - #{atom |> Atom.to_string() |> humanize()}"
		  end
		
		  defp render_query_item(binary) when is_binary(binary) do
			"  - #{humanize(binary)}"
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

	

	'''

	|> String.replace("__DOMAIN__", module)

  end

end