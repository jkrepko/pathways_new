defmodule PathwaysNew.Templates.Domain.Role do
  @moduledoc """
  Generates the Role value for a new domain.
  """

  def render(module) do
	"""
	  defmodule #{module}.Domain.Role do
	    @moduledoc false
	    @roles [:protective, :pathogenic, :double_edged]
	
	    def all, do: @roles
	    def valid?(role), do: role in @roles
	end
	"""
  end
end