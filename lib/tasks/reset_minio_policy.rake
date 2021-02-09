# frozen_string_literal: true

class ResetMinioPolicy
  include Rake::DSL

  def initialize
    namespace :makigas do
      desc 'Sets the Minio Bucket policy.'
      task init_bucket: :environment do
        # This task should only be used if you're using Minio for storage (as I am)
        s3 = Aws::S3::Client.new(connection_settings)
        put_bucket_policy(s3)
      end
    end
  end

  private

  def put_bucket_policy(client)
    client.put_bucket_policy(bucket: bucket_name, policy: bucket_policy)
  rescue Aws::S3::Errors::NoSuchBucket
    client.create_bucket(bucket: bucket_name)
    retry
  end

  def connection_settings
    { region: ENV.fetch('AWS_REGION') { 'us-east-1' },
      access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
      force_path_style: true }.tap do |settings|
        settings[:endpoint] = ENV['S3_ENDPOINT'] if ENV['S3_ENDPOINT'].present?
      end
  end

  def bucket_name
    raise 'S3_BUCKET_NAME env var not set.' if ENV['S3_BUCKET_NAME'].blank?

    ENV['S3_BUCKET_NAME']
  end

  def bucket_policy
    { "Version": '2012-10-17',
      "Statement": [{ "Action": ['s3:GetObject'],
                      "Effect": 'Allow',
                      "Principal": { "AWS": ['*'] },
                      "Resource": ["arn:aws:s3:::#{bucket_name}/**"],
                      "Sid": '' }] }.to_json
  end
end

ResetMinioPolicy.new
