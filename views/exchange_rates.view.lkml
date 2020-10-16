view: exchange_rates {
  label: "Exchange to Base Currency"
  derived_table: {
    sql: select
          Date,
          cur_from_code,
          cur_to_code,
          rate
        from `bi-twr.exchange_rates_US.rates`
        where cur_to_code = {% parameter base_currency %}

        UNION ALL

        select
          Date,
          {% parameter base_currency %},
          {% parameter base_currency %},
          1
        from `bi-twr.exchange_rates_US.rates`
        group by 1,2,3,4
        ;;
  }

  dimension: date {
    label: "Date"
    description: "Gregorian Date"
    type: date
    sql: cast(${TABLE}.Date as timestamp) ;;
  }

  dimension: cur_from_code {
    label: "Local Currency Code"
    description: "Currency code of location"
    type: string
    sql: ${TABLE}.cur_from_code ;;
  }

  dimension: cur_to_code {
    label: "Base Currency Code"
    description: "Company base currency code"
    type: string
    sql: ${TABLE}.cur_to_code ;;
  }

  dimension: exchange_rate {
    label: "Exchange Rate"
    description: "Exchange rate from local currency to base currency"
    type: number
    sql: ${TABLE}.rate ;;
  }

  parameter: base_currency {
    label: "Convert to"
    type: string
    allowed_value: {
      label: "US Dollars"
      value: "USD"
    }
    allowed_value: {
      label: "EURO"
      value: "EUR"
    }
    allowed_value: {
      label: "Swedish krona"
      value: "SEK"
    }
    allowed_value: {
      label: "Japanese yen"
      value: "JPY"
    }
    default_value: "USD"
  }
}
