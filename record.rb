require 'csv'

#############################################################
#
#############################################################
class Record
  attr_accessor :is_malformed
  attr_accessor :malformed_message
  attr_accessor :header
  attr_accessor :row
  attr_accessor :fields
  
  def initialize
    @header = []
    @row    = []
    @fields = {}
    @malformed_message = []
  end
  
  def create(hdr, rec_row)
    @header = hdr
    @row    = rec_row
    index   = 0
    
    @row.each do |field|
      clean_field = field.strip if !field.nil?

      @fields[@header[index].downcase.strip] = clean_field
      index = index + 1
    end
  end
  
  def add_malformed_message(message)
    @malformed_message << message
  end
  
  def output
    csv_string = CSV.generate do |csv|
      csv << @header
      csv << @row
    end

    puts csv_string
    if (@is_malformed)
      puts @malformed_message
    end
    
  end

end