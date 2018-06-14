class Post

  attr_accessor :id, :title, :body

  # Methods to connect
  #Open the connection to the DB
  def self.open_connection

    conn = PG.connect(dbname: "blog")

  end
  # Method ot get all isntances from our Db
  def self.all
    # Open the connect // Calling the open_connection method
    conn= self.open_connection

    #Creating a SQL String
    sql = "SELECT * FROM post ORDER BY id"
    #Conn execute what ever command we give it, so its executing the SQL variable made above
    # Executing the connection with our SQL string, storing it in a variable
    #This is the dirty array
    results = conn.exec(sql)


    # Map cleans a array
    #This is the cleaned array
    # tuple is a key value pair
    posts = results.map do |tuple|
      self.hydrate tuple
    end
  end

  #Find one using the ID that'll give it when we call it
  def self.find id
    # Open Connection
    conn = self.open_connection

#SQL to find using the ID
    # The ID is the argument from def
    sql = "SELECT * FROM post WHERE id=#{ id } LIMIT 1"
    # Limit 1 gives us first one

    #Get the raw results
    posts = conn.exec(sql)
    # Results comes back as array so need to run hydrate on first instance
    post = self.hydrate posts[0]


# Return the cleaned Post
    post

  end



  def save

    conn = Post.open_connection

    # If the object that the save method is run on does not have an existing id, create a new instance
    if (!self.id)
      sql = "INSERT INTO post (title, body)
      VALUES ('#{self.title}', '#{self.title}')"
    else
      sql = "Update post SET title='#{self.title}', body='#{self.body}' WHERE id='#{self.id}'"

    end


    # Populate ifnroation from Aram and thats how we access through self.title and self.body

    conn.exec(sql)




  end

  def self.destroy id
      conn = self.open_connection

      sql = "DELETE FROM post WHERE id=#{id}"

      conn.exec(sql)

  end


  #Hydration to get the raw data in the database and spruce up and hand it back to the controller and hand it back as clean data dna make sure it knows what to do with it.
  #The data we get back from the DB isn't particularly clean so we need to create a method to clean itt up before we send it to the Controller
  def self.hydrate post_data

    #Hydrate is just clean

    #Similar to what we did with create in the controller.

    #Create a new instnace of Post
    post = Post.new

    # Assign the id, title, and body properties to those thta come back from the dB
    post.id = post_data["id"]
    post.title = post_data["title"]
    post.body = post_data["body"]

    # return the post
    post
  end




end
