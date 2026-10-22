defmodule PathwaysNew.Templates.Domain.IndicatedAgent do
  @moduledoc """
  Defines the IndicatedAgent struct and defimpl for a new domain.
  """

  def render(module) do
	"""
	defmodule #{module}.Domain.IndicatedAgent do
	  defstruct [
		:name,
		:description,
		:brand_name,
		:category,
		:status,
		contraindicated_by: [],
		interventions: []
	  ]
	  
	  defimpl #{module}.Entity, for: #{module}.Domain.IndicatedAgent do
		def id(indicated_agent), do: indicated_agent.name
		def kind(_), do: :indicated_agent
	  
		def relations(indicated_agent) do
		  [
			contraindicated_by: indicated_agent.contraindicated_by,
			interventions: indicated_agent.interventions
			]
		end
	  end
	end
	"""
  end
end