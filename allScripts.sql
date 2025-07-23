					-- Numerical queries
-- Number of actors
select count(*) "Number of actors" from actor; -- Output = > 200

-- Number of films
select count(*) "Number of films" from film; -- Output = > 1000

-- Number of customer
select count(*) "Number of customer" from customer; -- Output = > 600

-- Number of staff
select count(*) "Number of staff" from staff; -- Output = > 2

-- Number of languages
select count(*) "Number of languages" from language; -- Output = > 6

-- Number of categories
select count(*) "Number of categories" from category; -- Output = > 16

-- Number of stores
select count(*) "Number of stores" from store; -- Output = > 2

-- Number of inventories
select count(*) "Number of inventories" from inventory; -- Output = > 4581

-- Number of rentals
select count(*) "Number of rentals" from rental; -- Output = > 16044

-- Number of countries
select count(*) "Number of countries" from country; -- Output = > 109

-- Number of cities
select count(*) "Number of cities" from city; -- Output = > 600

-- Number of addresses
select count(*) "Number of addresses" from address; -- Output = > 603

-- Number of payments
select count(*) "Number of payments" from payment; -- Output = > 16044

					-- Numerical queries with aggregation
                    
-- Number of films per actor and all films name per actor
select actor.*, group_concat(distinct title order by release_year asc separator " \\ ") "ALL Films Name", count(distinct film_id) "Number of films per actor"  from actor inner join film_actor using(actor_id) inner join film using(film_id) group by actor_id;

-- Number of actor per films and all actors name per film
select film.*, group_concat(distinct concat_ws(" ", first_name, last_name) order by first_name asc separator " \\ ") "ALL Actors Name", count(distinct actor_id) "Number of actors per film"  from film inner join film_actor using(film_id) inner join actor using(actor_id) group by film_id;

-- Number of categories per film and all categories name per film
select film.*, group_concat(distinct name order by name asc separator " \\ ") "ALL Category Name", count(distinct category_id) "Number of categories per film"  from film inner join film_category using(film_id) inner join category using(category_id) group by film_id;

-- Number of films per category
select category.name, count(*) "Number of films" from category inner join film_category using(category_id) inner join film using(film_id) group by category.name with rollup;

-- Number of films per language
select language.name, count(*) "Number of films" from language inner join film using(language_id) group by language.name;

-- Number of inventories per film
select film.title, count(*) "Number of inventories" from film inner join inventory using(film_id) group by film.title with rollup;

-- Number of rentals per film
select film.title, count(*) "Number of rentals per film" from film inner join inventory using(film_id) inner join rental using(inventory_id) group by film.title with rollup;

-- Number of rentals per inventory of per film
select film.title, inventory.inventory_id, count(*) "Number of rentals per inventory of per film" from film inner join inventory using(film_id) inner join rental using(inventory_id) group by film.title, inventory.inventory_id;

-- Number of rentals per customer
select customer.*, count(*) "Number of rentals per customer" from customer inner join rental using(customer_id) group by customer.customer_id;

-- Number of rentals per staff
select staff.*, count(*) "Number of rentals per staff" from staff inner join rental using(staff_id) group by staff.staff_id;

-- Number of payments per customer
select customer.*, count(*) "Number of payments per customer" from customer inner join payment using(customer_id) group by customer.customer_id;

-- Number of payments per staff
select staff.*, count(*) "Number of payments per staff" from staff inner join payment using(staff_id) group by staff.staff_id;

-- Number of cities per country
select country, group_concat(city separator " / ") "All City", count(*) "Number of cities per country" from country inner join city using(country_id) group by country;

-- Number of addresses per country
select city, count(*) "Number of addresses per country" from city inner join address using(city_id) group by city;

-- Number of inventories per store
select store_id, count(*) "Number of inventories per store" from store inner join inventory using(store_id) group by store.store_id with rollup;

-- Number of inventories per film of per store
select store_id, film.title, group_concat(inventory_id order by inventory_id asc separator " , "), count(*) "Number of inventories per film of per store" from store inner join inventory using(store_id) inner join film using(film_id) group by store_id, film.title order by film.title;

-- Number of films per rental_duration 
select concat_ws(" " ,rental_duration, "Days") "rental_duration", count(*) "Number of films per rental_duration" from film group by rental_duration with rollup order by count(*);

-- Number of customers per store 
select store.*, count(*) "Number of customers per store" from store inner join customer using(store_id) group by store_id;

-- Number of customers & staffs & stores per addresses
select address.*, count(distinct customer_id) "Number of customers per addresses", count(distinct staff_id) "Number of staffs per addresses", count(distinct store.store_id) "Number of stores per addresses" from address left join customer using(address_id) left join staff using(address_id) left join store using(address_id) group by address_id;

-- Number of rental per rental_date
select date_format(rental_date, "%Y-%m-%d 00:00:00"), count(*) "Number of rental per rental_date" from rental group by date_format(rental_date, "%Y-%m-%d 00:00:00") with rollup;
-- OR
select date(rental_date), count(*) "Number of rental per rental_date" from rental group by date(rental_date) with rollup;

-- Number of customers for activity
select active, count(*) from customer group by active;

-- Specify the film rental period and match it with the actual rental period
select film.film_id, film.title, inventory.inventory_id, film.rental_duration, datediff(return_date, rental_date) "Rental period", if(datediff(return_date, rental_date) <= rental_duration, "Returned in the same period", "Not returned in the same period") "Replay time" from film left join inventory using(film_id) left join rental using(inventory_id);


-- ******* testing ******
select * from category;
select * from film;
select datediff(return_date, rental_date) from rental;
select * from rental;
select customer_id, address_id from customer where address_id = 1 union  select store_id, address_id from store where address_id = 1;

SELECT 
  SUM(FIND_IN_SET('Trailers', special_features) > 0) AS Trailers,
  SUM(FIND_IN_SET('Commentaries', special_features) > 0) AS Commentaries,
  SUM(FIND_IN_SET('Deleted Scenes', special_features) > 0) AS Deleted_Scenes,
  SUM(FIND_IN_SET('Behind the Scenes', special_features) > 0) AS Behind_the_Scenes
FROM film;
SELECT film_id, title, special_features
FROM film
WHERE LENGTH(special_features) - LENGTH(REPLACE(special_features, ',', '')) >= 1 and special_features like "%Trailers%";
select special_features, count(*) from film where special_features like "%Trailers%" group by special_features with rollup;
SHOW COLUMNS FROM film LIKE 'special_features';
SHOW COLUMNS FROM film LIKE 'rating';
select distinct rental_duration from film order by rental_duration;
select * from film;
show create table film;

select * from city inner join address using(city_id) where city = "Aurora";
