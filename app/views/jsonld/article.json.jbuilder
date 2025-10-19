# frozen_string_literal: true

json.key_format! camelize: :lower

json.set! '@context', 'https://schema.org'
json.set! '@type', 'TechArticle'

json.headline article.title
json.description article.description
json.datePublised article.published_at.iso8601
json.dateModified article.updated_at.iso8601
mainEntityOfPage playlist_video_path(article, playlist_id: article.playlist)

json.author do
  json.set! '@type', 'Person'
  json.name article.user.name
end

json.publisher do
  json.set! '@type', 'Organization'
  json.name 'Makigas'
  json.logo do
    json.set! '@type', 'ImageObject'
    json.url 'https://www.makigas.es/icons/color/makigas-512.png'
  end
end
