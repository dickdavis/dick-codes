---
layout: post
title:  "Managing activity in a Postgres database"
date:   2025-05-10
---

When applications reach a certain scale, the database quickly becomes a non-negotiable consideration. Strange issues start to appear when storing millions of records and processing thousands of transactions per second. This post offers a few quick pointers for addressing issues as they arise.

<!--more-->

{: .toc-container}

* TOC
{:toc}

## See what's running

Query the `pg_stat_activity` table to see what processes are running. The following query will show all currently executing processes along with their:
- identifier (pid)
- who's running them (usename)
- application name
- IP address
- the current state and wait events
- the actual query being executed
- the duration of the query
- how long it has been running

This query is my go-to when I need some insight as to what processes are taking a long time to run. Anything running longer that 5 minutes--aside from replication--is a sign that something is not working as expected. Most often, this could mean an inefficient or blocked query.

```sql
SELECT
  pid,
  usename,
  application_name,
  client_addr,
  backend_start,
  query_start,
  state,
  wait_event_type,
  wait_event,
  EXTRACT(EPOCH FROM (now() - query_start)) AS duration_seconds,
  query
FROM pg_stat_activity
WHERE state = 'active' AND query_start < now() - interval '5 minutes' ORDER BY query_start ASC;
```

## Identify blocking processes

Sometimes a query might take a long time to execute. This can happen for a myriad of reasons, especially when querying over large amounts of data. When a long-running query blocks other queries from executing, you'll start to see exceptions being raised in your applications due to timeouts.

If you suspect a long-running query is blocking other queries, run the following query to retrieve information about any blocking activities including:
* identifier of the blocked process
* who's running the blocked process
* identifier of the blocking process
* who's running the blocking process
* blocked query
* blocking query
* how long the blocked query has been waiting

Replace `<YOUR QUERY FRAGMENT>` with a portion of the query you suspect is blocked. For instance, if a `DROP` query is taking a long time to execute, you could use `%DROP%` as the value to search for in the `blocked_activity.query` column.

```sql
SELECT
  blocked_activity.pid AS blocked_pid,
  blocked_activity.usename AS blocked_user,
  blocking_activity.pid AS blocking_pid,
  blocking_activity.usename AS blocking_user,
  blocked_activity.query AS blocked_query,
  blocking_activity.query AS blocking_query,
  now() - blocked_activity.query_start AS blocked_duration
FROM pg_stat_activity blocked_activity
JOIN pg_stat_activity blocking_activity
  ON blocking_activity.pid = ANY(pg_blocking_pids(blocked_activity.pid))
WHERE blocked_activity.query LIKE '%<YOUR QUERY FRAGMENT>%';
```

## Stop a process

A blocking process can cause errors if it runs for an extended period. You can use `pg_cancel_backend` to gracefully cancel a process, or `pg_terminate_backend`  to forcefully cancel the process if `pg_cancel_backend` doesn't work.

```sql
-- Option 1: Try to cancel the query gracefully first
SELECT pg_cancel_backend(<pid>);

-- Option 2: If canceling doesn't work, force termination
SELECT pg_terminate_backend(<pid>);
```

Replace `<pid>` with the process ID you wish to stop.
