app = Rails.application

Dir["#{ app.config.root }/config/_APP.#{ Rails.env }.yml"].each do |settings_file|
  Settings.add_source!(settings_file)
  puts "Settings: #{settings_file}".yellow
end

Settings.reload!
