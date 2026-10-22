defmodule PathwaysNew.Templates.Initialize do
  @moduledoc """
  Generates the Initialization module for a new domain.
  """

  def render(module) do
	"""
  defmodule #{module} do
	alias #{module}.Domain.Pathway
  
	def name, do: :#{module}.name
  
	def pathway do
	  %Pathway{
		name: name(),
		conditions: #{module}.Conditions.all(),
		signals: #{module}.Signals.all(),
		mechanisms: #{module}.Mechanisms.all(),
		interventions: #{module}.Interventions.all(),
		indicated_agents: #{module}.IndicatedAgents.all(),
		regimens: #{module}.Regimens.all()
	  }
	end
  end
	"""
  end
end