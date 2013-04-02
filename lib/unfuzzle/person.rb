module Unfuzzle

  # = Person
  #
  # Represents a single Unfuddle Person - is associated to a project
  #
  # [id] The unique identifier for this ticket
  # [first_name] Person's first name
  # [last_name] Person's last name
  # [email] Person's email
  # [user_name]  Person's username
  #
  class Person

    include Graft::Model

    attribute :id, :type => :integer
    attribute :first_name, :from => 'first-name'
    attribute :last_name, :from => 'last-name'
    attribute :email
    attribute :username 


    # Return a list of all People for an individual project
    def self.find_all_by_project_id(project_id)
      response = Request.get("/projects/#{project_id}/people")
      collection_from(response.body, 'people/person')
    end

    # Return a list of all People for an individual project
    def self.find_first_by_people_id(person_id)
      response = Request.get("/people/#{person_id}")
      new(response.body)
    end
    
    # Hash representation of this person's data (for updating)
    def to_hash
      {
        'id'           => id,
      }
    end
    
    # Update the ticket's data in unfuddle
    def update
      resource_path = "/projects/#{project_id}/people/#{id}"
      Request.put(resource_path, self.to_xml('person'))
    end

  end
end