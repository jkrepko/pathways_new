defmodule PathwaysNew.Templates.Regimens do
  @moduledoc """
  Generates the Regimens module for a new domain.
  """

  def render(module) do
	"""
	defmodule #{module}.Regimens do
	use Osteoporosis.Collection, attribute: :regimens
	import #{module}.DSL
	
	  @moduledoc false

	  # regimen :sample_regimen do
	  #   description "sample test for regimen"
	  #   interventions []
	  #   intended_effects []
	  # end
	  
	  end

	  # Add regimens here.

	"""
  end
end