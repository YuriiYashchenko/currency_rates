# include: "//easy_changer/views/exchange_rates.view"
include: "/views/exchange_rates.view"
include: "/views/sales.view"

explore: sales {
  join: exchange_rates {
    sql_on: ${sales.date_part_date} = ${exchange_rates.date}
        and ${sales.base_currency_code} = ${exchange_rates.cur_from_code}
    ;;
    relationship: many_to_one
    fields: [exchange_rate, base_currency]
  }
}
