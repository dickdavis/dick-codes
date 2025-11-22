---
layout: post
title:  "Efficiently backfilling data in Postgres"
date:   2025-04-20
tags:   [postgres, performance]
---

While a rake task or background job works fine for most data imports, they become prohibitively slow when dealing with millions of rows. PostgreSQL's `\copy` command can handle these large datasets orders of magnitude faster than application-level approaches.

<!--more-->

{: .toc-container}

* TOC
{:toc}

*Note: the snippets in this guide use placeholder tags (`<PLACEHOLDER>`) that you should replace as necessary.*

## Saving query results to CSV
The `\copy` command is a [meta-command](https://www.postgresql.org/docs/current/app-psql.html#APP-PSQL-META-COMMANDS-COPY) available when using `psql` client to manage a PostgreSQL database. It allows you to import data from a file into a table quickly--much quicker than other methods.

```
\copy (
  -- <YOUR QUERY TO SELECT DATA HERE>
) TO '/tmp/<FILENAME>.csv' CSV DELIMITER ',' HEADER;
```

Enter your query within the body of the `\copy` command and replace `<FILENAME>` with the desired filename for the generated CSV file. The generated CSV file will use the columns selected in the query as the headers.

## Importing the CSV file
After saving the query output to a CSV file, we can then use the copy command to insert the data into a specified table. The columns you enter should be in the order expected per the CSV file headers.

```
\copy <TABLE NAME> (<COLUMNS>) FROM '/tmp/<FILENAME>.csv' CSV DELIMITER ',' HEADER;
```

It is important to remember that this operation will insert rows into the table. If you need to update existing rows, you can create a temporary table into which you insert the data before running your update query using the temporary table data. Ensure you create the temporary table with columns in the order expected for the CSV file.

```
-- Create the temporary table
CREATE TEMP TABLE <TEMPORARY TABLE NAME> (
  id INTEGER,
  <COLUMN NAME> <COLUMN DATA TYPE>
);

-- Import the data into the temporary table
\copy <TEMPORARY TABLE NAME> FROM '/tmp/<FILENAME>.csv' CSV DELIMITER ',' HEADER;

-- Perform the update operation using the imported data
UPDATE <TABLE NAME>
SET <COLUMN NAME> = <TEMPORARY TABLE NAME>.<COLUMN NAME>
FROM <TEMPORARY TABLE NAME>
WHERE <TABLE NAME>.id = <TEMPORARY TABLE NAME>.id;

-- Clean up the temporary table
DROP TABLE <TEMPORARY TABLE NAME>;

```

## Diagnosing slow imports
Imports can be slow for a number of reasons, including large datasets to import or foreign key constraints. There are several methods you can use to work around these potential issues.

### Large datasets to import
If you have millions of records to import, it may make sense to split the CSV file into chunks. These bash commands will split the CSV file into files of 1,000,000 records each, inserting the CSV headers as the first row in each generated file.

```bash
# Split into chunks of 1 million lines each
split -l 1000000 /tmp/<FILENAME>.csv /tmp/chunk_

# Handle headers as above
head -n 1 /tmp/<FILENAME>.csv > /tmp/header.csv

for f in /tmp/chunk_*; do
  if [ "$f" != "/tmp/chunk_aa" ]; then # Skip first chunk which already has header
    cat /tmp/header.csv "$f" > "${f}.csv"
  fi
done
```

Once you have the file split into multiple smaller files, you can attempt to import them again one at a time.

### Foreign key constraints
Foreign key constraints are crucial for ensuring referential integrity, but they can dramatically slow down imports. It may make sense to temporarily remove a foreign key constraint while running an import, and then create/validate the foreign key constraint after the import is complete.

First, get the name of the foreign key constraint using the command `\d+ <TABLE NAME>`. Then, remove the foreign key constraint.

```
ALTER TABLE <TABLE NAME>
DROP CONSTRAINT <FOREIGN KEY NAME>;
```

Perform the import, then reapply the foreign key constraint.

```
ALTER TABLE <TABLE NAME>
ADD CONSTRAINT <FOREIGN KEY NAME>
FOREIGN KEY (<REFERENCED TABLE NAME>)
REFERENCES <REFERENCED TABLE NAME>(<REFERENCED TABLE PRIMARY KEY)
NOT VALID;
```

Lastly, validate the constraint.

```
ALTER TABLE <TABLE NAME>
VALIDATE CONSTRAINT <FOREIGN KEY NAME>;
```
