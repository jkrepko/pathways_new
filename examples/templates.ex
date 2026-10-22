defmodule PathwaysNew.Templates do
  @moduledoc """
  Templates used to generate new Pathways applications.
  """

  
  defp signals(module) do
	  """
	  defmodule Pathways.Domains.#{module}.Signals do
	  @moduledoc \"""
	  Signals belonging to the #{module} domain.
    \"""
	  defmacro signals do
		  quote do
			# signal :example_signal do
			#   description "..."
			#   signal_type :molecule
			# end
		  end
	  end
	  end
	  """
	end

  defp mechanisms(module) do
	"""
	defmodule Pathways.Domains.#{module}.Mechanisms do
	  @moduledoc \"""
	  Mechanisms belonging to the #{module} domain.
	  \"""
  
	  defmacro mechanisms do
		quote do
		  # mechanism :example_mechanism do
		  #   description "..."
		  #   consumes []
		  #   produces []
		  # end
		end
	  end
	end
	"""
  end

  defp interventions(module) do
	"""
	defmodule Pathways.Domains.#{module}.Interventions do
	@moduledoc \"""
	Interventions belonging to the #{module} domain.
	\"""
  
	defmacro interventions do
		quote do
		  # intervention :example_signal do
		  #   description "..."
		  #   effects []
		  #   indicated_agents []
		  # end
		end
	  end
	end
	"""
  end
  
  defp regimens(module) do
	  """
	  defmodule Pathways.Domains.#{module}.Regimens do
	  @moduledoc \"""
	  Regimens belonging to the #{module} domain.
	  \"""
	
	  defmacro regimens do
		  quote do
			# regimen :RAAS_blockade do
			#   description "..."
			#   interventions []
			#   intended_effects []
			#   risks []
			#   confidence
			# end
		    end
		  end
	  end
	  """
	end
	
	defp domain(module) do
	  """
	  defmodule Pathways.Domains.#{module}.Domain do
	  @moduledoc \"""
	  Domain belonging to the #{module} domain.
	  \"""
	
	  defmacro domain do
		  quote do
			# 
			end
		  end
	  end
	  """
	end
	
	defp pathway(module) do
	  """
	  defmodule Pathways.Domains.#{module}.Pathway do
	  @moduledoc \"""
	  Pathway belonging to the #{module} domain.
	  \"""
	
	  defmacro pathway do
		  quote do
			# 
			end
		  end
	  end
	  """
	end
	
	defp aliases(module) do
	  """
	  defmodule Pathways.Domains.#{module}.Aliases do
	  @moduledoc \"""
	  Aliases belonging to the #{module} domain.
	  \"""
	
	  defmacro aliases do
		  quote do
			# 
			end
		  end
	  end
	  """
	end
	
	defp sources(module) do
	  """
	  defmodule Pathways.Domains.#{module}.Sources do
	  @moduledoc \"""
	  Sources belonging to the #{module} domain.
	  \"""
	
	  defmacro sources do
		  quote do
			# 
			end
		  end
	  end
	  """
	end
	
	
  
end