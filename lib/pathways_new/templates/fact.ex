defmodule PathwaysNew.Templates.Fact do
  @moduledoc """
  A normalized graph fact.

  Each fact is a simple directed triple:

	  subject --relation--> object

  Example:

	  %PathwaysLab.Fact{
		subject: :insulin_resistance,
		relation: :produces,
		object: :inflammation,
		provenance: :direct
	  }
  """
  
  def render(module) do
	"""
	defmodule #{module}.Fact do
	@moduledoc false
	
	defstruct [:subject, :relation, :object, :provenance]
	
	defp directional_relation(when_val, direction) do
	case {when_val, direction} do
	{:increased, :increased} -> :enhances
	{:increased, :decreased} -> :inhibits
	{:decreased, :increased} -> :inhibits
	{:decreased, :decreased} -> :enhances
	_ -> nil
	end
	end
	
	defp derive_directional_facts(subject, object, :inhibits) do
	[
	%#{module}.Fact{
		subject: subject,
		relation: :inhibits,
		object: object,
		provenance: :derived
	},
	%#{module}.Fact{
		subject: object,
		relation: :inhibited_by,
		object: subject,
		provenance: :derived
	}
	]
	end
	
	defp derive_directional_facts(subject, object, :enhances) do
	[
	%#{module}.Fact{
		subject: subject,
		relation: :enhances,
		object: object,
		provenance: :derived
	},
	%#{module}.Fact{
		subject: object,
		relation: :enhanced_by,
		object: subject,
		provenance: :derived
	}
	]
	end
	
	
	def derive(%#{module}.Fact{
		subject: subject,
		relation: relation,
		object: {object, opts},
		provenance: :direct
	})
	when relation in [:indicates, :effects] do
	
	when_val = Keyword.get(opts, :when)
	direction = Keyword.get(opts, :direction)
	
	case directional_relation(when_val, direction) do
	nil ->
		[]
	
	# derived_relation ->
	#   [
	#     %#{module}.Fact{
	#       subject: subject,
	#       relation: derived_relation,
	#       object: object,
	#       provenance: :derived
	#     }
	#   ]
	derived_relation -> derive_directional_facts(subject, object, derived_relation)
	end
	end
	
	def derive(_fact), do: []
	
	end
	
	"""
  end
end