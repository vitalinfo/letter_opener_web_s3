module LetterOpenerWebS3::MessageExtension
  extend ActiveSupport::Concern

  included do
    def initialize(mail, options = {})
      location = options[:location]
      @location = location.gsub("#{Rails.root.to_s}/", '')
      @mail = mail
      @part = options[:part]
      @attachments = []
    end

    def render
      if mail.attachments.any?
        attachments_dir = File.join(@location, 'attachments')
        mail.attachments.each do |attachment|
          filename = attachment.filename.gsub(/[^\w.]/, '_')
          path = File.join(attachments_dir, filename)

          object(path).put(body: attachment.body.raw_source, content_length: attachment.body.raw_source.size)

          @attachments << [attachment.filename, URI.escape(object(path).public_url)]
        end
      end

      str = ERB.new(template).result(binding)
      object(filepath).put(body: str, content_length: str.size)
    end

    def template
      letter_opener_path = $".select{|f| f.match(/letter_opener\/message.rb/)}.first
      File.read(File.join(letter_opener_path.gsub('message.rb', ''), 'message.html.erb'))
    end

    def body
      @body ||= begin
        body = (@part || @mail).decoded

        mail.attachments.each do |attachment|
          item = @attachments.select{|filename, _| filename == attachment.filename}.first
          body.gsub!(attachment.url, item.last)
        end

        body
      end
    end

    private

    def object(filepath)
      LetterOpenerWebS3.bucket.object(filepath)
    end
  end
end
