defmodule PathwaysNew.Templates.Aliases do
  @moduledoc """
  Generates the canonical vocabulary module for a new domain.
  """

  def render(module) do
    """
    defmodule #{module}.Aliases do
      @moduledoc \"""
      Canonical vocabulary and terminology mappings.
      \"""

      @canonical %{
        # bone_resorption: %{
        #   description: "...",
        #   aliases: [
        #     :osteoclastic_resorption
        #   ],
        #   not_equivalent_to: [
        #     :bone_loss
        #   ]
        # }
      }

      def all, do: @canonical

      def canonical(term) when is_atom(term) do
        Enum.find_value(@canonical, term, fn {name, entry} ->
          if term == name or term in entry.aliases do
            name
          end
        end)
      end

      def resolve(term) when is_atom(term) do
        result = canonical(term)

        cond do
          result != term ->
            {:ok, result}

          Map.has_key?(@canonical, term) ->
            {:ok, term}

          true ->
            {:error, :unknown_term}
        end
      end
    end
    """
  end
end