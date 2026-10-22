defmodule PathwaysNew.Templates.Signals do
  @moduledoc """
  Generates the Signals module for a new domain.
  """

  def render(module) do
    """
    defmodule #{module}.Signals do
      @moduledoc false
      use Osteoporosis.Collection, attribute: :signals
      import #{module}.DSL

        # signal :serum_creatinine do
        #   description "Concentration of creatinine in blood serum."
        #   signal_type :lab_result
        #
        #   indicates [
        #     reduced_kidney_function: [
        #       when: :increased,
        #       direction: :increased
        #     ]
        #   ]
        # end

    end
    """
  end
end