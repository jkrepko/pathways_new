defmodule PathwaysNew.Templates.Sources do
  @moduledoc """
  Generates the Sources module for a new domain.
  """

  def render(module) do
	"""
	defmodule #{module}.Sources do
	  @moduledoc false
	  @sources %{
		  # guideline_1: %{
		  #   title: "...",
		  #   organization: "...",
		  #   year: 2026,
		  #   url: "..."
		  # }
		}
	  
		def all, do: @sources

	end
	"""
  end
end