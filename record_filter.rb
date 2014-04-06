require 'csv'
require_relative 'business'
require_relative 'user'
require_relative 'record'


#############################################################
# This Class filters through records that it parses out of a
# CSV file. The records are determined to be either good or
# malformed. The good records are used to create User and 
# Business objects.
#############################################################
class RecordFilter
  attr_accessor :bad_business_records
  attr_accessor :bad_user_records
  attr_accessor :good_business_records
  attr_accessor :good_user_records
  
  attr_accessor :businesses
  attr_accessor :users
  
  attr_accessor :total_rec_cnt
  attr_accessor :well_formed_rec_cnt
  attr_accessor :malformed_rec_cnt  
  attr_accessor :biz_rec_cnt
  attr_accessor :user_rec_cnt
  
  VALID_EMAIL_REGEX = /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/
  #VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  #############################################################
  # Initialize arrays and hashes
  #############################################################
  def initialize
    @businesses            = {}
    @users                 = {}
    @bad_business_records  = []
    @bad_user_records      = []
    @good_business_records = []
    @good_user_records     = []
  end

  #############################################################
  # Param: users_csv - CSV file that contains User records.
  # Param: business_csv - CSV file that contains Business records. 
  #############################################################
  def create(users_csv, bussinesses_csv)
    user_record_list     = parse_csv(users_csv)
    business_record_list = parse_csv(bussinesses_csv)
    
    remove_bad_business_records(business_record_list)
    remove_bad_user_records(user_record_list)
    
    create_businesses()
    create_users()
  end
  
  
  #############################################################
  # Prints Records, Users, Businesses, and Stats
  #############################################################
  def output
    print_valid_businesses()
    print_valid_users()
    print_invalid_businesses()
    print_invalid_users()
    print_stats()
  end

  #############################################################
  # Calculate the stats to be printed
  #############################################################
  def calc_stats
    #puts "bad_biz    = #{@bad_business_records.length}"
    #puts "bad_user   = #{@bad_user_records.length}"
    #puts "good_biz   = #{@good_business_records.length}"
    #puts "good_user  = #{@good_user_records.length}"
    
    @total_rec_cnt       = @bad_business_records.length + @bad_user_records.length +
	                   @good_business_records.length + @good_user_records.length
    @well_formed_rec_cnt = @good_business_records.length + @good_user_records.length
    @malformed_rec_cnt   = @bad_business_records.length + @bad_user_records.length
    @biz_rec_cnt         = @businesses.length
    @user_rec_cnt        = @users.length
  end
  
