module LetterOpenerWebS3::LetterExtension
  extend ActiveSupport::Concern

  included do
    cattr_accessor :letters_location do
      "#{%w(tmp letter_opener).join('/')}/"
    end

    class << self
      def search
        letters = LetterOpenerWebS3.bucket.client.list_objects(bucket: LetterOpenerWebS3.bucket.name,
                                                               delimiter: '/',
                                                               prefix: letters_location)
            .common_prefixes.map(&:prefix).map do |folder|
          name = folder.gsub(letters_location, '')[0..-2]
          new id: name, sent_at: Time.at(name.gsub(/\_.+/, '').to_i)
        end
        letters.sort_by(&:sent_at).reverse
      end

      def destroy_all
        LetterOpenerWebS3.bucket.objects(prefix: letters_location).each(&:delete)
      end
    end

    def attachments
      @attachments ||= LetterOpenerWebS3.bucket.objects(prefix: File.join(base_dir, 'attachments'))
                           .each_with_object({}) do |file, hash|
        hash[File.basename(file.key)] = LetterOpenerWebS3.bucket.object(file.key).public_url
      end
    end

    def delete
      LetterOpenerWebS3.bucket.objects(prefix: base_dir).each(&:delete)
    end

    def exists?
      LetterOpenerWebS3.bucket.objects(prefix: base_dir).count > 0
    end

    private

    def base_dir
      "#{letters_location}#{id}"
    end

    def read_file(style)
      Kernel.open(LetterOpenerWebS3.bucket
                      .object(File.join(base_dir, "#{style}.html")).presigned_url(:get)).read
    rescue
      ''
    end

    def style_exists?(style)
      LetterOpenerWebS3.bucket.object(File.join(base_dir, "#{style}.html")).exists?
    end

  end
end
