defmodule PathwaysNew.Templates.Entity do
	@moduledoc """
	  An Entity is the fundamental building block of everything in Pathways - currently described by:
	
	  - Entity.id - what is the name or unique identifier for the Entity?
	  - Entity.kind - what kind (e.g. mechanism, signal...) is the Entity
	  - Entity.relations  what kinds of interactions does the Entity have with other Entities
	"""
	
    def render(module) do
	  """
      defprotocol  #{module}.Entity do
	  @moduledoc false

	  def id(entity)
	  def kind(entity)
	  def relations(entity)
	
	end
	"""
    end
end