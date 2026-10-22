defmodule PathwaysNew.Templates.Mix do
  @moduledoc """
  Generates mix.exs for a new Pathways application.
  """

  def render(module, domain) do
	"""
	defmodule #{module}.MixProject do
	  use Mix.Project

	  def project do
		[
		  app: :#{domain},
		  version: "0.1.0",
		  elixir: "~> 1.19",
		  start_permanent: Mix.env() == :prod,
		  deps: deps()
		]
	  end

	  def application do
		[
		  extra_applications: [:logger]
		]
	  end

	  defp deps do
		[]
	  end
	end
	"""
  end
end