# frozen_string_literal: true

User.create(email: 'root@makigas.es', password: 'password')

topic = Topic.create(title: 'Mejora tus skills', color: '#2196f3',
                     description: 'Para mejorar tus skills',
                     thumbnail: Rails.root.join('spec/fixtures/topic.png').open)
playlist = Playlist.create(title: 'Tutorial de Git', description: 'Para aprender Git',
                           youtube_id: 'PLTd5ehIj0goMCnj6V5NdzSIHBgrIXckGU', topic:,
                           thumbnail: Rails.root.join('spec/fixtures/playlist.png').open,
                           card: Rails.root.join('spec/fixtures/card.jpg').open)
video = Video.create(title: 'Cómo instalar Git', description: 'Cómo instalar Git',
                     youtube_id: '1PiYqxog8mc', duration: 533, playlist:, position: 1)
video.update(published_at: video.created_at)
