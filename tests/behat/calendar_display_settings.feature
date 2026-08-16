@local @local_entities @local_entities_calendar
Feature: Configure the entity calendar display
  In order to display entity availability consistently
  As an administrator
  I need the configured first weekday and time format to apply to every entity calendar

  Background:
    Given the following "local_entities > entities" exist:
      | name                  | shortname       |
      | Calendar display test | calendardisplay |
    And I log in as "admin"

  @javascript
  Scenario Outline: Calendar settings apply to the detail and full-size calendar views
    Given the following config values are set as admin:
      | activeviewtemplate | calendar     | local_entities |
      | calendarfirstday   | <firstday>   | local_entities |
      | calendartimeformat | <timeformat> | local_entities |
    When I visit "/local/entities/entities.php"
    And I click on "Calendar display test" "link"
    And I wait until the page is ready
    Then "(//div[@id='entity-calendar']//th[contains(@class, 'fc-col-header-cell')]//a)[1][normalize-space()='<weekday>']" "xpath_element" should exist
    When I click on ".fc-timeGridWeek-button" "css_element"
    Then "(//div[@id='entity-calendar']//td[contains(@class, 'fc-timegrid-slot-label')]//*[contains(@class, 'fc-timegrid-slot-label-cushion')])[1][normalize-space()='<midnight>']" "xpath_element" should exist

    When I click on "Open calendar in full size" "link"
    And I switch to the newly opened window
    And I wait until the page is ready
    Then "(//div[@id='entity-calendar']//th[contains(@class, 'fc-col-header-cell')]//a)[1][normalize-space()='<weekday>']" "xpath_element" should exist
    When I click on ".fc-timeGridWeek-button" "css_element"
    Then "(//div[@id='entity-calendar']//td[contains(@class, 'fc-timegrid-slot-label')]//*[contains(@class, 'fc-timegrid-slot-label-cushion')])[1][normalize-space()='<midnight>']" "xpath_element" should exist

    Examples:
      | firstday | timeformat | weekday | midnight |
      | 0        | 12         | Sun     | 12 AM    |
      | 1        | 24         | Mon     | 24:00    |
