defmodule PathwaysNew.Templates.Validator do
  @moduledoc """
  Generates the Validator QA tool for a new domain.
  """

  def render(module) do
	"""
	
	defmodule #{module}.Validator do
	  @moduledoc false
	
	  def validate(pathway) do
		[
		  {:missing_signals, missing_signals(pathway)},
		  # {:missing_mechanisms, missing_mechanisms(pathway)},
		  {:missing_intervention_targets, missing_intervention_targets(pathway)}, 
		  {:missing_interventions, missing_interventions(pathway)},           # Comment out for relations-free result
		  {:unused_signals, unused_signals(pathway)},                         # Comment out for relations-free result
		  {:unused_interventions, unused_interventions(pathway)},
		  {:invalid_regimen_members, invalid_regimen_members(pathway)},
		  {:orphan_mechanisms, orphan_mechanisms(pathway)}
		]
	  end
	
	  def report(pathway) do
		pathway
		|> validate()
		|> Enum.each(fn {category, items} ->
		  print_category(category, items)
		end)
	
		:ok
	  end
	
	  defp print_category(category, []) do
		IO.puts("✓ \#{humanize(category)}")
	
	  defp print_category(category, items) do
		IO.puts("")
		IO.puts("✓ \#{humanize(category)}")
	
		Enum.each(items, fn item ->
		  IO.puts("  - \#{inspect(item)}")
		end)
	  end
	
	defp humanize(atom) do
	  atom
	  |> Atom.to_string()
	  |> String.replace("_", " ")
	  |> String.split()
	  |> Enum.map_join(" ", &String.capitalize/1)
	end
	
	defp missing_signals(pathway) do
	  defined_signals =
		pathway.signals
		|> Enum.map(& &1.name)
		|> MapSet.new()
	
	  defined_mechanisms =
		pathway.mechanisms
		|> Enum.map(& &1.name)
		|> MapSet.new()
	
	  defined_references =
		MapSet.union(defined_signals, defined_mechanisms)
	
	  referenced_signals =
		pathway.mechanisms
		|> Enum.flat_map(fn mechanism ->
		  mechanism.consumes ++ mechanism.produces
		end)
		|> MapSet.new()
	
	  MapSet.difference(referenced_signals, defined_references)
	end
	
	defp missing_intervention_targets(pathway) do
	  defined_mechanisms =
		pathway.mechanisms
		|> Enum.map(& &1.name)
		|> MapSet.new()
	
	  defined_signals =
		pathway.signals
		|> Enum.map(& &1.name)
		|> MapSet.new()
	
	  defined_targets =
		MapSet.union(defined_mechanisms, defined_signals)
	
	  referenced_targets =
		pathway.interventions
		|> Enum.flat_map(fn intervention ->
		  intervention.effects # ++ intervention.inhibits
		end)
		|> MapSet.new()
	
	  MapSet.difference(referenced_targets, defined_targets)
	end
	
	# defp missing_interventions(pathway) do
	#   defined_interventions =
	#     pathway.interventions
	#     |> Enum.map(& &1.name)
	#     |> MapSet.new()
	# 
	#   referenced_interventions =
	#     pathway.mechanisms
	#     |> Enum.flat_map(fn mechanism ->
	#       mechanism.enhanced_by ++ mechanism.inhibited_by
	#     end)
	#     |> MapSet.new()
	# 
	#   MapSet.difference(referenced_interventions, defined_interventions)
	# end
	
	defp intervention_candidates(mechanism) do
	  case mechanism.role do
		:pathogenic ->
		  mechanism.inhibited_by
	
		:protective ->
		  [mechanism.name]
	
		:double_edged ->
		  []
	
		_ ->
		  []
	  end
	end
	
	defp missing_interventions(pathway) do
	  defined_interventions =
		pathway.interventions
		|> Enum.map(& &1.name)
		|> MapSet.new()
	
	  candidate_interventions =
		pathway.mechanisms
		|> Enum.flat_map(&intervention_candidates/1)
		|> MapSet.new()
	
	  MapSet.difference(candidate_interventions, defined_interventions)
	end
	
	  defp unused_signals(pathway) do
		defined_signals =
		  pathway.signals
		  |> Enum.map(& &1.name)
		  |> MapSet.new()
	  
		mechanism_signals =
		  pathway.mechanisms
		  |> Enum.flat_map(fn mechanism ->
			mechanism.consumes ++
			  mechanism.produces ++
			  mechanism.explains ++
			  mechanism.inhibits ++
			  mechanism.inhibited_by ++
			  mechanism.enhances ++
			  mechanism.enhanced_by
		  end)
		  |> MapSet.new()
	  
		intervention_signals =
		  pathway.interventions
		  |> Enum.flat_map(fn intervention ->
			# intervention.inhibits ++ intervention.enhances
			intervention.effects
		  end)
		  |> MapSet.new()
		  |> MapSet.intersection(defined_signals)
	  
		referenced_signals =
		  MapSet.union(mechanism_signals, intervention_signals)
	  
		MapSet.difference(defined_signals, referenced_signals)
	  end
	
	  defp unused_interventions(pathway) do
	  defined_interventions =
		pathway.interventions |> Enum.map(& &1.name) |> MapSet.new()
	
		referenced_interventions =
		  pathway.mechanisms
		  |> Enum.flat_map(fn mechanism ->
			 mechanism.enhances ++ mechanism.inhibits ++ mechanism.inhibited_by
		  end)
		  |> MapSet.new()
	
		  MapSet.difference(defined_interventions, referenced_interventions)
	  end
	
	  defp invalid_regimen_members(pathway) do
		pathway.regimens
		[]
	  end
	
	  defp orphan_mechanisms(pathway) do
		pathway.mechanisms
		[]
	  end
	  
	  defp orphan_mechanisms(pathway) do
		  pathway.mechanisms
		  |> Enum.filter(fn m ->
			Enum.all?(
			  [
				m.produces,
				m.explains,
				m.enhances,
				m.enhanced_by,
				m.inhibits,
				m.inhibited_by
			  ],
			  &(&1 == [])
			)
		  end)
		  |> Enum.map(& &1.name)
		  |> MapSet.new()
		end
		
		# defp mechanisms_without_family(p) do
		  # p.mechanisms
		  # |> Enum.filter(&is_nil(&1.family))
		  # |> Enum.map(& &1.name)
		  # |> MapSet.new()
		# end
	
	end
	
	
	"""
  end
end