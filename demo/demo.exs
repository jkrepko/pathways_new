
	"""
	# demo/#{module}.exs
	
	alias #{module}.Demo.OsteoporosisDemo
	alias #{module}.Demo.TextRenderer
	alias #{module}.Demo.HtmlRenderer
	
	# Change this as you add more examples.
	#  pathways = [
	#     #{module}
	# ]
	
	alias #{module}.Demo.BasicPathway
	pathways = BasicPathway.modules()
	
	html? = "--html" in System.argv()
	
	output =
	pathways
	|> Enum.map(&#{module}Demo.describe_fn/1)
	|> then(fn demos ->
	  if html? do
		HtmlRenderer.render(demos)
	  else
		TextRenderer.render(demos)
	  end
	end)
	
	if html? do
	  File.mkdir_p!("demo/output")
	  File.write!("demo/output/#{module}_demo.html", output)
	  IO.puts("Wrote demo/output/#{module}_demo.html")
	else
	  IO.puts(output)
	end
	"""
