defmodule PathwaysNew.Templates.IndicatedAgents do
  @moduledoc """
  Generates the IndicatedAgents module for a new domain.
  """

  def render(module) do
	"""
	defmodule #{module}.IndicatedAgents do
	  @moduledoc false
	  use #{module}.Collection, attribute: :indicated_agents
	  import #{module}.DSL
	

		# indicated_agent :ACE_inhibitors,  #Angiotensin-Converting Enzyme Inhibitors 
		#   description: "ACE (Angiotensin-Converting Enzyme) inhibitors are oral agents (e.g., Lisinopril, Ramipril) that block angiotensin II production and reduce intraglomerular pressure, serving as first-line renoprotection.",
		#   category: :ACE_inhibitor_antihypertensive,
		#   status: :first_line_standard_of_care_for_proteinuric_CKD,
		#   contraindicated_by: [:history_of_ACE_induced_angiodema, :renal_artery_stenosis, :pregnancy, :lactation, :hyperkalemia, :use_of_aliskiren],
		#   interventions: [:nitric_oxide_signaling, :nad_precursor_supplementation, :RAAS_blockade]

	end
	"""
  end
end