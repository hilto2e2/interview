#############################################################
# Main file that acts as driver
#############################################################

require_relative 'record_filter'
require_relative 'tester'

@test = false
#############################################################
# Validates command line parameters
#############################################################
def check_command_line
  if (!ARGV[0].nil? && ARGV[0].downcase == "test")
    @test = true
  elsif(ARGV.length < 2)
    puts "USAGE: ruby main.rb <users_csv_file> <businesses_csv_file>"
    puts "OR"
    puts "USAGE: ruby main.rb test"
    exit 1
  end
end


check_command_line()

if (@test == true)
  tester = Tester.new
  tester.run_tests()
else
  users_file = ARGV[0]
  businesses_file = ARGV[1]
  
  if (File.extname(users_file) != ".csv" || 
      File.extname(businesses_file) != ".csv")
    puts "Exiting Program: File parameters must be .csv files"
    exit 1
  end

  filter = RecordFilter.new
  filter.create(users_file, businesses_file)
  filter.output()
end


