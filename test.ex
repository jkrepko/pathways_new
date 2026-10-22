defmodule Pathways.Domains.OsteoporosisTest do
  use ExUnit.Case

  alias Pathways.Domains.Osteoporosis

  test "domain is valid" do
    domain = Osteoporosis.domain()

    assert Validator.validate(domain).missing_signals == MapSet.new()
    assert Validator.validate(domain).missing_mechanisms == MapSet.new()
    assert Validator.validate(domain).missing_intervention_targets == MapSet.new()
  end
end