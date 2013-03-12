# VERSIONING

git_version_cmd = "git describe --always #{Rails.env.production? ? 'origin' : 'master'}"
$revision = `#{git_version_cmd}`
$revision = $revision.strip
puts "starting version: #{$revision}"
