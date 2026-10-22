defmodule PathwaysNew.Templates.Domain.Condition do
  @moduledoc """
  Generates the Condition struct and defimpl for a new domain.
  """

  def render(module) do
	"""
	defmodule #{module}.Domain.Condition do
	  @moduledoc false
	  
	  defstruct [
		:name,
		description: nil,
		mechanisms: [],
		signals: [],
		interventions: []
	  ]
	
	defimpl #{module}.Entity, for: #{module}.Domain.Condition do
		def id(condition), do: condition.name
		def kind(_), do: :condition
	
		def relations(condition) do
		  [
			mechanisms: condition.mechanisms,
			signals: condition.signals,
			interventions: condition.interventions,
		  ]
		end
	  end
	end
	"""
  end
end