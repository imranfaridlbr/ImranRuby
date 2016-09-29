class DashboardPage < SitePrism::Page
  set_url "https://v3test.redbridge.gov.uk/"

  #Homepage elements
  element :dashboard_info, "div[class='information']"
  element :parking_link, "a[href='//v3test.redbridge.gov.uk/Parking']"

end