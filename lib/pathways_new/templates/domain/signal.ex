defmodule PathwaysNew.Templates.Domain.Signal do
  @moduledoc """
  Defines the Signals struct and defimpl for a new domain.
  """

  def render(module) do
	"""
	defmodule #{module}.Domain.Signal do
	  @moduledoc false
	  
	defstruct [
		:name,
		description: nil,
		signal_type: nil,
		indicates: nil,
		metadata: %{}
	  ]
	
		defimpl #{module}.Entity, for: #{module}.Domain.Signal do
		  def id(signal), do: signal.name
		  def kind(_), do: :signal
	
		  def relations(signal) do
			[
				indicates: signal.indicates,
			]
		  end
		  def provenance(), do: :derived
		end
	end
	"""
  end
end