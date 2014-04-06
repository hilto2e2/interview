#############################################################
# Models the User
#############################################################
class User
  attr_accessor :name
  attr_accessor :email
  attr_accessor :phone
  attr_accessor :title
  attr_accessor :business_name

  #############################################################
  # Param: rec - Record that contains the information used to
  # create the User object
  #############################################################
  def create(rec)
    @name              = rec.fields["name"]
    @email             = rec.fields["email"]
    @phone             = rec.fields["phone"]
    @title             = rec.fields["title"]
    @business_name     = rec.fields["businessname"]
  end
  
  #############################################################
  # Prints the User object to STD_OUT
  #############################################################
  def output
    puts "Name:         #{@name}"
    puts "Email:        #{@email}"
    puts "Phone:        #{@phone}"
    puts "Title:        #{@title}"
  end
end