def get_command_line_argument
    # ARGV is an array that Ruby defines for us,
    # which contains all the arguments we passed to it
    # when invoking the script from the command line.
    # https://docs.ruby-lang.org/en/2.4.0/ARGF.html
    if ARGV.empty?
      puts "Usage: ruby lookup.rb <domain>"
      exit
    end
<<<<<<< HEAD:DNS resolver/lookup.rb
    ARGV.first
  end
  
  # `domain` contains the domain name we have to look up.
  domain = get_command_line_argument
  
  # File.readlines reads a file and returns an
  # array of string, where each element is a line
  # https://www.rubydoc.info/stdlib/core/IO:readlines
  dns_raw = File.readlines("zone")
  
  #parse the data from raw to hash
  def parse_dns(dns_raw)
      dns_records = {}
      dns_raw.
          reject {|line| line.empty? }.
          map {|line| line.strip.split(", ") }.
          reject do |record|
              # 'Reject' records that aren't valid.
              record.length ==0 || record[0].start_with?('#')
          end.
          each_with_object({}) do |record, records|
              # Modify the `records` hash so that it contains necessary details.
              dns_records[record[1]] = {type:record[0],target:record[2]}   
          end
      dns_records
  end
  
  #resolve the dns name to ip address
  def resolve(dns_records,lookup_chain,domain)
      record = dns_records[domain]
      if (!record)
          return ["Error: record not found for #{domain}"]
      elsif record[:type] == "CNAME"
          lookup_chain.push(record[:target])
          resolve(dns_records,lookup_chain,record[:target])
      elsif record[:type] == "A"
          lookup_chain.push(record[:target])
          return lookup_chain
      else
          return ["Invalid record type for #{domain}"]
      end
  end
  
  # To complete the assignment, implement `parse_dns` and `resolve`.
  # Remember to implement them above this line since in Ruby
  # you can invoke a function only after it is defined.
  dns_records = parse_dns(dns_raw)
  lookup_chain = [domain]
  lookup_chain = resolve(dns_records, lookup_chain, domain)
  puts lookup_chain.join(" => ")
=======
    
end

# To complete the assignment, implement `parse_dns` and `resolve`.
# Remember to implement them above this line since in Ruby
# you can invoke a function only after it is defined.
dns_records = parse_dns(dns_raw)
lookup_chain = [domain]
lookup_chain = resolve(dns_records, lookup_chain, domain)
puts lookup_chain.join(" => ")
>>>>>>> cbd97562fb999f9acfcb8f208ffee60b596dee5c:DNS resolver/lookup_v2.rb
