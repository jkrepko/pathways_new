defmodule Pathways.Domains.Osteoporosis do
  @moduledoc """
  Osteoporosis domain model.
  """

  import Pathways.DSL

  require Pathways.Domains.Osteoporosis.Signals
  require Pathways.Domains.Osteoporosis.Mechanisms
  require Pathways.Domains.Osteoporosis.Interventions
  require Pathways.Domains.Osteoporosis.Regimens
  require Pathways.Domains.Osteoporosis.Pathway

  def domain do
    pathway :osteoporosis do
      Pathways.Domains.Osteoporosis.Signals.signals()
      Pathways.Domains.Osteoporosis.Mechanisms.mechanisms()
      Pathways.Domains.Osteoporosis.Interventions.interventions()
      Pathways.Domains.Osteoporosis.Regimens.regimens()
      Pathways.Domains.Osteoporosis.Pathway.pathway_definition()
    end
  end
end