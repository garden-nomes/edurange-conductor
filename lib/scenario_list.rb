class ScenarioList
  def self.list
    # grab all yaml files exactly two directories deep
    paths = Dir[File.join(ROOT_DIR, 'scenarios', '*', '*', '*.yml')]

    # extract location and scenario name from path
    scenarios = paths.map do |path|
      split_path = path.split(File::Separator)
      { name: split_path[-2], location: split_path[-3] }
    end

    # group by location
    scenarios = scenarios.group_by { |s| s[:location] }

    # map scenarios from { name: ..., location: ... } into just 'name'
    # see https://stackoverflow.com/a/5189259/7351962 if this is confusing
    Hash[scenarios.map { |k, v| [k, v.map { |s| s[:name] }] }]
  end
end
