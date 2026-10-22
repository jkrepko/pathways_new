defmodule PathwaysNew.Templates.Domain.Intervention do
  @moduledoc """
  Generates the Interventions module for a new domain.
  """

  def render(module) do
	"""
	defmodule #{module}.Domain.Intervention do
		
	alias #{module}.Fact
	  
	  defstruct [
		:name,
		:description,
		effects: [],
		indicated_agents: []
	  ]
	
	defp listify(nil), do: []
	defp listify(value) when is_list(value), do: value
	defp listify(value), do: [value]
	
	
	def interventions_inhibit(pathway, condition) do
	  inhibited_mechanism_names =
		pathway.mechanisms
		|> Enum.filter(fn mechanism ->
		  condition in listify(Map.get(mechanism, :inhibits, []))
		end)
		|> Enum.map(& &1.name)
	
	  pathway.interventions
	  |> Enum.filter(fn intervention ->
		intervention
		|> Map.get(:inhibits, [])
		|> listify()
		|> Enum.any?(&(&1 in inhibited_mechanism_names))
	  end)
	  |> Enum.map(& &1.name)
	  |> Enum.uniq()
	end
	
	
	  def interventions_enhance(pathway, condition) do
		pathway.mechanisms
		|> Enum.filter(fn mechanism ->
		  condition in Map.get(mechanism, :produces, [])
		end)
		|> Enum.flat_map(fn mechanism ->
		  Map.get(mechanism, :enhances, [])
		end)
		|> Enum.uniq()
	  end
	  
	  def interventions_effect(intervention) do
		Enum.map(intervention.effects, fn effect ->
		  %Fact{
			subject: intervention.name,
			relation: :effects,
			object: effect
		  }
		end)
	  end
	
	  defimpl #{module}.Entity, for: #{module}.Domain.Intervention do
		def id(intervention), do: intervention.name
		def kind(_), do: :intervention
	
		def relations(intervention) do
		  [
			effects: intervention.effects,
			indicated_agents: intervention.indicated_agents
		  ]
		end
		def provenance, do: :direct
	  end
	end
	"""
  end
end