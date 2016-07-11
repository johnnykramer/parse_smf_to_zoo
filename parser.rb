require 'open-uri'
require 'nokogiri'
require 'json'
require 'mechanize'

agent = Mechanize.new
agent.user_agent_alias = 'Windows Chrome'
print 'Link: '
@doc = agent.get(gets.chomp)

json12 = {}
json11 = {}
json10 = {}
json9 = {}
json8 = {}
json7 = {}
json6 = {}
json5 = {}
json4 = {}
json3 = {}
json2 = {}
json1 = {}

@LPAGE = @doc.css('.pagelinks .navPages').last.text.to_i

@LPAGE.times do
  
  @doc.css('.post_wrapper').each do |iter|
  
    id = iter.at_css('.inner')['id'].split('_').last.to_i
    created = Time.now.to_s.split(' +').first.strip
    modified = created
    text = iter.at_css('.inner').inner_html
    email = iter.css('.bbc_email').text
    
    json12 = {
      :value => email
    }
    
    json11 = {
      :'0' => json12
    }
    
    json10 = {
      :type => 'textpro',
      :name => 'textproname',
      :data => json11
    }
    
    json9 = {
      :'0' => 'translate',
      :'1' => '_root'
    }
    
    json8 = {
      :enable_comments => 1,
      :primary_category => 'translate'
    }
    
    json7 = {:value => text}
    
    json6 = {
      :'0' => json7
    }
    
    json5 = {
      :type => 'textareapro',
      :name => 'textareaproname',
      :data => json6
    }
    
    json4 = {
      :'68687bf0-16f2-4e05-a762-f5d432802e75' => json5,
      :'58ec22e6-6cdc-4338-b562-52b54eecf58d0' => json10
    }
    
    json3 = {
      :created => created,
      :modified => modified,
      :elements => json4,
      :group => '\u0412\u0430\u043A\u0430\u043D\u0441\u0438\u044F',
      :name => id.to_s,
      :searchable => '1',
      :state => '0',
      :priority => '0',
			:author => 'admin',
			:config => json8,
			:categories => json9
    }
    
    json2[id] = json3
    
  end
  
  targetlink = (@doc.css('.pagelinks strong')[0].text.to_i + 1).to_s
  
  if targetlink != @LPAGE.to_s
    @doc = agent.get(@doc.link_with(:text => targetlink).href)
  end
  
end

json1 = {:items => json2}

file = File.new('parsed.json', 'w')
file.puts JSON.pretty_generate(json1)
