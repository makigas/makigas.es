namespace :makigas do
  namespace :minio do
    desc 'Sets the Minio bucket policy.'
    task init_bucket: :environment do
      # This task should only be used if you're using Minio for storage (as I am)
      raise "S3_BUCKET_NAME env var not set." unless ENV['S3_BUCKET_NAME'].present?

      # Connection settings.
      conn_settings = {
        region: ENV.fetch('AWS_REGION') { 'us-east-1' },
        access_key_id: ENV['AWS_ACCESS_KEY_ID'],
        secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
        force_path_style: true
      }
      conn_settings[:endpoint] = ENV['S3_ENDPOINT'] if ENV['S3_ENDPOINT'].present?

      # Bucket policy.
      bucket_policy = {
        "Version": "2012-10-17",
        "Statement": [
          {
            "Action": ["s3:GetObject"],
            "Effect": "Allow",
            "Principal": {
              "AWS": ["*"]
            },
            "Resource": ["arn:aws:s3:::#{ENV['S3_BUCKET_NAME']}/**"],
            "Sid": ""
          }
        ]
      }.to_json

      s3 = Aws::S3::Client.new(conn_settings)
      begin
        s3.put_bucket_policy(bucket: ENV['S3_BUCKET_NAME'], policy: bucket_policy)
      rescue Aws::S3::Errors::NoSuchBucket
        # The bucket has not been created yet. Create it.
        s3.create_bucket(bucket: ENV['S3_BUCKET_NAME'])
        s3.put_bucket_policy(bucket: ENV['S3_BUCKET_NAME'], policy: bucket_policy)
      end
    end
  end
end
