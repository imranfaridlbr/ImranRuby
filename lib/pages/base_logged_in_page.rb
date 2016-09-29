# This is the base page class for a logged in user.
# Anything the user sees common to every page as a logged in user should go here.
#
# If something is common to only some pages, a new base page should probably be created
# which extends BaseLoggedInPage.

class BaseLoggedInPage < SitePrism::Page
    set_url_matcher /ENV['BASE_URL']\/?/

    # Top bar
    element :application_user_bar, "div.app-bar-user-info"
    element :notifications_link, "#app-bar .notifications"
    element :notifications_active_icon, ".app-bar-notifications-icon--active"
    element :notification_count_0, :xpath, "//div[@id='app-bar']/a[2]/div[text()='0']"
    element :notification_count_1, :xpath, "//div[@id='app-bar']/a[2]/div[text()='1']"

    # Application links
    element :application_directory_link, ".application .directory"
    element :application_library_link, ".applications .library"
    element :application_distribution_link, ".applications .distribution"
    element :application_feedroom_link, ".applications .distribution"
    element :application_admin_link, ".applications .admin"

    # Sidebar
    element :left_side_bar, ".sidebar"

    # In-page messages
    element :message_bar_success, ".generic-message-bar.success"

    # User dropdown
    # TODO poorly named and hardcoded
    element :login_detail_panel, ".app-bar-user-info-details"
    element :login_detail_panel_box, ".app-bar-user-info-dropdown"
    element :user_2, "a[href*='rightster2']"
    element :user_3, "a[href*='rightster3']"
    elements :user_accounts_list, "ul.app-bar-user-info-dropdown-accounts"
end
