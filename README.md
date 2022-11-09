# Black Thursday Project

* Ryan Canton
* Kerynn Davis
* Brian Hayes
* Max MacGillivray


### Submission Questions

1. What was the most challenging aspect of this project?

* The communication in the beginning was a challenge. Figuring out where to start, and how to split up the work when we all had varying preferences. This definitely improved as we moved forward with the project, but got us off to a slower start.

2. What was the most exciting aspect of this project?

* When we were able to resolve a method as a team. If someone was stuck on a method for a long time, we would get together as a group to try and solve it together. When we finally would crack it, it felt like a huge team win.

3. Describe the best choice enumerables you used in your project. Please include file names and line numbers.

* Find_all was a dear friend for this project..
* Sum was helpful for finding invoice and revenue totals in the Sales Analyst file.
invoice_total: lines 173-178
total_revenue_by_date method: lines 198-203
Definitely kept these methods shorter and easier to read since we did not have to use multiple lines if we had used the .each method for example.

4. Tell us about a module or superclass which helped you re-use code across repository classes. Why did you choose to use a superclass and/or a module?

* We originally created a module for the repository classes, but changed it to a super class at the request of our instructor. The superclass Repository is inherited by all classes containing the word Repository at the end, and handles the methods find_by_id, find_by_name, all_ids, and delete. This cleans up our code as every repository was using these methods (spare find_by_name, some repositories didn’t have this). This superclass was a very helpful tool for sure.

5. Tell us about 1) a unit test and 2) an integration test that you are particularly proud of. Please include file name(s) and line number(s).

* Unit Test- The unit tests that we are most proud of is for the methods update time in classes invoice, customer, item, merchant, and transaction. We are most proud of this test because we found an interesting way to compare if the time updated_at has been updated. We were able to compare that class.updated_at was < than class.update_time.  

* Integration Test-  One of the integration tests we are most proud of is the test for the merchants_with_only_one_item_registered_in_month method. We are most proud of this test because we were able to pass in a string of the month name and compare it to the equivalent month number in the method, which needs the month number to make the method work.

6. Is there anything else you would like instructors to know?

* Definitely learned a lot about pull requests and merges while working on this group project. At one point we pulled down without merging in GitHub first, and it caused all sorts of issues. Moving forward, we knew to always push up to GitHub, merge, then pull down. Even when we were in the middle of solving a method, it was better to push up and merge everything, and then continue working on the method.

### Blog Post

* Method # 7: sales_analyst.most_sold_item_for_merchant(merchant_id)

The first thing to locate for this method is the merchant ids located in the invoices. We used our find_all_by_merchant_id to set our merchant_invoices variable to those ids. Once we found all our merchants, the next question is which of these merchants have invoices that were paid in total. We already have a method that does this, so we use the find_all method to iterate through each invoice and return those to our merchant_succesful_invoices variable.

We then set a new variable- merchant_invoice_items- which would then search through all of our found successful merchant invoices and search to find by the item id. We used the map method here to iterate through the merchant invoices pulling out the invoice items that have the same invoice id. We want to store these in a new array because we need to be able to check the quantity. Invoice items hold the quantity, so had to work our way from the merchant with the successful invoices, and then to the merchant’s successful invoice items. We can then set these to our merchant_invoice_items variable.

Once we have the corresponding item, we then pull out the item that has the maximum quantity. We used the max_by enumerable to loop through all of the items that have been paid in full, and pull out the invoice item that has the highest quantity. Once we have that we set that as our max quantity invoice item.

Next we need to make sure if there are other invoice items that have the same quantity. We will again go through all of the invoice items for the merchant that has the same quantity of the invoice item that we just stored.

Finally once those are stored, we now have all of our max quantity items that have a successful paid invoice. We don’t want the invoice item however, we want the item itself. So for our last variable we want to loop through the array of invoice items with the max quantity and pull out the item (or items if tied) by using find_by_id and getting our invoice item by the id.

* Method # 8: sales_analyst.best_item_for_merchant(merchant_id) #=> item (in terms of revenue generated)

This method was able to utilize and build off a lot of work from the previous method for finding the most sold item by a merchant. The initial set up is the same, where we need to first look through all the invoices to find the merchant ids. From there, we want to look through each of those merchant invoices and find the invoices that were paid in full. If we do not find the invoices that were successfully paid, the revenue is not generated which is critical for finding the best item.

The third line of this method had to account for if a merchant had zero successful invoices. If so, this would return nil which would end up breaking the code later on in the method. If we try to call the map method on merchant_successful_invoices, but have nil, we will get an error for ‘undefined method for nil class’. The if conditional will make sure to only return merchants to have at least one successful invoice.

Where this method deviates from the most sold item method is that we do not want the items to end in a tie. We want the single item that has the greatest quantity sold. For this, we called on our previous method for invoice total. Whichever invoice item has the highest total revenue, we  can take that invoice item to return the best item for the merchant.

I think if we had more time for refactoring at the end of this project, both these methods could be pulled apart into smaller helper methods- where potentially each line is its own method.

### Individual Questions

* Brian: Are methods that contain hashes with over 7 lines of key value pairs considered too long?

* Kerynn: Is there a general way to know when to create a module over a superclass?

* Max: Why does adding a let block the beginning of the test block seem to slow the testing duration much?

* Ryan: Our top_revenue_earners(x) method has many nested method calls and iterations, causing it to take very long to run. What is a possible refactor that could decrease the run time?
