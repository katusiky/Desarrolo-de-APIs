json.type resource.class.name.underscore.pluralize
json.id resource.id
json.attributes resource.attributes

if defined? relations 
	json.relations do
		relations.each do |relation|
			json.set! relation do 
				relation_object = resource.send(relation)
				if relation_object.respond_to? "length"
					json.partial! partial: "api/v1/resource", collection: relation_object, as: :resource
				else
					json.partial! "api/v1/resource", resource: relation_object
				end
			end 
		end
	end
end