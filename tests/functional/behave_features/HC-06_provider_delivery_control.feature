Feature: Report only submission with provider control settings
  Partners can prevent publication of their chart by submitting
  error-free report that was generated by chart-verifier and with
  prvider controlled delivery set in the report and the OWNERS file.

  @external-feedback
  Scenario Outline: [HC-06-001] A partner associate submits an error-free report with provider controlled delivery
    Given the vendor "<vendor>" has a valid identity as "<vendor_type>"
    And provider delivery control is set to "<provider_control_owners>" in the OWNERS file
    And a "<report_path>" is provided
    And provider delivery control is set to "<provider_control_report>" in the report
    When the user sends a pull request with the report
    Then the user sees the pull request is merged
    And the "<index_file>" is updated with an entry for the submitted chart

    @partners @smoke @full
    Examples:
      | vendor_type  | vendor    | report_path               | index_file                        | provider_control_owners | provider_control_report |
      | partners     | hashicorp | tests/data/report.yaml    | unpublished-certified-charts.yaml | true                    | true                    |

  @external-feedback 
  Scenario Outline: [HC-06-002] A partner associate submits an error-free report and chart with provider controlled delivery
    Given the vendor "<vendor>" has a valid identity as "<vendor_type>"
    And provider delivery control is set to "<provider_control_owners>" in the OWNERS file
    And an error-free chart tarball used in "<chart_path>" and report in "<report_path>"
    And provider delivery control is set to "<provider_control_report>" in the report
    When the user sends a pull request with the report
    Then the pull request is not merged
    And user gets the "<message>" in the pull request comment

    @partners @full
    Examples:
      | vendor_type  | vendor    | chart_path                  | report_path               | provider_control_owners | provider_control_report | message                                                                                              |
      | partners     | hashicorp | tests/data/vault-0.17.0.tgz | tests/data/report.yaml    | true                    | true                    | OWNERS file and/or report indicate provider controlled delivery but pull request is not report only. |

  @external-feedback
  Scenario Outline: [HC-06-003] A partner associate submits an error-free report with inconsistent provider controlled delivery setting
    Given the vendor "<vendor>" has a valid identity as "<vendor_type>"
    And provider delivery control is set to "<provider_control_owners>" in the OWNERS file
    And a "<report_path>" is provided
    And provider delivery controls is set to "<provider_control_report>" and a package digest is "<package_digest_set>" in the report
    When the user sends a pull request with the report
    Then the pull request is not merged
    And user gets the "<message>" in the pull request comment

    @partners @full
    Examples:
      | vendor_type  | vendor    | report_path               | provider_control_owners | provider_control_report | package_digest_set | message                                                                 |
      | partners     | hashicorp | tests/data/report.yaml    | true                    | false                   | true               | OWNERS file indicates provider controlled delivery but report does not. |
      | partners     | hashicorp | tests/data/report.yaml    | false                   | true                    | true               | Report indicates provider controlled delivery but OWNERS file does not. |
      | partners     | hashicorp | tests/data/report.yaml    | true                    | true                    | false              | Provider delivery control requires a package digest in the report.      |
