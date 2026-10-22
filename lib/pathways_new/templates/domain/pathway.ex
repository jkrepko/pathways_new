defmodule PathwaysNew.Templates.Domain.Pathway do
  @moduledoc """
  Generates the Pathway structure for a new domain.
  """

  def render(module) do
    """
    defmodule #{module}.Domain.Pathway do
      defstruct [
        :name,
        conditions: [],
        signals: [],
        mechanisms: [],
        interventions: [],
        indicated_agents: [],
        regimens: []
      ]
      
      def new(attrs \\\\ []) do
        struct(__MODULE__, attrs)
      end
      
    end
    """
  end
end
    