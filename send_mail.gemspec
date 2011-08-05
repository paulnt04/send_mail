# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "send_mail/version"

Gem::Specification.new do |s|
  s.name        = "send_mail"
  s.version     = SendMail::VERSION
  s.authors     = ["Paul Panarese"]
  s.email       = ["git@panjunction.com"]
  s.homepage    = "http://paulpanarese.com"
  s.summary     = %q{System sendmail utility}
  s.description = %q{Simplifies usage of system sendmail utility.}

  s.rubyforge_project = "send_mail"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
