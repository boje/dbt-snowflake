with customers as (

    {{ dynamic_union_tables() }}

),

final as (

    select
        *
    from customers


)

select * from final