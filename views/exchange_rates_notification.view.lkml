include: "sales.view"

view: exchange_rates_notification {
  label: "Exchange Rates Notification"
  derived_table: {
    sql:
    SELECT
      CASE
        -- Empty Notification
        WHEN COUNT(BaseCurrencyCode) = 0 or -- There are no any currencies entered for company
             COUNT(DISTINCT BaseCurrencyCode) = 1  -- only 1 currency (Ex: US companies)
        THEN ""

        -- Only open source data notification
        ELSE CONCAT("Exchange Rates for ", CAST(COUNT(DISTINCT BaseCurrencyCode) AS STRING),
          " currencies were used from https://openexchangerates.org/")

      END AS Message
      FROM

      `twc-bi-education.LH.sales` t
    WHERE (Date_Part >= CAST(COALESCE({% date_start date_filter %}, CAST("1990-01-01" AS TIMESTAMP)) AS DATE)
      AND Date_Part <= CAST(COALESCE({% date_end   date_filter %}, CAST("2099-01-01" AS TIMESTAMP)) AS DATE))
      AND {% condition location_filter %} LocationCode {% endcondition %}
    ;;
  }

  filter: date_filter {
    label: "Gregorian Date Filter"
    type: date
  }

  filter: location_filter {
    label: "Location Filter"
    type: string
    suggest_explore: sales
    suggest_dimension: sales.location_code
  }

  dimension: message {
    type: string
    sql: ${TABLE}.Message ;;
  }

}
