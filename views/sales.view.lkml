view: sales {
  sql_table_name: `twc-bi-education.LH.sales`
    ;;

# --- DIMENSIONS ---

  dimension: base_currency_code {
    label: "Location Currency Code"
    type: string
    sql: ${TABLE}.BaseCurrencyCode ;;
  }

  dimension: currency_symbol {
    type: string
    sql:
        case ${base_currency_code}
          when 'EUR' then '€'
          when 'USD' then '$'
          when 'DKK' then 'kr'
          when 'AUD' then '$'
          when 'GBP' then '£'
          when 'NOK' then 'kr'
          when 'JPY' then '¥'
          when 'CAD' then '$'
          when 'HKD' then '元'
          when 'KRW' then '₩'
          when 'CNY' then '¥'
          when 'SEK' then 'kr'
          when 'MXN' then '$'
          when 'BRL' then 'R$'
          when 'AED' then 'د.إ'
          when 'KWD' then 'د.ك'
          when 'SAR' then '﷼'
          else '$' --for US servers where currencies are not set up
        end
    ;;
    hidden: yes
  }

  dimension: base_currency_symbol {
    type: string
    sql:
        case ${exchange_rates.cur_to_code}
          when 'EUR' then '€'
          when 'USD' then '$'
          when 'DKK' then 'kr'
          when 'AUD' then '$'
          when 'GBP' then '£'
          when 'NOK' then 'kr'
          when 'JPY' then '¥'
          when 'CAD' then '$'
          when 'HKD' then '元'
          when 'KRW' then '₩'
          when 'CNY' then '¥'
          when 'SEK' then 'kr'
          when 'MXN' then '$'
          when 'BRL' then 'R$'
          when 'AED' then 'د.إ'
          when 'KWD' then 'د.ك'
          when 'SAR' then '﷼'
          else '$' --for US servers where currencies are not set up
        end
    ;;
    hidden: yes
  }

  dimension: cogs {
    type: number
    sql: ${TABLE}.COGS ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.Created ;;
    hidden: yes
  }

  dimension: customer_id {
    type: number
    sql: ${TABLE}.CustomerId ;;
  }

  dimension_group: date_part {
    type: time
    convert_tz: no
    datatype: date
    timeframes: [date]
    sql: ${TABLE}.Date_Part ;;
  }

  dimension: document_id {
    type: string
    sql: ${TABLE}.DocumentId ;;
  }

  dimension: document_line_id {
    type: string
    sql: ${TABLE}.DocumentLineId ;;
  }

  dimension: receipt_no {
    type: number
    sql: ${TABLE}.ReceiptNo ;;
  }

  dimension: location_code {
    type: string
    sql: ${TABLE}.LocationCode ;;
  }

  dimension: plu {
    type: number
    sql: ${TABLE}.Plu ;;
  }

  set: details_1 {
    fields: [
      date_part_date,

      receipt_no,
      plu,
      location_code,

    ]
  }

  # --- MEASURES ---

  measure: num_items {
    label: "Qty of Items"
    type: sum
    description: "Summary of Items Quantity"
    value_format: "#,##0;(#,##0)"
    sql: ${TABLE}.Qty ;;
    drill_fields: [details_1*, num_items]
  }

  measure: num_receipts {
    label: "Qty of Unique Receipts"
    type: count_distinct
    description: "Number of Unique Receipts"
    value_format: "#,##0;(#,##0)"
    sql: ${TABLE}.DocumentId ;;
    drill_fields: [details_1*, num_receipts]
  }

  measure: receipt_total_qty {
    type: sum_distinct
    sql_distinct_key: ${document_id} ;;
    sql: ${TABLE}.ReceiptTotalQty ;;
  }

  measure: amt_cost {
    label: "Sum of Costs"
    description: "Sum of Cost of Goods (COGS)"
    type: sum
    value_format_name: decimal_2
    html: @{currency_format};;
    sql: ${TABLE}.COGS ;;
    drill_fields: [details_1*, amt_cost]
  }

  measure: amt_net_sales {
    label: "Sum of Net Sales"
    description: "Sum of Net Sales"
    type: sum
    value_format_name: decimal_2
    sql: ${TABLE}.NetSalesAmt ;;
    drill_fields: [details_1*, amt_net_sales]
    html: @{currency_format};;
  }

  measure: avg_transaction_value {
    label: "ATV"
    type: number
    description: "Average Transaction Value = Summary of Net Sales divided on number of Unique Receipts"
    value_format_name: decimal_2
    html: @{currency_format};;
    sql: safe_divide(${amt_net_sales},${num_receipts}) ;;
    drill_fields: [details_1*, amt_net_sales, num_receipts, avg_transaction_value]
  }

  measure: amt_cost_converted {
    label: "Sum of Costs Converted"
    description: "Sum of Cost of Goods (COGS)"
    # view_label: "Exchange to Base Currency"
    type: sum
    value_format_name: decimal_2
    sql: ${TABLE}.COGS * ${exchange_rates.exchange_rate} ;;
    html: @{base_currency_format};;
    drill_fields: [flat_sale_comparison.details_1*, flat_sale.details_1*, amt_cost_converted]
  }

  measure: amt_net_sales_converted {
    label: "Sum of Net Sales Converted"
    description: "Sum of Net Sales"
    # view_label: "Exchange to Base Currency"
    type: sum
    value_format_name: decimal_2
    sql: ${TABLE}.NetSalesAmt * ${exchange_rates.exchange_rate} ;;
    html: @{base_currency_format};;
    drill_fields: [flat_sale_comparison.details_1*, flat_sale.details_1*, amt_net_sales_converted]
  }

  measure: avg_transaction_value_converted {
    label: "ATV Converted"
    description: "Average Transaction Value = Summary of Net Sales divided on number of Unique Receipts"
    # view_label: "Exchange to Base Currency"
    type: number
    value_format_name: decimal_2
    sql: safe_divide(${amt_net_sales_converted},${num_receipts}) ;;
    html: @{base_currency_format};;
    drill_fields: [flat_sale_comparison.details_1*, flat_sale.details_1*, amt_net_sales_converted, num_receipts, avg_transaction_value_converted]
  }

}
