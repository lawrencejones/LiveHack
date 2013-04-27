configure :production, :development do 

	db = URI.parse(ENV['DATABASE_URL'] || 'postgres://lawrencejones:AE065c72b5@localhost:5432/livehack')

	ActiveRecord::Base.establish_connection(
			:adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
			:host     => db.host,
			:username => db.user,
			:password => db.password,
			:database => db.path[1..-1],
			:encoding => 'utf8'
		)
	
end