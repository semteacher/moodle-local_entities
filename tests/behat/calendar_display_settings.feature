@local @local_entities @local_entities_calendar
Feature: Configure the entity calendar display
  In order to display entity availability consistently
  As an administrator
  I need the configured first weekday and time format to apply to every entity calendar

  Background:
    Given the following "local_entities > entities" exist:
      | name                  | shortname       | maxallocation | openinghours |
      | Calendar display test | calendardisplay | 10            | [{"title":"openinghours","daysofweek":"1,5,7","starttime":"10:11","endtime":"15:12"}] |
    ##And the following config values are set as admin:
    ##  | usetreelist | 1 | local_entities |
    And I log in as "admin"

  @javascript
  Scenario Outline: Calendar settings apply to the detail and full-size calendar views
    Given the following config values are set as admin:
      | usetreelist        | <treelist>   | local_entities |
      | activeviewtemplate | calendar     | local_entities |
      | calendarfirstday   | <firstday>   | local_entities |
      | calendartimeformat | <timeformat> | local_entities |
    When I visit "/local/entities/entities.php"
    ##And I should see "Calendar display test" 
    ##And I click on "View" "link"
    And I click on "Calendar display test" "link"
    And I wait until the page is ready
    Then "(//div[@id='entity-calendar']//th[contains(@class, 'fc-col-header-cell')]//a)[1][normalize-space()='<weekday>']" "xpath_element" should exist
    When I click on ".fc-timeGridWeek-button" "css_element"
    Then "(//div[@id='entity-calendar']//td[contains(@class, 'fc-timegrid-slot-label')]//*[contains(@class, 'fc-timegrid-slot-label-cushion')])[1][normalize-space()='<midnight>']" "xpath_element" should exist

    When I click on "Open calendar in full size" "link"
    And I switch to a second window
    And I wait until the page is ready
    Then "(//div[@id='entity-calendar']//th[contains(@class, 'fc-col-header-cell')]//a)[1][normalize-space()='<weekday>']" "xpath_element" should exist
    When I click on ".fc-timeGridWeek-button" "css_element"
    Then "(//div[@id='entity-calendar']//td[contains(@class, 'fc-timegrid-slot-label')]//*[contains(@class, 'fc-timegrid-slot-label-cushion')])[1][normalize-space()='<midnight>']" "xpath_element" should exist

    Examples:
      | treelist | firstday | timeformat | weekday | midnight |
      | 1        | 0        | 12         | Sun     | 12 AM    |
      ##| 0        | 0        | 12         | Sun     | 12 AM    |
      | 1        | 1        | 24         | Mon     | 24:00    |
