---
layout: post
title:  "Setting up logical replication with Postgres"
date:   2025-06-06
---

Getting data out of your Postgres database and into a different data store, like BigQuery or Redshift, is easy with logical replication. This guide shows you how.

<!--more-->

- [Overview of replication](#overview-of-replication)
- [Setting up a publication](#setting-up-a-publication)
- [Creating a replication user](#creating-a-replication-user)
- [Wrapping things up](#wrapping-things-up)

## Overview of replication

Replication is the process of copying data from one database to another. There are different types of replication: physical and logical.

In physical replication, the primary database writes all changes to the Write-Ahead Log (WAL), and the standby database (otherwise known as a “replica” or “reader”) reads those WAL records and applies them to its copy of the database. Physical replication is well-suited for failover, read scaling, and disaster recovery.

In logical replication, the “publisher” database captures changes from its WAL, converts them into logical change records, and then sends them to the “subscriber” database, which executes the SQL operations contained in those change records to manipulate its copy of the data. Logical replication is well-suited for data warehouses, multi-tenancy (where each tenant’s data is replicated to a dedicated database), and version upgrades.

This guide focuses on implementing logical replication using Postgres publications. The primary use case under consideration is effectively moving data from the Postgres database to a data warehouse like BigQuery or Redshift.

It may be tempting to handle this in the application layer via a scheduled job or model callback, but that approach doesn’t scale. Application-layer approaches inevitably introduce increased load on the database, risk data inconsistency in the event of failure, and introduce additional complexity that is not part of your domain logic.

Logical replication provides guaranteed delivery, handles failures gracefully, maintains data consistency, and captures all changes automatically without impacting application performance. Best of all, it is surprisingly simple to configure.

## Setting up a publication

A PostgreSQL publication is a named collection of tables (or specific table data) that you want to replicate using logical replication. This could be all the tables in the database, a subset of the tables, or even filtered data from specific tables. Essentially, the publication acts as a catalog of the data available for replication, which a subscriber then receives.

First, create a role that will own the publications.

```sql
CREATE ROLE publication_manager;
```

Grant the role to the database user(s).

```
GRANT publication_manager TO <USER NAME>;
```

Create the publication.

```
CREATE PUBLICATION <PUBLICATION NAME> FOR TABLE public.<TABLE_NAME>;
```

Set the owner of the publication as the publication manager role.

```sql
ALTER PUBLICATION properties_updates OWNER TO publication_manager;
```

Verify the publication was created successfully by listing the publications and the associated tables being replicated.

```sql
SELECT
    p.pubname,
    p.puballtables,
    pt.schemaname,
    pt.tablename
FROM pg_publication p
LEFT JOIN pg_publication_tables pt ON p.pubname = pt.pubname
ORDER BY p.pubname, pt.schemaname, pt.tablename;
```

If you need to replicate other tables, you can add more tables to the publication.

```sql
ALTER PUBLICATION <PUBLICATION NAME> ADD TABLE <TABLE NAME>;
```

Alternatively, you can create another publication. While there are several considerations to weigh when choosing when to create a new publication versus adding tables to an existing publication, one of the primary factors is the nature of the data being replicated and its intended subscriber(s).

For example, you may have a publication configured to replicate data for an analytics workload, but you may also need to replicate a subset of the data to a CRM system. In this case, it makes sense to create a new publication with only the data needed by the CRM system, as it is unlikely the CRM system would need access to all of the data the analytics workload requires.

## Creating a replication user

Create a replication user that will have access to the table data.

```
CREATE USER <REPLICATION USER NAME> WITH REPLICATION PASSWORD '<SECURE PASSWORD>';
```

Grant the SELECT privilege on the table to the replication user.

```sql
GRANT SELECT ON TABLE "public"."<TABLE NAME>" TO "<REPLICATION USER NAME>";
```

From here, you can configure the destination to authenticate with the created replication user name and password. You may also need to configure table mappings and other details which may be specific to the vendor.

## Wrapping things up

…And that’s it! Logical replication is a powerful and simple way to effectively stream data from a Postgres database to another data source. It is straightforward to set-up and requires little maintenance. This guide only covers the basics, but these steps will take you pretty far.
