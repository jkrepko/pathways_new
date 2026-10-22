defmodule Pathways.Domains.Osteoporosis.Aliases do
  @moduledoc """
  Canonical vocabulary mappings for the osteoporosis domain.

  Use this module to record terminology encountered during domain
  development before silently collapsing concepts into one another.
  """

  @aliases %{
    # osteoclastic_resorption: :bone_resorption
  }

  def all, do: @aliases

  def canonical(term) do
    Map.get(@aliases, term, term)
  end
end