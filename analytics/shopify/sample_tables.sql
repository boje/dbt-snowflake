{%- for i in range(1, 10) %}

  drop schema if exists raw.shopify_account_{{ i }};

{%- endfor %}

{%- for i in range(1, 10) %}
  
  create schema raw.shopify_account_{{ i }};

  create table raw.shopify_account_{{ i }}.orders (
    id int,
    browser_ip string,
    currency string,
    email string,
    name string,
    note string,
    order_number int
  );

  create table raw.shopify_account_{{ i }}.location (
    id int,
    order_id int,
    address1 string,
    city string, 
    country string
  );

  insert into raw.shopify_account_{{ i }}.orders
  select 
      concat({{ i }}{{ i }}{{ i }}, left(abs(random()),3)) id,
      '198.168.0.1' browser_ip, 
      'DKK' currency, 
      'test@gmail.com' email, 
      'Anders' name, 
      '' noge, 
      left(abs(random()),5) order_number
  from table(generator(rowcount => {{ i }}));

  insert into raw.shopify_account_{{ i }}.location
  select 
      concat({{ i }}{{ i }}{{ i }}, left(abs(random()),3)) id,
      left(abs(random()),3) order_id,
      'Example' address1, 
      'Brøndby' city, 
      'Denmark' name
  from table(generator(rowcount => {{ i }}));
  
{%- endfor %}