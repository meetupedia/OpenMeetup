# VERSIONING

git_version_cmd = "git describe"
$revision = `#{git_version_cmd}`
$revision = $revision.strip
puts "starting version: #{$revision}"
