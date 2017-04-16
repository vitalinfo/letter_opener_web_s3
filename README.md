# LetterOpenerWebS3 for Rails 5 and Rails 4

Addon for `letter_opener_web` and `letter_opener` gems to store files on Amazon S3 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'letter_opener_web_s3'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install letter_opener_web_s3

## Usage

Configure AWS credentials

```ruby
LetterOpenerWebS3.configure do |spec|
  spec.s3_config = {
      region: AWS_S3_REGION,
      bucket_name: AWS_S3_BUCKET,
      access_key_id: AWS_S3_KEY_ID,
      secret_access_key: AWS_S3_ACCESS_KEY
  }
end
```

To support application assets need configure `action_mailer.asset_host`

Without configuration, gem works like `letter_opener_web` use local file storage

## TODO

Need check letters with attachments 

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/letter_opener_web_s3. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

