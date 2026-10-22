defmodule PathwaysNew.Templates.Test do
  @moduledoc """
  Generates the Test module for a new domain.
  """

  def render(module) do
  """
  defmodule #{module}.Test do
    use ExUnit.Case, async: true
    @moduledoc false

    test "derives forward and inverse relationships" do
      fact = %#{module}.Fact{
        subject: :A_over_G_ratio,
        relation: :indicates,
        object: {:proteinuria, [when: :decreased, direction: :increased]},
        provenance: :direct
      }
    
      derived = #{module}.Fact.derive(fact)
    
      assert MapSet.new(derived) ==
               MapSet.new([
                 %#{module}.Fact{
                   subject: :A_over_G_ratio,
                   relation: :inhibits,
                   object: :proteinuria,
                   provenance: :derived
                 },
                 %#{module}.Fact{
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