# VERSIONING

git_version_cmd = "git describe origin"
$revision = `#{git_version_cmd}`
$revision = $revision.strip
puts "starting version: #{$revision}"
