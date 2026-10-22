defmodule PathwaysNew.Templates.DomainTest do
  def render(module, domain) do
	"""
	defmodule #{module}Test do
	  use ExUnit.Case

	  test "domain has the correct name" do
		assert #{module}.name() == :#{domain}
	  end
	  
	  test "derives forward and inverse relationships" do
		fact = %Osteoporosis.Fact{
		  subject: :A_over_G_ratio,
		  relation: :indicates,
		  object: {:proteinuria, [when: :decreased, direction: :increased]},
		  provenance: :direct
		}
	  
		derived = Osteoporosis.Fact.derive(fact)
	  
		assert MapSet.new(derived) ==
				 MapSet.new([
				   %Osteoporosis.Fact{
					 subject: :A_over_G_ratio,
					 relation: :inhibits,
					 object: :proteinuria,
					 provenance: :derived
				   },
				   %Osteoporosis.Fact{
					 subject: :proteinuria,
					 relation: :inhibited_by,
					 object: :A_over_G_ratio,
					 provenance: :derived
				   }
				 ])
	  end
	  
	  test "p and g create correctly" do
		 p = Osteoporosis.pathway()
		 g = Osteoporosis.Graph.from_pathway(p)
		 assert length(g.facts) >= 10
	  end
	  
	end
	"""
  end
end