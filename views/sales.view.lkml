view: sales {
  sql_table_name: `twc-bi-education.LH.sales`
    ;;

  dimension: base_currency_code {
    label: "Location Currency Code"
    type: string
    sql: ${TABLE}.BaseCurrencyCode ;;
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

  dimension: location_code {
    type: string
    sql: ${TABLE}.LocationCode ;;
  }

  measure: net_sales_amt {
    type: sum
    sql: ${TABLE}.NetSalesAmt ;;
  }

  dimension: plu {
    type: number
    sql: ${TABLE}.Plu ;;
  }

  measure: qty {
    type: sum
    sql: ${TABLE}.Qty ;;
  }

  dimension: receipt_no {
    type: number
    sql: ${TABLE}.ReceiptNo ;;
  }

  measure: receipt_total_qty {
    type: sum_distinct
    sql_distinct_key: ${document_id} ;;
    sql: ${TABLE}.ReceiptTotalQty ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
