# verify the client request version
class ApiVersionConstraint
	def initialize(options)
		@version = options[:version]
		@default = options[:default]
	end

	def matches?(req)
		@default || req.headers['Accept'].include?('application/vnd.rails-api-sketch.v#{@version}')
	end
end