private
  #############################################################
  # Param: file_path - The CSV file to parse.
  # Parses the CSV file and returns a list of Record objects
  #############################################################
  def parse_csv(file_path)
    record_list = []
    header      = []
    is_header   = true
    
    CSV.foreach(file_path) do |row|
      if (is_header)
	header    = row
	is_header = false
      else
	record = Record.new
	record.create(header, row)
	record_list.push(record)
      end
    end
    return record_list
  end

  #############################################################
  # Param: records - List of Business records to be filtered.
  # Sorts out which business records are good and which are malformed.
  # The good are added to a good list and the malformed are added
  # to a malformed list.
  #############################################################
  def remove_bad_business_records(records)
    records.each do |rec|
      if (rec.fields["name"].nil?)
	rec.is_malformed = true
	rec.add_malformed_message("ERROR: INVALID NAME")
	@bad_business_records << rec
      elsif (!rec.fields["email"].nil? && VALID_EMAIL_REGEX.match(rec.fields["email"]).nil?)
	rec.is_malformed = true
	rec.add_malformed_message("ERROR: INVALID EMAIL")
	@bad_business_records << rec
      else
	@good_business_records << rec
      end
    end
  end
  
  #############################################################
  # Param: records - List of User records to be filtered.
  # Sorts out which user records are good and which are malformed.
  # The good are added to a good list and the malformed are added
  # to a malformed list.
  #############################################################
  def remove_bad_user_records(records)
    records.each do |rec|
      if (VALID_EMAIL_REGEX.match(rec.fields["email"]).nil?)
	rec.is_malformed = true
	rec.add_malformed_message("ERROR: INVALID EMAIL")
	@bad_user_records << rec
      elsif (rec.fields["name"].nil?)
	rec.is_malformed = true
	rec.add_malformed_message("ERROR: INVALID NAME")
	@bad_user_records << rec
      elsif (rec.fields["businessname"].nil?)
	rec.is_malformed = true
	rec.add_malformed_message("ERROR: INVALID BUSINESS NAME")
	@bad_user_records << rec
      else
	@good_user_records << rec
      end
    end
  end

  #############################################################
  # Uses the good Business record list to create Business objects.
  #############################################################
  def create_businesses()
    @good_business_records.each do |rec|
      existing_business = @businesses[rec.fields["name"]]
      ## If the business doesn't exist then create it.
      if (existing_business.nil?)
	new_business = Business.new
	new_business.create(rec)
	@businesses[new_business.name] = new_business
      ## The business exists so update the updateable fields (arrays)
      else
	existing_business.update(rec)
      end
    end
  end

  #############################################################
  # Uses the good User record list to create User objects.
  # It also adds the created user to the business list based
  # on the user BusinessName.
  #############################################################
  def create_users()
    del_rec = []
    @good_user_records.each do |rec|
      existing_user = @users[rec.fields["email"]]
      # check if the user doesn't exist already
      if (existing_user.nil?)
	# check to see if business already exists
	existing_business = @businesses[rec.fields["businessname"]]
	if (!existing_business.nil?)
	  new_user = User.new
	  new_user.create(rec)
	  existing_business.add_user(new_user)
	  @users[new_user.email] = new_user
	else
	  rec.is_malformed = true
	  rec.add_malformed_message("ERROR: COMPANY NAME DOESN'T EXIST")
	  @bad_user_records << rec
	  del_rec << rec
	end
      #User Already Exists treat it as malformed
      else 
	rec.is_malformed = true
	rec.add_malformed_message("ERROR: USER EMAIL ALREADY EXISTS")
	@bad_user_records << rec
	del_rec << rec
      end
    end

    del_rec.each do |rec|
      @good_user_records.delete(rec)
    end
    
  end

  #############################################################
  # Prints the Stat counters
  #############################################################
  def print_stats
    puts "=================================================="
    puts "================= Statistics ====================="
    puts "=================================================="
    
    calc_stats()
    
    puts "Total Records           = #{@total_rec_cnt}"
    puts "Well Formed Records     = #{@well_formed_rec_cnt}"
    puts "Malformed Records       = #{@malformed_rec_cnt}"
    puts "Unique Business Records = #{@biz_rec_cnt}"
    puts "Unique User Records     = #{@user_rec_cnt}"
    puts ""
  end
  
  #############################################################
  # Prints the valid Business objects
  #############################################################
  def print_valid_businesses
    puts "=================================================="
    puts "=============== Valid Businesses ================="
    puts "=================================================="

    @businesses.each do |key, business|
      business.output
      puts ""
    end
  end
  
  #############################################################
  # Prints the valid User Objects
  #############################################################
  def print_valid_users
    puts "=================================================="
    puts "================= Valid Users ===================="
    puts "=================================================="

    @businesses.each do |key, business|
      puts "----- BusinessName: #{business.name} -----"
      business.users.each do |user|
        if (!user.nil?)
	  user.output
	  puts ""
        end
      end
    end
  end

  #############################################################
  # Prints the Malformed Business Records
  #############################################################
  def print_invalid_businesses
    puts "=================================================="
    puts "========== Malformed Business Records ============"
    puts "=================================================="

    @bad_business_records.each do |rec|
      rec.output
      puts ""
    end
  end


  #############################################################
  # Prints the Malformed User Records
  #############################################################
  def print_invalid_users
    puts "=================================================="
    puts "============ Malformed User Records =============="
    puts "=================================================="

    @bad_user_records.each do |rec|
      rec.output
      puts ""
    end
  end
  
end