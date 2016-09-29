# Hooks to be executed before/after scenarios
Before do |scenario|
    #@unique_token = SecureRandom.hex(2)
    #puts "Unique token: " + @unique_token

    if $reusing_browser
        puts "Reusing browser for scenario outline"
    end

    if $config[:global][:reuse_browser_for_outline]
        $reuse_browser = scenario.source_tag_names.include? '@reuse_browser_for_outline'
        if $reuse_browser_for_outline
            $scenario_name = scenario.scenario_outline.name
        end
    end
end