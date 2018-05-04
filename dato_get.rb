require 'dato'
require 'dotenv'
require 'pp'

token = ENV['DATO_API_TOKEN']

if token.blank? && File.exist?('.env')
  token = Dotenv::Environment.new('.env', true)['DATO_API_TOKEN']
end

if token.blank?
  raise RuntimeError, 'Missing DatoCMS site API token!'
end

client = Dato::Site::Client.new(token)

### ITEM TYPES ###
#pp client.item_types.all

### FIELDS ####
pp client.fields.all(31443)
