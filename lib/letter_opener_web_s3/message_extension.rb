module LetterOpenerWebS3::MessageExtension
  extend ActiveSupport::Concern

  included do
    def initialize(location, mail, part = nil)
      @location = location.gsub("#{Rails.root.to_s}/", '')
      @mail = mail
      @part = part
      @attachments = []
    end

    def render
      if mail.attachments.any?
        attachments_dir = File.join(@location, 'attachments')
        # TODO: need check render with attachment
        mail.attachments.each do |attachment|
          filename = attachment.filename.gsub(/[^\w.]/, '_')
          path = File.join(attachments_dir, filename)

          object(path).put(body: attachment.body.raw_source, content_length: attachment.body.raw_source.size)

          @attachments << [attachment.filename, "attachments/#{URI.escape(filename)}"]
        end
      end

      str = ERB.new(template).result(binding)
      object(filepath).put(body: str, content_length: str.size)
    end

    def template
      letter_opener_path = $".select{|f| f.match(/letter_opener\/message.rb/)}.first
      File.read(File.join(letter_opener_path.gsub('message.rb', ''), 'message.html.erb'))
    end

    private

    def object(filepath)
      LetterOpenerWebS3.bucket.object(filepath)
    end
  end
end
