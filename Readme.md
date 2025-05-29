# QoQ Performance Tests

Here are the tests I used to produce the data detailed in the this blog post:

https://www.codersrevolution.com/blog/boxlangs-qoq-is-here-and-its-5x-faster-than-lucee-17x-faster-than-adobe

Your mileage may vary, but as a general rule, I would expect BoxLang and Lucee to perform better on machines with more CPU cores since they both uses a threaded approach.  So far as I know, Adobe CF is single threaded.

## Start the servers

In CommandBox, fire up each server:
```bash
server start server-qoqperftestsadobe.json
server start server-qoqperftestsboxlang.json
server start server-qoqperftestslucee.json
```

## Run the tests

There are two test files in this repo, both linked from the index page.

### `test.cfm`

This sets up an in-memory query object with 1 million rows (and a couple small tables for joins).  Then it runs a series of various QoQs.  Each QoQ is ran 3 times, with the time of the last run recorded to allow evrythign to "warm up".  The time taken to create the query object in memory is not included in the test times.  The query objects will be cached in memory between page loads.  

There is one query joining 3 tables which does not work on ACF and another query using ANSI join syntax which does not work on Lucee or ACF.  

### `test2.cfm`

This runs the same basic QoQ select over an ever-increasing in-memory query, starting at 20 rows and growing exponentitally to around 1 million rows.  This shows how the performance of each engine degrades as the size of the queries increase.

## What do the results mean?

The results are discussed in detail in the blog post above.  Hit me up if you have any questions or suggestions for the test suite.  I tried to be fair with a compilation of different types of queries, and MOSTLY sticking to syntax supported by all 3 engines (with those 2 exceptions noted above).