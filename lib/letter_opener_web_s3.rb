require 'active_support'
require 'aws-sdk-s3'
require 'letter_opener'
require 'letter_opener_web'
require "letter_opener_web_s3/version"
require "letter_opener_web_s3/message_extension"
require "letter_opener_web_s3/letter_extension"

module LetterOpenerWebS3
  mattr_accessor :s3_config

  # @api private
  class S3ConfigError < StandardError; end

  # @api private
  class S3CredentialsError < StandardError
    def message
      "Credentials not found"
    end
  end

  class << self
    # Sets up an S3 backend
    #
    # @s3_config [String] region            The AWS region to connect to
    # @s3_config [String] bucket_name       The name of the bucket where files will be stored
    # @s3_config [String] access_key_id     Access key ID
    # @s3_config [String] secret_access_key Secret access key
    # @see http://docs.aws.amazon.com/AWSRubySDK/latest/AWS/Core/Configuration.html
    # @see http://docs.aws.amazon.com/AWSRubySDK/latest/AWS/S3.html
    def configure
      extensions = -> do
        LetterOpener::Message.send :include, LetterOpenerWebS3::MessageExtension
        LetterOpenerWeb::Letter.send :include, LetterOpenerWebS3::LetterExtension
      end

      if ActiveSupport.version.to_s.start_with?('4')
        ActionDispatch::Reloader.to_prepare { extensions.call }
      else
        ActiveSupport::Reloader.to_prepare { extensions.call }
      end

      yield self
    end

    def bucket
      raise S3ConfigError if !s3_config.is_a?(Hash) ||
          (s3_config.keys & [:region, :bucket_name, :access_key_id, :secret_access_key]).size != 4
      return @bucket if @bucket
      @s3 = Aws::S3::Resource.new s3_config.slice(:region, :access_key_id, :secret_access_key)
      credentials = @s3.client.config.credentials
      raise S3CredentialsError unless credentials
      @bucket = @s3.bucket s3_config[:bucket_name]
    end

  end

end


