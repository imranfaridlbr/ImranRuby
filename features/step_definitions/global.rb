##
# Transform *every* argument for *every* step, converting the placeholder
# defined in config[:global][:unique_token] (e.g. "{id}") into a unique
# session ID. Allows unique entity names to be created per-scenario
#
Transform /^.*$/ do |arg|
    if arg.instance_of?(Cucumber::Ast::Table)
        new_raw = []
        arg.raw().each { |row|
            new_row = []
            row.each { |col|
                col = sub_uid(col)
                new_row.push(col)
            }
            new_raw.push(new_row)
        }
        arg = Cucumber::Ast::Table.new(new_raw)
    else
        sub_uid(arg)
    end
end

def sub_uid input
    input.gsub($config[:global][:unique_token], @unique_token)
end

##
# Convert numbers to integers
#
Transform /^(-?\d+)$/ do |number|
    number.to_i
end

##
# change UNIX path to one compatible with WIndows
# Should be used for every upload step
#
def get_path path
    host_os = RbConfig::CONFIG['host_os']
    case host_os
        when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
            return path.gsub(%r{/}) { "\\" }
        else
            return path
    end
end

##
# Find an element by searching for a string of text in each of a
# set of elements (i.e. something returned by "elements..." in
# the page object rather than "element")
#
# @param [Array<Capybara::Element>] Array of elements to search within
# @param [String] Text to search for
# @param [Boolean] Whether to allow partial matches or not (defaults to
# exact match only)
#
# @return [Capybara::Element||nil] The element, or nil if not found
#
def find_element_by_text elements, text, partial_match = false
    elements.each do | element |
        if partial_match
            return element if element.text =~ /#{text}/
        else
            return element if element.text == text
        end
    end
    puts "Element with text #{text} not found"
    return nil
end

##
# Get the index of an element by searching for a string of text in each of a
# set of elements (i.e. something returned by "elements..." in
# the page object rather than "element")
#
# @param [Array<Capybara::Element>] Array of elements to search within
# @param [String] Text to search for
# @param [Boolean] Whether to allow partial matches or not (defaults to
# exact match only)
#
# @return [int||nil] The element's index, or nil if not found
#
def get_element_index_by_text elements, text, partial_match = false
  elements.each_with_index do | element, index |
    if partial_match
      return index if element.text =~ /#{text}/
    else
      return index if element.text == text
    end
  end
  return nil
end

##
# Get a list of the values of a given table column
#
# @param [Array<Capybara::Element>] Array of elements that contain Html rows <tr>
# @param [Integer] Index of the table column
#
# @return [Array<String>] Array of the column values
#
def get_table_column_values_by_index elements, index
  column_values = []
  elements.each do | element |
    column_values.push(element.all('td')[index].text)
  end
  return column_values
end

##
# Assert text on element method uses find_element_by_text and raises
# a capybara exception if find_element_by_text returns nil.
# @param [Array<Capybara::Element>] Array of elements to search within
# @param [String] Text to search for
# @param [Boolean] Whether to allow partial matches or not (defaults to
# exact match only)
# raises [Capybara::ExpectationNotMet execption]
#
def assert_text_on_element elements, text, partial_match = false
    if find_element_by_text(elements, text)== nil
        elements.each do |element|
            element.assert_text(text)
        end
    end
end

##
# Wait for ajax method makes user of jQuery.active script to
# wait for ajax calls on a page to finish
#

def wait_for_an_element_to_appear
  Timeout.timeout(30) do
    active = page.evaluate_script('jQuery.active')
    until active == 0
      active = page.evaluate_script('jQuery.active')
    end
  end
end

##
# Find an input element by searching for a string of text in each of a
# set of elements (i.e. something returned by "elements..." in the page
# object rather than "element") and then returning the first input element
# within the located element.
#
# Good for finding a checkbox by looking for the library_label_page, then checking/unchecking
# it with .set e.g. find_input_by_text(@page.filters, "Playlist").set(true)
#
# @param [Array<Capybara::Element>] Array of elements to search within
# @param [String] Text to search for
#
# @return [Capybara::Element||nil] The element, or nil if not found
#
def find_input_by_text elements, text, partial_match = false
    el = find_element_by_text elements, text, partial_match
    return nil if not el
    return el.find('input')
end

##
# returns an array of strings with text from passed elements
def get_text_from_elements(elements, downcase = TRUE)
    return elements.map {| element | downcase ? element.text.downcase : element.text}
end

def load_jquery
  page.execute_script <<-JS
       // adding the script tag to the head as suggested before
       var head = document.getElementsByTagName('head')[0];
       var script = document.createElement('script');
       script.type = 'text/javascript';
       script.src = "http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js";
       head.appendChild(script);
  JS
  sleep 3
end


def attach_in_dropzone(file_path)
  load_jquery
  sleep 5
  # Generate a fake input selector
  page.execute_script <<-JS
    fakeFileInput1 = window.$('<input/>').attr(
      {id: 'fakeFileInput1', type:'file'}
    ).appendTo('body');
  JS
  sleep 2
  #page.find('#fakeFileInput1').set(file_path.gsub('/', '\\'))
  page.find('#fakeFileInput1').set(file_path)
  # Trigger the fake drop event
  page.execute_script <<-JS
    var fileList = [fakeFileInput1.get(0).files[0]];
    var e = jQuery.Event('drop', { dataTransfer : { files : fileList } });
     window.dropzone['attachments'].listeners[0].events.drop(e);
  JS
  sleep 2
end

def drop_in_dropzone(file_path)
  load_jquery
  sleep 5
  # Generate a fake input selector
  page.execute_script <<-JS
    fakeFileInput = window.$('<input/>').attr(
      {id: 'fakeFileInput', type:'file'}
    ).appendTo('body');
  JS
  sleep 2
  #page.find('#fakeFileInput').set(file_path.gsub('/', '\\'))
  page.find('#fakeFileInput').set(file_path)
  # Trigger the fake drop event
  page.execute_script <<-JS
    var fileList = [fakeFileInput.get(0).files[0]];
    var e = jQuery.Event('drop', { dataTransfer : { files : fileList } });
     window.dropzone['formContent'].listeners[0].events.drop(e);
  JS
  sleep 2
end