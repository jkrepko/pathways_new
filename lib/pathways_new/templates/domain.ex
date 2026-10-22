defmodule PathwaysNew.Templates.Domain do
  def render(module) do
    """
    defmodule #{module} do
      @moduledoc false
      alias Osteoporosis.Domain.Pathway
      
      def name, do: :osteoporosis
      
      def pathway do
        %Pathway{
          name: name(),
          signals: Osteoporosis.Signals.all(),
          mechanisms: Osteoporosis.Mechanisms.all(),
          interventions: Osteoporosis.Interventions.all(),
          indicated_agents: Osteoporosis.IndicatedAgents.all(),
          regimens: Osteoporosis.Regimens.all(),
          conditions: Osteoporosis.Conditions.all()
        }
      end
    end
    """
  end
end