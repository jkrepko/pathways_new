defmodule PathwaysNew.Templates.Entities do
	@moduledoc """
  An Entity is the fundamental building block of everything in Pathways - currently described by:

	 pathway.signals ++
	 pathway.mechanisms ++
	 pathway.interventions ++
	 pathway.indicated_agents ++
	 pathway.conditions ++
	 pathway.regimens
	 
	 PathwaysLab.Entities.all_entites(pathway)
		asks: which are all of the building blocks used in Pathway pathway
  """
	
	def render(module) do
	  """
	  defmodule #{module}.Entities do
	  @moduledoc false

	  def all_entities(pathway) do
		 pathway.signals ++
		 pathway.mechanisms ++
		 pathway.interventions ++
		 pathway.indicated_agents ++
		 pathway.conditions ++
		 pathway.regimens
	  end
	
	end
	"""
	end
end