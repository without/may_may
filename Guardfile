group :red_green_refactor, halt_on_fail: true do
  guard :minitest do
    watch(%r{^test/(.*)\/?test_(.*)\.rb$})
    watch(%r{^lib/(.*/)?([^/]+)\.rb$})     { |m| "test/#{m[1]}test_#{m[2]}.rb" }
    watch(%r{^test/test_helper\.rb$})      { 'test' }

    callback(:start_begin) { `#{ENV['EDITOR']} .` }

    watch(%r{^app/(.+)\.rb$})                               { |m| "test/#{m[1]}_test.rb" }
    watch(%r{^app/controllers/application_controller\.rb$}) { 'test/controllers' }
    watch(%r{^app/controllers/(.+)_controller\.rb$})        { |m| "test/integration/#{m[1]}_test.rb" }
    watch(%r{^app/views/(.+)_mailer/.+})                    { |m| "test/mailers/#{m[1]}_mailer_test.rb" }
    watch(%r{^lib/(.+)\.rb$})                               { |m| "test/lib/#{m[1]}_test.rb" }
    watch(%r{^test/.+_test\.rb$})
    watch(%r{^test/test_helper\.rb$}) { 'test' }
    watch(%r{^app/helpers/(.*)\.rb$}) { |m| "test/helpers/#{m[1]}_test.rb" }
  end

  guard :rubocop, all_on_start: true, cli: ['-R', '--format', 'clang', '-D', '-E', '-a'] do
    # guard :rubocop, cli: ["--format", "clang", "--rails", "-D", "-E", "-a"] do
    watch('Gemfile')
    watch(/.+\.rb$/)
    watch(%r{(?:.+/)?\.rubocop\.yml$}) { |m| File.dirname(m[0]) }
    watch(%r{(?:.+/)?\.rubocop_todo\.yml$}) { |m| File.dirname(m[0]) }
  end
end

guard :bundler do
  require 'guard/bundler'
  require 'guard/bundler/verify'
  helper = Guard::Bundler::Verify.new

  files = ['Gemfile']
  files += Dir['*.gemspec'] if files.any? { |f| helper.uses_gemspec?(f) }

  # Assume files are symlinked from somewhere
  files.each { |file| watch(helper.real_path(file)) }
end
