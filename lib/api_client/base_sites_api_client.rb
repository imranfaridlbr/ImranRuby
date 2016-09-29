module ApiClient
    class BaseSitesApiClient < BaseApiClient
        def initialize
            # TODO this is a bit scruffy
            @host = ENV['BASE_URL']
            @base_path = '/internal-api/'
            @base_url = @host + @base_path
        end

        def set_cookie cookie
            @apollo_cookie_value = cookie[:value]
        end

        def clear_cookie
            @apollo_cookie_value = nil
        end

        def post_request url, data
            response = RestClient.post(
                @base_url + url,
                data,
                {
                    :content_type => :json ,
                    :cookies => { :apollo => @apollo_cookie_value }
                }

            )
            JSON.parse response
        end
    end
end
