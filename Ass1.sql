#initializing the db
use sakila;
# 1a
select first_name, last_name from actor;
#1b
Alter table actor add `Actor Name` varchar(50);
update actor set `Actor Name` = concat(first_name, " ", last_name);

#2a
select actor_id, first_name, last_name from actor where first_name = 'Joe';
#2b
select * from actor where last_name like '%GEN%';
#2c
select * from actor where last_name like '%LI%' group by last_name, first_name;
#2d
select * from country where country in ('Afghanistan','Bangladesh','China');

#3a
Alter table actor add Description blob;
#3b
Alter table actor drop column Description;

#4a
select distinct last_name, count(*) as 'Actors with same lastname'from actor group by last_name;
#4b
select last_name, first_name, count(*) from actor group by last_name 
having count(*) >=2;
#4c
select * from actor where first_name = 'GROUCHO' and last_name='WILLIAMS';
update actor set first_name='GROUCHO',`Actor Name` = 'HARPO WILLIAMS' where first_name = 'HARPO' and last_name='WILLIAMS';
rollback;
#4d
update actor set first_name='GROUCHO',`Actor Name` = 'GROUCHO WILLIAMS' where first_name = 'HARPO' and last_name='WILLIAMS';

#5a
#show create table address
/* CREATE TABLE `address` (
   `address_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
   `address` varchar(50) NOT NULL,
   `address2` varchar(50) DEFAULT NULL,
   `district` varchar(20) NOT NULL,
   `city_id` smallint(5) unsigned NOT NULL,
   `postal_code` varchar(10) DEFAULT NULL,
   `phone` varchar(20) NOT NULL,
   `location` geometry NOT NULL,
   `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
   PRIMARY KEY (`address_id`),
   KEY `idx_fk_city_id` (`city_id`),
   SPATIAL KEY `idx_location` (`location`),
   CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) ON UPDATE CASCADE
 ) ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8
*/
#6a
select * from staff;
select * from address;
select s.first_name, s.last_name, a.address from staff s
join address a on s.staff_id= a.address_id;
#6b
select * from payment where payment_date like '%2005-08%';
select sum(p.amount), s.first_name, s.last_name, p.payment_date 
	from staff s inner join payment p on s.staff_id= p.staff_id 
    where p.payment_date like '%2005-08%'
    group by first_name;
#6c
select * from film;
select * from actor;
select f.title, count(a.`Actor Name`) as 'Number of Actors' from film f
inner join actor a on f.film_id= a.actor_id group by title;
#6d
select * from inventory;
select * from film where title='Hunchback Impossible';
select count(inventory_id) as 'No of Films in Inventory' 
	from inventory where( select film_id from film where title='Hunchback Impossible');
#6e
select * from payment;
select * from customer;
select c.first_name, c.last_name, sum(p.amount) as 'Total Amount Paid' from payment p
	left join customer c on c.customer_id=p.customer_id
    group by last_name asc having sum(p.amount);

#7a
select language_id from language where language_id=1;
select title from film where ( title like 'K%' or title like 'Q%') and
			(select language_id from language where language_id=1);


#7b
select * from film where title='Alone Trip';
select * from actor where actor_id=17;
select count(`Actor Name`) from actor;
select (select (`Actor Name`) from actor where actor_id=17) from film where title='Alone Trip';

 
#7c
select c.email, c.first_name, c.last_name, cy.country from country cy
	 Join customer c on c.customer_id=cy.country_id
     group by first_name having country= 'Canada';
#7d
-- select film_id, title, description, rating from film where rating= 'G';
select f.film_id as 'film id', f.title as 'film title', a.name as 'film category', a.category_id as 'Family Category ID'
from film f
	inner join film_category c on f.film_id = c.film_id
    inner join category a on a.category_id = c.category_id
    where a.name ='Family';
#7e
select title, count(rental_id) as "Rental Count" from rental 
	inner join inventory on (rental.inventory_id = inventory.inventory_id)
	inner join film on (inventory.film_id = film.film_id)
	group by film.title
	order by count(rental_id) DESC;
#7f
SELECT staff.store_id AS 'Store', (SELECT SUM(payment.amount) FROM payment WHERE payment.staff_id = staff.staff_id) AS 'Total Sales Per Store'
FROM staff
GROUP BY staff.store_id;
#7g
select * from store;
select * from city;
select * from address;
select * from country;

select st.store_id, ct.city, cy.country from city ct
inner join country cy on ct.country_id = cy.country_id
inner join address ad on ct.city_id = ad.city_id
inner join store st on ad.city_id = st.address_id
group by st.store_id;

#7h
select name, sum(amount) from category 
	inner join film_category on category.category_id = film_category.category_id
	inner join inventory on film_category.film_id = inventory.film_id
	inner join rental on inventory.inventory_id = rental.inventory_id
JOIN payment
ON rental.rental_id = payment.rental_id
GROUP BY name
ORDER BY SUM(amount) DESC LIMIT 5;

#8a
create view top5_genres_by_GrossRev AS
select name, sum(amount) from category 
	inner join film_category on category.category_id = film_category.category_id
	inner join inventory on film_category.film_id = inventory.film_id
	inner join rental on inventory.inventory_id = rental.inventory_id
	inner join payment on rental.rental_id = payment.rental_id
group by name
order by sum(amount) desc limit 5;

#8b
SELECT * FROM top5_genres_by_grossrev;

#8c.
DROP VIEW top5_genres_by_grossrev;





