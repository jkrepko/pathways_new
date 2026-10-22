defmodule PathwaysNew.Canonical do
  @moduledoc """
  DSL for defining canonical vocabulary and aliases.
  """

  defmacro __using__(_opts) do
	quote do
	  import PathwaysNew.Canonical

	  Module.register_attribute(
		__MODULE__,
		:canonical_entries,
		accumulate: true
	  )

	  @before_compile PathwaysNew.Canonical
	end
  end

  defmacro canonical(name, do: block) do
	quote do
	  @canonical_entries {
		unquote(name),
		unquote(Macro.escape(block))
	  }
	end
  end

  defmacro __before_compile__(env) do
	entries =
	  Module.get_attribute(env.module, :canonical_entries)

	quote do
	  def canonical_entries do
		unquote(Macro.escape(entries))
	  end
	end
  end
end