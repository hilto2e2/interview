#############################################################
# Models the Business
#############################################################
class Business
  attr_accessor :name
  attr_accessor :address
  attr_accessor :city
  attr_accessor :state
  attr_accessor :zip
  attr_accessor :phone
  attr_accessor :fax
  attr_accessor :email
  attr_accessor :users
  
  #############################################################
  # Initialize variables. Mostly needed for arrays.
  #############################################################
  def initialize
    @name              = ""
    @address           = ""
    @city              = ""
    @state             = ""
    @zip               = ""
    @phone             = []
    @fax               = []
    @email             = []
    @users             = []
  end
  
  #############################################################
  # Param: rec - record that contains the data to create the
  # Business object.
  #############################################################
  def create(rec)
    @name              = rec.fields["name"]
    @address           = rec.fields["address"]
    @city              = rec.fields["city"]
    @state             = rec.fields["state"]
    @zip               = rec.fields["zip"]
    @phone             << rec.fields["phone"] if !rec.fields["phone"].nil?
    @fax               << rec.fields["fax"] if !rec.fields["fax"].nil?
    @email             << rec.fields["email"] if !rec.fields["email"].nil?
  end
  
  #############################################################
  # Param: rec - Is a record that will update the business arrays
  #############################################################
  def update(rec)
    if ( !rec.fields["phone"].nil? && @phone.index(rec.fields["phone"]).nil? )
      @phone << rec.fields["phone"]
    end
    
    if ( !rec.fields["fax"].nil? && @fax.index(rec.fields["fax"]).nil? )
      @fax   << rec.fields["fax"] 
    end
    
    if ( !rec.fields["email"].nil? && @email.index(rec.fields["email"]).nil? )
      @email << rec.fields["email"] 
    end
  end
  
  #############################################################
  # Param: user - User object that will be added to the Business
  # user array.
  #############################################################
  def add_user(user)
    @users << user
  end
  
  #############################################################
  # Prints the Business object to STD_OUT
  #############################################################
  def output
    puts  "Name:    #{@name}"
    puts  "Address: #{@address}"
    puts  "City:    #{@city}"
    puts  "State:   #{@state}"
    puts  "Zip:     #{@zip}"
    print "Phone:   "
    @phone.each do |ph|
      if (!ph.nil?)
	print "#{ph} "
      end
    end
    print "\n"
    print "Fax:     "
    @fax.each do |fx|
      if (!fx.nil?)
	print "#{fx} "
      end
    end
    print "\n"
    print "Email:   "
    @email.each do |em|
      if (!em.nil?)
	print "#{em} "
      end
    end
    print "\n"
  end

end