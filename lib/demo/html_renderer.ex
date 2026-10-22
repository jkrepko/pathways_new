defmodule HtmlRenderer do
  @moduledoc false

  def render(module) do
	"""
	defmodule #{module}.Demo.HtmlRenderer do
	  @moduledoc false
	
	  alias #{module}.Demo.TextRenderer
	
	  def render(demos) do
		body =
		demos
		|> TextRenderer.render()
		|> html_escape()
		|> String.replace("\n", "<br>\n")
	
		<!doctype html>
		<html>
		  <head>
			<meta charset="utf-8">
			<title>#{module} Demo</title>
			<style>
			  body {
				font-family: system-ui, -apple-system, BlinkMacSystemFont, sans-serif;
				max-width: 900px;
				margin: 3rem auto;
				line-height: 1.5;
				color: #222;
			  }
	
			  .demo {
				white-space: normal;
				font-size: 16px;
			  }
	
			  code, pre {
				font-family: ui-monospace, SFMono-Regular, Menlo, monospace;
			  }
			</style>
		  </head>
		  <body>
			<h1>#{module} Demo</h1>
			<p>
			  Toward solving problems in the domains where we find them,
			  and in the language of that domain.
			</p>
	
			<div class="demo">
			  <div class="demo">
		      \#{body |> bold_questions() |> bold_keywords()}
			  </div>
			</div>
		  </body>
		</html>
	  end
	
	  defp bold_keywords(body) do
		body
		|> String.replace("description:", "<strong>description:</strong>")
		|> String.replace("Signals:", "<strong>Signals:</strong>")
		|> String.replace("Mechanisms:", "<strong>Mechanisms:</strong>")
		|> String.replace("Interventions:", "<strong>Interventions:</strong>")
		|> String.replace("Regimens:", "<strong>Regimens:</strong>")
		|> String.replace("Conditions:", "<strong>Conditions:</strong>")
		|> String.replace("consumes:", "<strong>consumes:</strong>")
		|> String.replace("produces:", "<strong>produces:</strong>")
		|> String.replace("explains:", "<strong>explains:</strong>")
		|> String.replace("risks:", "<strong>risks:</strong>")
		|> String.replace("interventions:", "<strong>interventions:</strong>")
		|> String.replace("explains:", "<strong>explains:</strong>")
		|> String.replace("reduces:", "<strong>reduces:</strong>")
		|> String.replace("enhances:", "<strong>enhances:</strong>")
		|> String.replace("enhanced by:", "<strong>enhanced by:</strong>")
		|> String.replace("inhibits:", "<strong>inhibits:</strong>")
		|> String.replace("inhibited by:", "<strong>inhibited by:</strong>")
		|> String.replace("increases_risk_of:", "<strong>increases risk of: </strong>")
		|> String.replace("indicated_agents:", "<strong>indicated agents: </strong>")
		|> String.replace("indicated agents:", "<strong>indicated agents: </strong>")
		|> String.replace("confidence:", "<strong>confidence:</strong>")
		|> String.replace("effects:", "<strong>effects:</strong>")
		|> String.replace("mechanisms:", "<strong>mechanisms:</strong>")
		|> String.replace("signals:", "<strong>signals:</strong>")
		|> String.replace("interventions:", "<strong>interventions:</strong>")
		|> String.replace("increases_risk_of:", "<strong>increases risk of: </strong>")
		|> String.replace("contraindicated_by:", "<strong>contraindicated_by: </strong>")
		|> String.replace("contraindicated by:", "<strong>contraindicated by: </strong>")
	  end
	
	  defp bold_questions(body) do
		Regex.replace(
		  ~r/Q:\s*(.+)/,
		  body,
		  "<strong>Q: \\1</strong>"
		)
	  end
	
	  defp html_escape(text) do
		text
		|> String.replace("&", "&amp;")
		|> String.replace("<", "&lt;")
		|> String.replace(">", "&gt;")
	  end
	end
	"""
  end
end