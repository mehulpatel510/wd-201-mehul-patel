def get_command_line_argument
  # ARGV is an array that Ruby defines for us,
  # which contains all the arguments we passed to it
  # when invoking the script from the command line.
  # https://docs.ruby-lang.org/en/2.4.0/ARGF.html
  if ARGV.empty?
    puts "Usage: ruby lookup.rb <domain>"
    exit
  end
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
    dns_raw.each do |raw|
        #skip comment line
        if raw.start_with?('#') == false
            data = raw.split(",")
            #skip the blank line
            if data.length == 3
                dns_records[data[1].strip] = data[2].strip    
            end
        end
    end
    return dns_records
end

#resolve the dns name to ip address
def resolve(dns_records,lookup_chain,domain)
    #check the dns records have a domain or not 
    if dns_records.keys.include?(domain)
        #find the matching record
        v = dns_records[domain]
        lookup_chain.push(v)
        #to check it ip address or alias domain name
        if v.split(".").length == 4
            return lookup_chain
        else
            #recursice call to resolve function
            resolve(dns_records,lookup_chain,v)
        end
    else
        return ["Error: record not found for gmil.com"]    
    end
    
end

# To complete the assignment, implement `parse_dns` and `resolve`.
# Remember to implement them above this line since in Ruby
# you can invoke a function only after it is defined.
dns_records = parse_dns(dns_raw)
lookup_chain = [domain]
lookup_chain = resolve(dns_records, lookup_chain, domain)
puts lookup_chain.join(" => ")
