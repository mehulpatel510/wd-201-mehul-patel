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
    dns_raw.
        reject {|line| line.empty? }.
        map {|line| line.strip.split(", ") }.
        reject do |record|
            # 'Reject' records that aren't valid.
            record.length ==0 or record[0].start_with?('#')
        end.
        each_with_object({}) do |record, records|
            # Modify the `records` hash so that it contains necessary details.
            dns_records[record[1]] = record[2]    
        end
    dns_records
end

#resolve the dns name to ip address
def resolve(dns_records,lookup_chain,domain)
    if dns_records.keys.include?(domain)
        source = dns_records[domain]
        lookup_chain.push(source)
        if source.split(".").length == 4
            lookup_chain
        else
            resolve(dns_records,lookup_chain,source)
        end
    else
        lookup_chain.clear.push("Error: record not found for #{domain}")    
    end
    
end

# To complete the assignment, implement `parse_dns` and `resolve`.
# Remember to implement them above this line since in Ruby
# you can invoke a function only after it is defined.
dns_records = parse_dns(dns_raw)
lookup_chain = [domain]
lookup_chain = resolve(dns_records, lookup_chain, domain)
puts lookup_chain.join(" => ")
