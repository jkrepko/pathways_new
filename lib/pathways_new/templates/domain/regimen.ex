defmodule PathwaysNew.Templates.Domain.Regimen do
  @moduledoc """
  Generates the Regimen definition for a new domain.
  """

  def render(module) do
	"""
	defmodule #{module}.Domain.Regimen do
	  @moduledoc false
	  
	defstruct [
		:name,
		description: nil,
		interventions: [],
		intended_effects: [],
		risks: [],
		confidence: :unknown
	  ]
	
	  defimpl #{module}.Entity, for: #{module}.Domain.Regimen do
		def id(regimen), do: regimen.name
		def kind(_), do: :regimen
	
		def relations(regimen) do
		  [
			interventions: regimen.interventions,
			intended_effects: regimen.intended_effects,
			risks: regimen.risks,
		  ]
		end
	  end
	end
	"""
  end
end