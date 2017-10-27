source 'https://rubygems.org'

# Specify your gem's dependencies in functional_hash.gemspec
gemspec

# Put gems only used in local deveopment in Gemfile.dev, and they'll be loaded
# here.
eval(IO.read('./Gemfile.dev'), binding) if File.exist? './Gemfile.dev'
