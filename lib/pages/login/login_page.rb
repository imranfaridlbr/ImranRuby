class LoginPage < SitePrism::Page
    set_url "https://v3test.redbridge.gov.uk/Account/Login"

    #Login page elements
    element :username, "input[name='userName']"
    element :password, "input[name='password']"
    element :login_button, "input[value='Login']"
end