{{ config(
    unique_key='party_key',
    update_hudi_ts='created_date',
    partition_by=['year','month','day'],
    merge_update_columns = ['given_name', 'last_name', 'middle_name', 'date_of_birth', 'date_of_death', 'gender', 'place_of_birth', 'country_of_residence', 'created_date', 'updated_date'],
    custom_location=var('AWS_REFINED_BUCKET') + '/customer_test',
    )
}}

WITH raw_event AS (
    SELECT *
    FROM {{ source( 'raw', 'customer' ) }}
        {%- if is_incremental() %}
    WHERE
        {{ from_current_buckets('year', 'month', 'day', 'hour') }}
       {%- endif -%}),

    source AS (
        SELECT
            year,
            month,
            day,
            hour,
            party_key,
            given_name,
            last_name,
            middle_name,
            date_of_birth,
            date_of_death,
            gender,
            place_of_birth,
            country_of_residence,
            created_date,
            updated_date
        FROM raw_event
    ),

    ordered AS (
        SELECT
            *,
            row_number() OVER (PARTITION BY party_key ORDER BY created_date DESC) AS rn
        FROM source
    )

SELECT *
FROM ordered
WHERE rn = 1
