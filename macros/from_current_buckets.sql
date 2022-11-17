{% macro from_current_buckets(year, month, day, hour, minute="00", second="00") %}
    to_timestamp( concat_ws(' ', concat_ws('-', lpad({{year}}, 4, '0'), lpad({{month}}, 2, '0'), lpad({{day}}, 2, '0')), concat_ws(':', lpad({{hour}}, 2, '0'), lpad({{minute}}, 2, '0'), lpad({{second}}, 2, '0'))), 'yyyy-MM-dd HH:mm:ss') >= to_timestamp(date_sub(current_timestamp() , {{ var("INCREMENTAL_DAYS") }}))
{% endmacro %}
