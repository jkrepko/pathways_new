defmodule BasicPathway do
  @moduledoc false

  def render(module) do
	"""
	defmodule #{module}.Demo.BasicPathway do
	  @moduledoc false
	  # alias #{module}
	  alias #{module}
	
	  def modules do
		[
		  # InsulinResistance #,
		  #{module}
		  # CML
		]
	  end
	end
	"""
  end
end