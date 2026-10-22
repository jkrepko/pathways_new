defmodule PathwaysNew.Templates.Test do
  @moduledoc """
  Generates the Test module for a new domain.
  """

  def render(module) do
  """
  defmodule #{module}.Test do
    @moduledoc false

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
  end
  """
  end
end