require 'json'
require "gibbon"

# Sync mailchimp segments
#
# environment vars in fn application:
#   API_KEY: mailchimp api_key
#   LIST_ID: mailchimp list id
#
# input:
#

class DomainService
  def initialize(context, input)
    raise 'missing API_KEY env' if ENV['API_KEY'].nil?
    raise 'missing LIST_ID env' if ENV['LIST_ID'].nil?

    @context = context
    @input = input
  end

  def self.run!(context, input)
    STDERR.puts("[MailchimpService] start for call_id  #{context.call_id}")
    new(context, input).run
  end

  def run
    STDERR.puts("[MailchimpService] #{call_id} - Processing #{input_action}")

    sync_mailchimp
  end

  def gibbon
    @gibbon = Gibbon::Request.new(api_key: ENV['API_KEY'])
  end

  def sync_mailchimp
    STDERR.puts "DELETING DUPLICATE SEGMENTS"
    segments_list = gibbon.lists(ENV['LIST_ID']).segments.retrieve(params: {"fields": "segments.id,segments.name", "count": "5000"})

    segments_parsed = segments_list.body['segments']

    segments_duplicated = []

    segments_parsed.each do |s|
      segments_parsed.each do |ss|
        if s['name'] == ss['name'] and s['id'] != ss['id'] and !ss['name'].match(/^M/).nil?
          segment_yet_added = false
          segments_duplicated.each do |dup|
            if dup['id'] == ss['id']
              segment_yet_added = true
            end
          end
          segments_duplicated << ss if !segment_yet_added
        end
      end
    end

    segments_duplicated.each do |dup|
      gibbon.lists(ENV['LIST_ID']).segments(dup['id']).delete
    end

    STDERR.puts "DELETED SEGMENTS"
  end

  private

  def input_action
    @input_action ||= @input['action']
  end

  def call_id
    @call_id ||= @context.call_id
  end
end

