require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'digest/md5'
require 'mail'

page = Nokogiri::HTML(open("http://www.dealfind.com/en/mississauga/28157850"))   
buttonEl = page.css("div#sold-out-or-expired[disabled]")

digest = Digest::MD5.hexdigest(buttonEl.to_s)
puts digest
ifTrue = true

while ifTrue
	if digest != "cecb454d801b4ab062d12322a7a620ef"
		isTrue == false
		require 'mail'
		
		options = { :address              => "smtp.gmail.com",
			:port                 => 587,
			:user_name            => 'stuffstosells@gmail.com',
			:password             => 'azsxdcfv',
			:authentication       => 'plain',
			:enable_starttls_auto => true  }
		
		
		
		Mail.defaults do
			delivery_method :smtp, options
		end
		
		Mail.deliver do
			to 'dwahiche@infusion.com'
			from 'stuffstosells@gmail.com'
			subject 'BUY NOW!'
			body 'HURRY UP BIIIITTTTCCCHHH!'
		end
	end
	puts 'true'
	sleep 30
end

