defmodule PathwaysNew.Templates.Domain do
  def render(module) do
    """
    defmodule #{module} do
      @moduledoc false
      alias #{module}.Domain.Pathway
      
      def name, do: :osteoporosis
      
      def pathway do
        %Pathway{
          name: name(),
          signals: #{module}.Signals.all(),
          mechanisms: #{module}.Mechanisms.all(),
          interventions: #{module}.Interventions.all(),
          indicated_agents: #{module}.IndicatedAgents.all(),
          regimens: #{module}.Regimens.all(),
          conditions: #{module}.Conditions.all()
        }
      end
    end
    """
  end
end