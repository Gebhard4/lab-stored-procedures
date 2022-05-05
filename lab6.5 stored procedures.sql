use sakila;

#1)In the previous lab we wrote a query to find first name, last name, and emails of all the customers who rented 

DELIMITER //
create procedure Action_renters(out param1 int) -- in x int, 
begin
  select first_name, last_name, email
  from customer
  join rental on customer.customer_id = rental.customer_id
  join inventory on rental.inventory_id = inventory.inventory_id
  join film on film.film_id = inventory.film_id
  join film_category on film_category.film_id = film.film_id
  join category on category.category_id = film_category.category_id
  where category.name = "Action"
  group by first_name, last_name, email;
end //
DELIMITER ;

call Action_renters(@_variable_name);
select @_variable_name; #doesn't work?

#2)Now keep working on the previous stored procedure to make it more dynamic. Update the stored procedure 
#in a such manner that it can take a string argument for the category name and return the results for all customers 
#that rented movie of that category/genre. For eg., it could be action, animation, children, classics, etc.

DELIMITER //
create procedure Nani_renters(in cat char(10)) -- in x int, 
begin
  select first_name, last_name, email
  from customer
  join rental on customer.customer_id = rental.customer_id
  join inventory on rental.inventory_id = inventory.inventory_id
  join film on film.film_id = inventory.film_id
  join film_category on film_category.film_id = film.film_id
  join category on category.category_id = film_category.category_id
  where category.name = cat
  group by first_name, last_name, email;
end //
DELIMITER ;

call Nani_renters("animation");
call Nani_renters("children");
call Nani_renters("classics");

#3)Write a query to check the number of movies released in each movie category. Convert the query in to a stored procedure 
#to filter only those categories that have movies released greater than a certain number. Pass that number as an argument 
#in the stored procedure.

DELIMITER //
CREATE PROCEDURE movies_cat (IN param VARCHAR(20), OUT param2 INT)
BEGIN
	SELECT * 
    FROM 
    (SELECT c.name AS category, COUNT(fc.film_id) AS movies
	FROM film_category fc
	JOIN category c
	ON fc.category_id = c.category_id
	GROUP BY c.name) AS movie_table
	WHERE movies > param;
END;
  // 
DELIMITER ;

CALL movies_cat(2000, @movies);