defmodule PathwaysNew.Templates.Interventions do
  @moduledoc """
  Generates the Interventions module for a new domain.
  """

  def render(module) do
    """
    defmodule #{module}.Interventions do
      @moduledoc false
      use #{module}.Collection, attribute: :interventions
      import #{module}.DSL
    

       # intervention :blood_pressure_control do
        #   description "Management of elevated blood pressure."
        # 
        #   effects [
        #     hypertension: [when: :increased, direction: :decreased]
        #   ]
        # 
        #   indicated_agents [
        #     aspirin: [when: :increased, direction: :decreased]
        #   ]
       # end

    end
    """
  end
end