project_name: "currency_rates"

remote_dependency: easy_changer {
  url: "https://github.com/YuriiYashchenko/easy_changer"
  ref: "master"
}

constant: currency_format {
  value: "
  <a href=\"#drillmenu\" target=\"_self\">
  {% if value >=0 %}
  {{ currency_symbol._value }}{{ rendered_value }}
  {% else %}
  ({{ currency_symbol._value }}{{ rendered_value | remove_first: \"-\" }})
  {% endif %}
  </a>
  "
}

constant: base_currency_format {
  value: "
  <a href=\"#drillmenu\" target=\"_self\">
  {% if value >=0 %}
  {{ base_currency_symbol._value }}{{ rendered_value }}
  {% else %}
  ({{ base_currency_symbol._value }}{{ rendered_value | remove_first: \"-\" }})
  {% endif %}
  </a>
  "
}
