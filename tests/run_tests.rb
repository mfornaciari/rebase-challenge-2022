Dir["#{Dir.pwd}/*.rb"].each do |file|
  file == "#{Dir.pwd}/#{$0}" ? next : (require file)
end
