require_relative 'business'
require_relative 'user'
require_relative 'record_filter'

#############################################################
#
#############################################################
class Tester
  attr_accessor :tests_passed
  attr_accessor :tests_failed

  #############################################################
  #
  #############################################################
  def initialize
    @test_passed = 0
    @test_failed = 0
  end
  
  
  #############################################################
  #
  #############################################################
  def run_tests
    test_business_arrays()
    test_same_email_user()
    test_invalid_emails()
    test_interview_csv()
    print_results()
  end
  
private
  #############################################################
  #
  #############################################################
  def print_results
    puts "TESTS PASSED: #{@test_passed}"
    puts "TESTS FAILED: #{@test_failed}"
  end
  
  #############################################################
  # Tests a Business having multiple phone numbers, fax numbers,
  # and emails
  #############################################################
  def test_business_arrays
    user_csv     = "test_files/users.csv" 
    business_csv = "test_files/biz_array.csv" 
    
    filter = RecordFilter.new
    filter.create(user_csv, business_csv)
    
    ## Test Multiple Emails
    if (filter.businesses["Big"].email.length == 8 &&
       filter.businesses["Big"].email[0] == "admin@mail.com" &&
       filter.businesses["Big"].email[1] == "admin2@mail.com" &&
       filter.businesses["Big"].email[2] == "admin3@mail.com" &&
       filter.businesses["Big"].email[3] == "admin4@mail.com" &&
       filter.businesses["Big"].email[4] == "admin5@mail.com" &&
       filter.businesses["Big"].email[5] == "admin6@mail.com" &&
       filter.businesses["Big"].email[6] == "admin8@mail.com" &&
       filter.businesses["Big"].email[7] == "admin9@mail.com")
      @test_passed = @test_passed + 1
    else
      @test_failed = @test_failed + 1
      puts "Multiple Business Email Test Failed"
    end

    ## Test Muiltiple Phone Numbers
    if (filter.businesses["Big"].phone.length == 7 &&
       filter.businesses["Big"].phone[0] == "801-555-7212" &&
       filter.businesses["Big"].phone[1] == "801-555-7213" &&
       filter.businesses["Big"].phone[2] == "801-555-7214" &&
       filter.businesses["Big"].phone[3] == "801-555-7215" &&
       filter.businesses["Big"].phone[4] == "801-555-7216" &&
       filter.businesses["Big"].phone[5] == "801-555-7217" &&
       filter.businesses["Big"].phone[6] == "801-555-7218")
      @test_passed = @test_passed + 1
    else
      @test_failed = @test_failed + 1
      puts "Multiple Business Phone Test Failed"
    end

    ## Test Muiltiple Phone Numbers
    if (filter.businesses["Big"].fax.length == 8 &&
       filter.businesses["Big"].fax[0] == "801-555-7213" &&
       filter.businesses["Big"].fax[1] == "801-555-7214" &&
       filter.businesses["Big"].fax[2] == "801-555-7215" &&
       filter.businesses["Big"].fax[3] == "801-555-7216" &&
       filter.businesses["Big"].fax[4] == "801-555-7217" &&
       filter.businesses["Big"].fax[5] == "801-555-7218" &&
       filter.businesses["Big"].fax[6] == "801-555-7219" &&
       filter.businesses["Big"].fax[7] == "801-555-7211")
      @test_passed = @test_passed + 1
    else
      @test_failed = @test_failed + 1
      puts "Multiple Business Fax Test Failed"
    end
  end
  
  #############################################################
  # Test the case where two users have the same email address.
  #############################################################
  def test_same_email_user
    user_csv     = "test_files/users_same_email.csv" 
    business_csv = "test_files/businesses.csv" 

    filter = RecordFilter.new
    filter.create(user_csv, business_csv)
    filter.calc_stats()
                     
    ## Test Same Email Address for Multiple records
    if (filter.users.length == 1 && !filter.users["bob@mail.com"].nil? &&
        filter.well_formed_rec_cnt == 6 && filter.malformed_rec_cnt == 8 &&
        filter.biz_rec_cnt == 3 && filter.user_rec_cnt == 1 && filter.total_rec_cnt == 14)
      @test_passed = @test_passed + 1
    else
      @test_failed = @test_failed + 1
      puts "User Same Email Test Failed"
    end
    
  end
  
  #############################################################
  # Tests different cases of invalid emails
  #############################################################
  def test_invalid_emails
    user_csv     = "test_files/user_bad_email.csv" 
    business_csv = "test_files/biz_bad_email.csv" 

    filter = RecordFilter.new
    filter.create(user_csv, business_csv)
    filter.calc_stats()
    
    ## Test User Invalid Emails
    if (filter.users.length == 1 && !filter.users["bob@mail.com"].nil? &&
        filter.businesses.length == 1 && !filter.businesses["Freemont Construction"].email.nil? &&
        filter.well_formed_rec_cnt == 2 && filter.malformed_rec_cnt == 16 &&
        filter.biz_rec_cnt == 1 && filter.user_rec_cnt == 1 && filter.total_rec_cnt == 18)
      @test_passed = @test_passed + 1
    else
      @test_failed = @test_failed + 1
      puts "Invalid Email Test Failed"
    end
  end

  #############################################################
  # Tests with the interview csv files
  #############################################################
  def test_interview_csv
    user_csv     = "test_files/users.csv" 
    business_csv = "test_files/businesses.csv" 

    filter = RecordFilter.new
    filter.create(user_csv, business_csv)
    filter.calc_stats()
    #filter.output
    
    ## Test User Invalid Emails
    if (filter.well_formed_rec_cnt == 11 && filter.malformed_rec_cnt == 5 &&
        filter.biz_rec_cnt == 3 && filter.user_rec_cnt == 6 && filter.total_rec_cnt == 16)
      @test_passed = @test_passed + 1
    else
      @test_failed = @test_failed + 1
      puts "Interview Test Failed"
    end
  end
  
end