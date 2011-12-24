#! /usr/bin/env ruby
def add url
  url.sub! /^\./, '*'
  url.sub! /\/$/, '/*'
  unless url.start_with?('*')
    url = '*' + url
  end
  "if (shExpMatch(url, '#{url}')) return p1;"
end

s = DATA.read
urls = (File.read 'swlist.txt').split("\n")
urls.each do |url|
  url = url.strip
  next if url == ''
  s.<< add url
end
s << "return 'DIRECT'"
s << "}"

File.open 'rule.pac', 'w' do |f|
  f << s
end
puts 'done pac generation'

__END__
function regExpMatch(url, pattern) {
	try { return new RegExp(pattern).test(url); } catch(ex) { return false; }
}

var p1 = 'SOCKS5 localhost:8888';

function FindProxyForURL(url, host) {
  if (shExpMatch(url, 'encrypted.google.com/*')) return 'DIRECT';
	if (shExpMatch(url, '*.google.com.hk/*')) return 'DIRECT';
	if (shExpMatch(url, '*.cn/*')) return 'DIRECT';
