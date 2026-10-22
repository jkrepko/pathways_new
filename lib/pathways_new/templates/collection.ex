defmodule PathwaysNew.Templates.Collection do
  @moduledoc """
  Generates the canonical vocabulary module for a new domain.
  """

  def render(module) do
	"""
	defmodule #{module}.Collection do
	  @moduledoc false
	
	  defmacro __using__(opts) do
		attribute = Keyword.fetch!(opts, :attribute)
	
		quote do
		  Module.register_attribute(
			__MODULE__,
			unquote(attribute),
			accumulate: true
		  )
	
		  @before_compile #{module}.Collection
		  @collection_attribute unquote(attribute)
		end
	  end
	
	  defmacro __before_compile__(env) do
		attribute =
		  Module.get_attribute(env.module, :collection_attribute)
	
		items =
		  env.module
		  |> Module.get_attribute(attribute)
		  |> Enum.reverse()
	
		quote do
		  def all do
			unquote(Macro.escape(items))
		  end
		end
	  end	
	end
	"""
  end
end