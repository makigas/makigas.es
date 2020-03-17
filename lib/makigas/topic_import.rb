import 'yaml'

class Makigas::TopicImport
  def initialize schema
    @schema = YAML.load(File.read(schema))
    @schema.each do |topic|
      Topic.create!(title: topic["title"], description: topic["description"], color: topic["color"])
    end
  end
end
