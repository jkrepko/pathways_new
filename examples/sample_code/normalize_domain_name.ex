defp normalize_domain_name(name) do
  name
  |> String.trim()
  |> String.replace(~r/\s+/, "_")
  |> Macro.underscore()
  |> String.downcase()
end