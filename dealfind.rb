require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'digest/md5'
require 'mail'

def prompt(question, default)
	print(question)
	result = gets.strip
	if default
		return result.empty? ? default : result
	else
		if result.empty?
			puts "This is required"
			prompt question, nil
		end
		return result
	end
end

@url = prompt "Enter URL (required): ", nil
@refresh_rate = prompt "Enter Refresh Rate (default: 30sec): ", 30
@email_to = prompt "Enter recipient email (required): ", nil
@email_from = prompt "Enter senders email (required): ", nil
@password = prompt "Enter Password: (required): ", nil
@subject = prompt "Enter subject (default: Dealscraper Alert!): ", "Dealscraper Alert!"
@message = prompt "Enter subject (default: Deal in now available.): ", "Deal in now available."
puts @url, @refresh_rate, @email_to, @email_from.to_s, @subject, @message
@deal_disabled = true

def scrape_el
	page = Nokogiri::HTML(open(@url.to_s))   
	button_el = page.css("div#sold-out-or-expired[disabled]")
	digest = Digest::MD5.hexdigest(button_el.to_s)
end

@disabled_digest = scrape_el

puts 'disabledHEX: ' + @disabled_digest


while @deal_disabled
	if scrape_el != @disabled_digest
		
		options = { :address      => "smtp.gmail.com",
			:port                 => 587,
			:user_name            => @email_from.to_s,
			:password             => @password.to_s,
			:authentication       => 'plain',
			:enable_starttls_auto => true  }
		
		Mail.defaults do
			delivery_method :smtp, options
		end
		
		Mail.new(
			to: @email_to.to_s,
			from: @email_from.to_s,
			subject: @subject.to_s,
			body: @message.to_s
		).deliver!
			
		@deal_disabled = false
	end
	puts 'Still Disabled'
	sleep @refresh_rate.to_i
end

