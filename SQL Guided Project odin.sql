use odinlibrary;
-- Problem 1: Comprehensive Library Report

-- 1. Books Not Loaned Out in the Last 6 Months
select  title,firstName,lastName,loandate  from books left join authors
on books.authorid=authors.authorid
left join loans on books.bookid=loans.bookid
where loandate<=date_sub(curdate(), interval 6 month);




-- 2. Top Members by Number of Books Borrowed in the Last Year
select members.memberid,firstName,lastName,count(*) as no_of_books  from members
inner join loans on loans.memberid=members.memberid
where loandate>= date_sub(curdate(),interval 1 year)
group by loans.memberid
order by no_of_books desc
limit 10;

-- 3. Overdue Books Report
select memberid,books.bookid,datediff(curdate(),duedate) as no_of_days from books
inner join loans
on loans.bookid=books.bookid
where duedate < curdate() and returndate is null;


-- 4. Top 3 Most Borrowed Categories
select categoryname,count(*)  as no_of_books from categories inner join bookcategories
on categories.categoryid=bookcategories.categoryid left join loans
on loans.bookid=bookcategories.bookid
group by categoryname
order by no_of_books desc
limit 3;

-- 5. Are there any books Belonging to Multiple Categories
select books.title,books.bookid ,count(books.bookid) as category_of_books  from books
inner join bookcategories
on books.bookid=bookcategories.bookid
inner join categories on categories.categoryid=bookcategories.categoryid
group by books.title,books.bookid;
-- report the book categories doesn't contain all books
-- having category_of_books >1

-- Problem 2: Advanced Library Data Analysis
-- 6. Average Number of Days Books Are Kept
select avg(datediff(loans.returndate,loans.loandate))as avg_no_days
from books left join loans on books.bookid=loans.bookid
where loans.returndate is not null;


-- 8. Percentage of Books Loaned Out per Category
select categoryname,count(loans.bookid)/count( bookcategories.bookid)*100 as percentage
from categories inner join bookcategories on bookcategories.categoryid=categories.categoryid
left join loans on loans.bookid=bookcategories.bookid
and returndate is null
group by bookcategories.categoryid;

-- 9. Total Number of Loans and Reservations Per Member --correct

select members.memberid,firstname,lastname,count(loanid) as no_of_loans,count(reservationid) as no_of_reservations
from members left join reservations
on members.memberid=reservations.memberid
join loans on loans.memberid=members.memberid
group by members.memberid,firstname,lastname;


-- 10. Find Members Who Borrowed Books by the Same Author More Than Once ---correct
select members.firstname,members.lastname,authors.firstname as author_first_name ,authors.lastname as author_last_name,count(*) as no_of_times
from members join loans on members.memberid=loans.memberid
join books on books.bookid=loans.bookid
join authors on authors.authorid=books.authorid
group by members.memberid,authors.authorid
having no_of_times>1;



-- 11. List Members Who Have Both Borrowed and Reserved the Same Book --correct

select members.memberid,members.firstname as mem_first_name,members.lastname as mem_last_name,books.bookid,title
from members left join loans on members.memberid=loans.memberid
left join reservations on reservations.memberid=loans.memberid 
join books on books.bookid=loans.bookid and books.bookid = reservations.bookid;




-- 12. Books Loaned and Never Returned --correct
select books.title,members.firstname as mem_first_name,members.lastname as mem_last_name from loans
left join books on books.bookid=loans.bookid
left join members on loans.memberid=members.memberid
where loans.returndate is null;


-- 13. Top 5 Authors with the Most Borrowed Books --correct
select authors.authorid,authors.firstname as author_name,count(loans.loanid) as no_of_times_borrowed
from authors join books
on authors.authorid=books.authorid
join loans on loans.bookid = books.bookid
group by authors.authorid,author_name
order by no_of_times_borrowed desc
limit 5;


-- 14. Books Borrowed by Members Who Joined in the Last 6 Months
select books.title,loans.memberid,loandate,members.firstname as member_name,membershipstartdate from books
inner join loans on loans.bookid=books.bookid
join members on loans.memberid=members.memberid
where membershipstartdate>=date_sub(curdate(), interval 6 month);



















