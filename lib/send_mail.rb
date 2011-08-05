require "send_mail/version"

module SendMail
  class System
    attr_accessor :recipient
    attr_accessor :sender
    attr_accessor :subject
    attr_accessor :body
    attr_reader   :error
  
    def initialize(params={})
      if params[:recipient] =~ /@\w+\.\w+/
        @recipient = params[:recipient]
      else
        @recipient = nil
      end
      if params[:sender] =~ /@\w+\.\w+/
        @sender = params[:sender]
      else
        @sender = nil
      end
      @subject = params[:subject]
      @body = params[:body]
    
      yield self if block_given?
    end
  
    def send
      if !@recipient.to_s.empty? && !@sender.to_s.empty? && !@body.to_s.empty?
        sendmail = system('which sendmail > /dev/null 2>/dev/null') ? `which sendmail` : '/usr/sbin/sendmail'
        sendmail.gsub!(/\n/,'')
        mail = IO.popen(%[#{sendmail} -v -r \"#{@sender}\" \"#{@recipient}\"],'w+')
        if !@subject.to_s.empty?
          mail.puts("Subject: #{@subject}")
        end
        mail.puts(body)
        mail.puts('.')
        status = mail.read
        if status =~ /error/i
          @error = "Error when sending message."
        end
      else
        missing = []
        if @recipient.to_s.empty?
          missing << "Recipient"
        end
        if @sender.to_s.empty?
          missing << "Sender"
        end
        if @body.to_s.empty?
          missing << "Body"
        end
        sentence = ""
        length = missing.length || missing.count
        if length > 1
          missing.each do |item|
            length -= 1
            if length > 0
              sentence += "#{item}, "
            else
              sentence += "and #{item}"
            end
          end
        else
          sentence = missing.to_s
        end
        @error = "#{sentence} #{missing.count > 1 ? "are" : "is"} missing. Please fill in missing fields."
      end
      if @error.to_s.empty?
        return true
      else
        raise @error
      end
    end
  end
end
