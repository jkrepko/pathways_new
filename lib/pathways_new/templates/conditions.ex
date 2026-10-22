defmodule PathwaysNew.Templates.Conditions do
  @moduledoc """
  Generates the Conditions module for a new domain.
  """

  def render(module) do
	"""
	defmodule #{module}.Conditions do
	  @moduledoc false
	  use #{module}.Collection, attribute: :conditions
	  import #{module}.DSL

		# condition :sample_condition do
		#   description "..."
		#   mechanisms []
		#   signals []
		#   interventions []
		# end

	end
	"""
  end
end