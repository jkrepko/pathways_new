defmodule PathwaysNew.Templates.Validation do
  def render(module) do
	"""
	defmodule #{module}.Validation do
	  @moduledoc \"""
	  Domain-specific validation rules for #{module}.
	  \"""

	  def validate(domain) do
		# Eventually delegate to the shared Pathways Validator.
		# Pathways.Validator.validate(domain)

		{:ok, domain}
	  end
	end
	"""
  end
end