view: exchange_rates {
  label: "Exchange to Base Currency"
  sql_table_name: bi-twr.exchange_rates_US.rates ;;

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
}
