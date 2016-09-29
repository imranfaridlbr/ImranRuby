module ApiClient
    # TODO investigate ways of making the api client into a singleton
    # as this file is going to get big and ugly
    class SitesApiClient < BaseSitesApiClient
        def create_label(title)
            post_request(
                'library-labels/create-label',
                { 'title' => title }
            )
        end
    end
end
