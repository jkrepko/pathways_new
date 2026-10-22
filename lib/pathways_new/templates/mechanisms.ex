defmodule PathwaysNew.Templates.Mechanisms do
  @moduledoc """
  Generates the Mechanisms module for a new domain.
  """

  def render(module) do
	"""
	defmodule #{module}.Mechanisms do
	  @moduledoc false
	  use #{module}.Collection, attribute: :mechanisms
	  import #{module}.DSL

		# mechanism :example_mechanism do
		#   description "..."
		#   consumes []
		#   produces []
		#   explains []
		#   enhances []
		#   enhanced_by []
		#   inhibits []
		#   inhibited_by []
		# end

	end
	"""
  end
end