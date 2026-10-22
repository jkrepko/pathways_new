defmodule Demo do
  @moduledoc false

  def render(module) do
	"""
	defmodule #{module}.Demo.#{module}Demo do
	  @moduledoc false

	  alias #{module}
	  import #{module}.Graph
	
	  def describe(pathway_module) do
		pathway = pathway_module.pathway()
		graph = #{module}.Graph.from_pathway(pathway) 
	
		%{
		  module: pathway_module,
		  name: pathway_name(pathway_module, pathway),
		  signals: get(pathway, :signals, []),
		  mechanisms: get(pathway, :mechanisms, []),
		  interventions: get(pathway, :interventions, []),
		  regimens: get(pathway, :regimens, []),
		  conditions: get(pathway, :conditions, []),
		  queries: run_new_fn_queries(pathway)
		}
	  end
	
	 def describe_fn(pathway_module) do
	
	   pathway = pathway_module.pathway()
	   pathway_module
	   |> describe()
	   |> Map.put(:queries, run_new_fn_queries(pathway))
	 end
	
	defp run_new_fn_queries(pathway) do
		p = pathway
		g = Osteoporosis.Graph.from_pathway(p)
		indicated_agents = p.interventions |> Enum.flat_map(& &1.indicated_agents) |> Enum.uniq()
		facts = g.facts
		filtered_facts = Enum.reject(facts, fn fact -> fact.relation in [:indicates, :effects] end)
		derived_facts = g.facts |> Enum.flat_map(&Osteoporosis.Fact.derive/1)
		# queryable_facts = filtered_facts ++ derived_facts 
		g = %{g | facts: filtered_facts ++ derived_facts}
		[
		  %{
				question: "In my model, how many Mechanisms, Interventions, Signals, and Indicated Agents are there?",
				answer: "\#{length(p.mechanisms)} Mechanisms, \#{length(p.interventions)} Interventions, \#{length(p.signals)} Signals, and \#{length(indicated_agents)} Indicated Agents"
		   },
		   %{
				 question: "How many Facts does that add up to?",
				 answer: "\#{length(g.facts)} Facts"
			},
			%{
				 question: "How many relationships do you track?",
				 answer: " I track the these relationship types:\n \#{g.facts
														|> Enum.map(& &1.relation) 
														|> Enum.frequencies() 
														|> Enum.map(fn {k, v} -> "\#{k}: \#{v}" end) 
														|> Enum.join("\n")} relationships"
			},
			%{
				 question: "What kind of signals do you follow that I can track?",
				 answer: " I follow the these signals:\n \#{p.signals |> Enum.frequencies_by(& &1.signal_type) |> Enum.to_list() |> Enum.sort_by(fn {_signal_type, count} -> count end, :desc) |> Enum.map_join("\n", fn {type, count} -> "\#{type}: \#{count}" end)}"
			},
		   %{
				 question: "I keep a strict diet, and watch my Vitamin D. What mechanisms can this diet help?",
				 answer: subjects_that(g, :inhibited_by, :adequate_serum_calcium_and_vitamin_d_homeostasis) |> Enum.map(fn fact -> fact.subject end) |> Enum.uniq() |> Enum.sort()
			},
		   %{
			 question: "I'm fine with HRT - What mechanisms does HRT inhibit?",
			 # answer: mechanisms_consuming_fn(pathway, :glucose)
			 # answer: Executor.run(pathway, {:consume, :glucose})
			 answer: subjects_that(g, :inhibited_by, :hormone_replacement_therapy_hrt) 
								   |> Enum.map(fn fact -> fact.subject end) |> Enum.uniq() |> Enum.sort()
		   },
		   %{
				 question: "If I go 'health nut' what mechanisms can weight bearing exercise help?",
				 # answer: MapSet.to_list(subjects_that(g, :inhibited_by, [:blood_pressure_control,:weight_reduction,:exercise_training_therapy]))
				 answer: subjects_that(g, :inhibited_by, [:mechanical_loading_exercise,:regular_weight_bearing_exercise,:high_impact_mechanical_loading]) 
									   |> Enum.map(fn fact -> fact.subject end) |> Enum.uniq() |> Enum.sort()
			},
			%{
				 question: "Wow - that's a lot.  Suppose I just stick to Vitamin D and Calcium - what does that help?",
				 #answer: interventions_that(p, :effects, :dietary_sodium_reduction, when: :increased )
				 answer:  Enum.find(p.interventions, fn intervention -> intervention.name == :adequate_vitamin_d_and_calcium_status end).effects
						  |> Enum.filter(fn {_key, value} -> value == [when: :increased, direction: :decreased] end)
						  |> Map.new()
						  |> Map.keys()
			},
		]
	  end
	  
	
	  defp pathway_name(module, pathway) do
		get(pathway, :name, nil) ||
	module
	|> Module.split()
	|> List.last()
	|> Macro.underscore()
	|> String.replace("_", " ")
	|> String.capitalize()
	end
	
	def get(other, key, default) when is_struct(other) do
	  module = other.__struct__
	
	  if function_exported?(module, key, 0) do
		apply(module, key, [])
	  else
		Map.get(other, key, default)
	  end
	end
	
	def get(map, key, default) when is_map(map) do
	  Map.get(map, key, default)
	end
	
	def get(_other, _key, default), do: default
	
	end
	"""
  end
end