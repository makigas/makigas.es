# frozen_string_literal: true

if ENV['RAILS_USE_S3'].present?
  # Base settings, they work on all cases.
  Paperclip::Attachment.default_options.update(
    storage: :s3,
    s3_protocol: ENV.fetch('S3_HOST_PROTO', ''),
    s3_credentials: {
      bucket: ENV.fetch('S3_BUCKET_NAME', nil),
      region: ENV.fetch('AWS_REGION', 'us-east-1'),
      access_key_id: ENV.fetch('AWS_ACCESS_KEY_ID', nil),
      secret_key_id: ENV.fetch('AWS_SECRET_ACCESS_KEY', nil)
    }
  )

  # Use custom host as primary (s3-us-west-2 instead of s3, for instance).
  # URL before:            s3.amazonaws.com/cdn.makigas.es/hi.css
  # URL after:   s3-us-west-2.amazonaws.com/cdn.makigas.es/hi.css
  Paperclip::Attachment.default_options[:s3_host_name] = ENV.fetch('S3_HOST_NAME', nil) if ENV['S3_HOST_NAME'].present?

  # Put the bucket in the domain if this env is set to any value.
  # URLs will be like cdn.makigas.es.s3.amazonaws.com/hi.css
  # instead of s3.amazonaws.com/cdn.makigas.es/hi.css
  # Domain name acts as bucket. This block has two use cases:
  # 1. Use bucket name in subdomain, as cdn.makigas.es.s3.amazonaws.com.
  #    Set S3_BUCKET_DOMAIN env variable to any value to enable this.
  #    URL before:    s3.amazonaws.com/cdn.makigas.es/hi.css
  #    URL after:     cdn.makigas.es.s3.amazonaws.com/hi.css
  # 2. Use an alias domain, as cdn.makigas.es Set S3_HOST_ALIAS to the
  #    host alias to use as domain to enable this.
  #    URL before:    s3.amazonaws.com/cdn.makigas.es/hi.css
  #    URL after:     cdn.makigas.es/hi.css
  #    S3_HOST_ALIAS is set to cdn.makigas.es. Usually this domain will
  #    have a CNAME pointing to the bucket domain, although this block
  #    won't care about it as the purpose here is to set the URLs.
  if ENV['S3_BUCKET_DOMAIN'].present? || ENV['S3_HOST_ALIAS'].present?
    Paperclip::Attachment.default_options[:path] = '/:class/:attachment/:id_partition/:style/:filename'
    if ENV['S3_HOST_ALIAS'].present?
      Paperclip::Attachment.default_options[:s3_host_alias] = ENV.fetch('S3_HOST_ALIAS', nil)
      Paperclip::Attachment.default_options[:url] = ':s3_alias_url'
    else
      Paperclip::Attachment.default_options[:url] = ':s3_domain_url'
    end
  end

  # Use a custom endpoint (for instance, Minio or other S3-like APIs)
  if ENV['S3_ENDPOINT'].present?
    Paperclip::Attachment.default_options[:s3_region] = ENV.fetch('AWS_REGION', 'us-east-1')
    Paperclip::Attachment.default_options[:s3_options] = {
      force_path_style: true,
      endpoint: ENV.fetch('S3_ENDPOINT', nil)
    }
  end
end

# Register URIAdapter so that we can add files by URL under controlled environments.
Paperclip::HttpUrlProxyAdapter.register
