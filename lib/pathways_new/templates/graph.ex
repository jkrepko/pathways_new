defmodule PathwaysNew.Templates.Graph do
  @moduledoc """
  	Graph is a framework for translating pathways into queryable collections of facts.
  	Typical usage:

  	```elixir
  	iex> import PathwaysLab.Graph
  	iex> p = PathwaysLab.example(:chronic_kidney_disease)
  	iex> g = PathwaysLab.Graph.from_pathway(p)
  	iex> Enum.take(g.facts, 10)
  	iex> g.facts |> Enum.map(& &1.relation) |> Enum.frequencies()
  	```
  	The Pathways query language allows relationships between mechanisms,
  	signals, effects, and interventions to be explored declaratively.  Facts are even better.
  """
  
   def render(module) do
	"""
	  defmodule #{module}.Graph do
	  @moduledoc false

  	defstruct facts: [],
				by_subject: %{},
				by_object: %{},
				by_relation: %{},
				by_provenance: %{}
	
	def from_pathway(pathway) do
		facts =
		pathway
		|> #{module}.Entities.all_entities()
		|> Enum.flat_map(&facts_for_entity/1)
	
		%__MODULE__{
		facts: facts,
		by_subject: Enum.group_by(facts, & &1.subject),
		by_object: Enum.group_by(facts, & &1.object),
		by_relation: Enum.group_by(facts, & &1.relation),
		by_provenance: Enum.group_by(facts, & &1.provenance),
		}
	end
	
	def from_pathway_with_derivations(pathway) do
		graph = from_pathway(pathway)
	
		filtered_facts =
		Enum.reject(graph.facts, fn fact ->
			fact.relation in [:indicates, :effects]
		end)
	
		derived_facts =
		graph.facts
		|> Enum.flat_map(&#{module}.Fact.derive/1)
	
		%{graph | facts: filtered_facts ++ derived_facts}
	end
	
	
	def signal_objects(p, relation, object)
		when is_atom(relation) and is_atom(object) do
		p.signals
		|> Enum.filter(fn signal ->
		signal
		|> Map.get(relation, [])
		|> List.wrap()
		|> Keyword.keys()
		|> Enum.member?(object)
		end)
	end
	
	# A list of objects means "matching any object in the list."
	def signal_objects(p, relation, objects)
		when is_atom(relation) and is_list(objects) do
		objects
		|> Enum.flat_map(&signal_objects(p, relation, &1))
		|> Enum.uniq_by(& &1.name)
	end
	
	
	# mechanism_objects(p, :inhibited_by, :insulin_resistance) - gives a list of Mechanisms where MECHANISM RELATION gives OBJECT
	# Returns Mechanism structs whose specified relation contains object.
		def mechanism_objects(p, relation, object)
			when is_atom(relation) and is_atom(object) do
		p.mechanisms
		|> Enum.filter(fn mechanism ->
			mechanism
			|> Map.get(relation, [])
			|> List.wrap()
			|> Enum.member?(object)
		end)
		end
		
		# A list of objects means "matching any object in the list."
		def mechanism_objects(p, relation, objects)
			when is_atom(relation) and is_list(objects) do
		objects
		|> Enum.flat_map(&mechanism_objects(p, relation, &1))
		|> Enum.uniq_by(& &1.subject)
		end
	
	
	
	# relation_objects(g, :enhances, :insulin_resistance) - gives a list of FACTS where subject RELATION gives OBJECT
	def relation_objects(g, relation, object) do
		g.facts
		|> Enum.filter(&(&1.relation == relation and &1.object == object))
	end
	
	# subject_relations(g, :insulin_resistance, :inhibits) - gives a list of FACTS where SUBJECT RELATION gives object
	def subject_relations(g, subject, relation) do
		g.facts
		|> Enum.filter(&(&1.relation == relation and &1.subject == subject))
	end
	
	
	# subjects_objects(g, :hyperinsulinemia, :insulin_resistance)
	#
	# Returns all FACTS connecting the two entities,
	# regardless of direction.  directed_subjects_objects returns ONLY going from subject to object
	def directed_subjects_objects(g, subject, object) do
	g.facts
	|> Enum.filter(
		&(&1.subject == subject and &1.object == object)
	)
	end
	
	def subjects_objects(g, subject, object) do
	directed_subjects_objects(g, subject, object) ++
		directed_subjects_objects(g, object, subject)
	|> Enum.uniq()
	end
	
	
	# Declare the default argument
	def subjects_that(g, relation, object)
	
	# subjects_that(g, :enhances, :insulin_resistance) - gives a Set of atomic SUBJECTS where the subject RELATION gives OBJECT
	def subjects_that(g, relation, object) when is_atom(relation) and is_atom(object) do
		g
		|> relation_objects(relation, object)
		# |> Enum.map(& &1.subject)
		# |> MapSet.new()
	end
	
	def subjects_that(g, relation, objects) when is_atom(relation) and is_list(objects) do
		# union_map(objects, &subjects_that(g, relation, &1))
		objects
		|> Enum.flat_map(fn object ->
		subjects_that(g, relation, object)
		end)
	end
	
	def subjects_that(g, relations, object)
		when is_list(relations) and is_atom(object) do
		# union_map(relations, &subjects_that(g, &1, object))
		relations
		|> Enum.flat_map(fn relation ->
			subjects_that(g, relation, object)
		end)
	end
	
	def subjects_that(g, relations, objects)
		when is_list(relations) and is_list(objects) do
		# union_map(relations, &subjects_that(g, &1, objects))
		relations
		|> Enum.flat_map(fn relation ->
			subjects_that(g, relation, objects)
		end)
	end
	
	
	# Declare the default argument
	def signals_that(p, relation, object, opts \\\\ [])
	
	# Handle a single object
	def signals_that(p, relation, object, opts) when is_atom(object) do
	when_val = Keyword.get(opts, :when)
	dir_val  = Keyword.get(opts, :direction)
	
	p
	|> signal_objects(relation, object)
	|> Enum.filter(fn signal ->
		is_nil(dir_val) or
		(signal.indicates
		|> Keyword.get(object, [])
		|> Keyword.get(:direction)) == dir_val
	end)
	|> Enum.filter(fn signal ->
		is_nil(when_val) or
		(signal.indicates
		|> Keyword.get(object, [])
		|> Keyword.get(:when)) == when_val
	end)
	end
	
	# Handle multiple objects
	def signals_that(p, relation, objects, opts)
		when is_atom(relation) and is_list(objects) do
	
	objects
	|> Enum.flat_map(fn object ->
		signals_that(p, relation, object, opts)
	end)
	|> Enum.uniq()
	end
	
	
	def signal_direction(signals, target_direction) do
		Enum.filter(signals, fn signal ->
		
		direction = 
			signal.indicates
			# Get the first key's value (e.g. the keyword list inside :proteinuria)
			|> Keyword.values() 
			|> List.first()
			# Get the :direction value from that inner keyword list
			|> Keyword.get(:direction)
	
		direction == target_direction
		end)
	end
	
	
	def intervention_direction(interventions, target_direction) do
		Enum.filter(interventions, fn intervention ->
		# 1. Access the :indicates property (assuming it's a keyword list or similar structure)
		# 2. Get the inner details for the signal
		# 3. Check if the :direction matches the target_direction
		
		direction = 
			intervention.effects
			# Get the first key's value (e.g. the keyword list inside :proteinuria)
			|> Keyword.values() 
			|> List.first()
			# Get the :direction value from that inner keyword list
			|> Keyword.get(:direction)
	
		direction == target_direction
		end)
	end
	
	
	
	# Declare the default argument
	def interventions_that(p, relation, object, opts \\\\ [])
	
	# Handle a single object
	def interventions_that(p, relation, object, opts) when is_atom(object) do
	when_val = Keyword.get(opts, :when)
	dir_val  = Keyword.get(opts, :direction)
	
	p
	|> intervention_objects(relation, object)
	|> Enum.filter(fn intervention ->
		is_nil(dir_val) or
		(intervention.effects
		|> Keyword.get(object, [])
		|> Keyword.get(:direction)) == dir_val
	end)
	|> Enum.filter(fn intervention ->
		is_nil(when_val) or
		(intervention.effects
		|> Keyword.get(object, [])
		|> Keyword.get(:when)) == when_val
	end)
	end
	
	# Handle multiple objects
	def interventions_that(p, relation, objects, opts)
		when is_atom(relation) and is_list(objects) do
	
	objects
	|> Enum.flat_map(fn object ->
		interventions_that(p, relation, object, opts)
	end)
	|> Enum.uniq()
	end
	
	
	
	def intervention_objects(p, relation, object)
		when is_atom(relation) and is_atom(object) do
		p.interventions
		|> Enum.filter(fn intervention ->
		intervention
		|> Map.get(relation, [])
		|> List.wrap()
		|> Keyword.keys()
		|> Enum.member?(object)
		end)
	end
	
	# A list of objects means "matching any object in the list."
	def intervention_objects(p, relation, objects)
		when is_atom(relation) and is_list(objects) do
		objects
		|> Enum.flat_map(&intervention_objects(p, relation, &1))
		|> Enum.uniq_by(& &1.name)
	end
	
	
	
	# # mechanisms_that(p, :inhibits, :insulin_resistance) - gives a Set of Mechanism Names where the MECHANISM RELATION gives OBJECT
	# Returns a set of atomic intervention names.
	
	# Declare the default argument
		def mechanisms_that(p, relation, object)
	
		def mechanisms_that(p, relation, object)  when is_atom(relation) and is_atom(object) do
		p
		|> mechanism_objects(relation, object)
		# |> Enum.map(& &1.name)
		# |> MapSet.new()
		end
		
		def mechanisms_that(p, relation, objects)  when is_atom(relation) and is_list(objects) do
		objects
		|> Enum.flat_map(fn object -> mechanisms_that(p, relation, object ) end)
		|> Enum.uniq()
		end
	
	
	# # objects_that(g, :dietary_sodium_reduction,:effects) - gives a Set of atomic OBJECTS where SUBJECT RELATION gives object
	def objects_that(g, subject, relation) when is_atom(subject) and is_atom(relation) do
		g
		|> subject_relations(subject, relation)
		# |> Enum.map(& &1.object)
		# |> MapSet.new()
	end
	
	
	def objects_that(g, subjects, relation) when is_list(subjects) do
		# union_map(subjects, &objects_that(g, &1, relation))
		subjects
		|> Enum.flat_map(fn subject -> objects_that(g, subject, relation ) end)
		|> Enum.uniq()
	end
	
	def objects_that(g, subject, relations) when is_list(relations) do
		# union_map(subjects, &objects_that(g, &1, relation))
		relations
		|> Enum.flat_map(fn relation -> objects_that(g, subject, relation ) end)
		|> Enum.uniq()
	end
	
	# def objects_that(g, subjects, relations) when is_list(subjects) and is_list(relations) do
	#     subjects
	#     |> Enum.flat_map(fn subject -> objects_that(g, subject, relations)
	#     end)
	# end
	
	
	def relations_that(g, subject, object)
		when is_atom(subject) and is_atom(object) do
		g
		|> subjects_objects(subject, object)
		# |> Enum.map(& &1.relation)
		# |> MapSet.new()
	end
	
	def relations_that(g, subjects, object) when is_atom(object) do
		# union_map(subjects, &relations_that(g, &1, object))
		subjects
		|> Enum.flat_map(fn subject -> relations_that(g, subject, object ) end)
		|> Enum.uniq()
	end
	
	def relations_that(g, subject, objects) when is_atom(subject) do
		# union_map(objects, &relations_that(g, subject, &1))
		objects
		|> Enum.flat_map(fn object -> relations_that(g, subject, object ) end)
		|> Enum.uniq()
	end
	
	def relations_that(g, subjects, objects) when is_list(subjects) and is_list(objects) do
		subjects
		|> Enum.flat_map(fn subject -> relations_that(g, subject, objects)
		end)
	end
	
	
	
	@spec describe(map(), atom()) ::
			String.t()
			| {:error, :mechanism_not_found | :description_not_available}
	def describe(%{mechanisms: mechanisms}, name) when is_atom(name) do
		case Enum.find(mechanisms, &(&1.name == name)) do
		nil ->
			:mechanism_not_found
	
		%{description: description}
		when is_binary(description) and byte_size(description) > 0 ->
			String.trim(description)
	
		_mechanism ->
			:description_not_available
		end
	end
	
	def describe_all(%{mechanisms: mechanisms}, name) when is_atom(name) do
		case Enum.find(mechanisms, &(&1.name == name)) do
		nil ->
			:mechanism_not_found
	
		%{description: description}
		when is_binary(description) and byte_size(description) > 0 ->
			String.trim(description)
	
		_mechanism ->
			:description_not_available
		end
	end
	
	
	
	defp facts_for_entity(entity) do
		subject = #{module}.Entity.id(entity)
	
		entity
		|> #{module}.Entity.relations()
		|> Enum.flat_map(fn {relation, objects} ->
		objects
		|> List.wrap()
		|> Enum.map(fn object ->
			%#{module}.Fact{
			subject: subject,
			relation: relation,
			object: object,
			provenance: :direct
			}
		end)
		end)
	  end
	end

  
	"""
  end
end