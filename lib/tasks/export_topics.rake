namespace :makigas do
  namespace :export do
    desc 'Exports topics as a YAML document.'
    task topics: :environment do
      @topics = Topic.all
      @documents = @topics.map do |topic|
        {
          'title' => topic.title,
          'description' => topic.description,
          'color' => topic.color
        }
      end
      puts @documents.to_yaml
    end
  end
end
