require 'fdk'
require 'json'
require 'jwt'
require './lib/mailchimp_service'

def run(context, input)
  puts input.inspect
  if result = decode_token(input)
    puts result.inspect
    DomainService.run!(context, result[0])
  end
end

def decode_token(input)
  JWT.decode(input, ENV['JWT_SECRET'], true, algorithm: 'HS512')
end

FDK.handle(:run)
