---
layout: post
title:  "Polymorphic Relationships in ActiveRecord"
date:   2023-07-10 10:00:00 -0500
---

Discover how polymorphic relationships in ActiveRecord can elegantly separate billing accounts from collaborative groups - a practical guide based on real-world implementation.

<!--more-->

{: .toc-container}

* TOC
{:toc}

### Introduction

I was recently implementing a feature to support billing multi-user accounts when I realized my initial approach was missing something. It became clear as I progressed that I made a mistake in assuming the work I was doing on creating multi-user accounts would also apply for a feature planned for later in the year which would allow users to collaborate with other users in groups.

My initial direction was flawed because I conflated two separate domain entities when planning: groups and accounts. Although similar in that they would represent aggregators of `User` records, they were different in their purpose within the domain model. An `Account` represents a record containing billing information for one or more users which connects to the subscription billing vendor. In contrast, a `Group` represents an organizational unit tying together individual users working together in some capacity to perform tasks within the application.

<div class="mermaid">
mindmap
  root((User))
    Account
      contains billing information
      integrates with subscription billing vendor
      source of truth for whether user has permissions based on subscription state
    Group
      allows users to collaborate within the application
      connects users regardless of subscription status
</div>

I mistakenly assumed that I could use the `Account` model to handle both areas of concern, but I could see how various gotcha's could complicate things further down the line. It became clear that the `Account` and `Group` models needed to be separated, but how?

A `User` record can be tied to an `Account` record through a join table named `account_memberships`. The `account_memberships` table has two columns: `user_id`, a foreign key to the `users` table; and `account_id`, a foreign key to the `accounts` table. A `User` can have zero or more `AccountMembership` records, which are in turn tied to an `Account` record. Likewise, an `Account` can have zero or more `AccountMembership` records tied to it which are in turn tied to different `User` records. The relationships are modeled in the ERD below.

<div class="mermaid">
erDiagram

    users ||--o{ account_memberships : has
    accounts ||--o{ account_memberships : has

    users {
        integer id
        string name
    }

    accounts {
        integer id
        string name
        string stripe_customer_id
    }

    account_memberships {
        integer user_id
        integer account_id
    }
</div>

The implementation for a `Group` is similar: a `User` record and a `Group` record can be tied together through a join table that contains foreign keys to both tables. In this instance, the join table would need a `group_id` column that serves as a foreign key to the `groups` table, but the rest of the implementation would remain the same.

<div class="mermaid">
erDiagram

    users ||--o{ group_memberships : has
    groups ||--o{ group_memberships : has

    users {
        integer id
        string name
    }

    groups {
        integer id
        string name
    }

    group_memberships {
        integer user_id
        integer group_id
    }
</div>

While this implementation could work, we can do better.

### Polymorphism

Polymorphism is a concept in which objects of different classes can receive and handle the same message being sent from another class. This relationship between objects can be implemented in several ways, including inheritance, encapsulation, or certain design patterns. Rails includes support for polymorphic relationships between entities that we can use to help simplify our code.

We can start by creating a single entity that is capable of joining both the `Account` and `Group` models with the `User` model. Previously, we used the `group_memberships` and `account_memberships` tables as join tables, but this can be simplified to a single `memberships` table that handles both.

This table will need a column for `user_id` as a foreign key to the `users` table, and it will also need two new columns: `organizable_id` and `organizable_type`. The `organizable_id` is a foreign key to the table corresponding with the class name stored in the `organizable_type` column. "Organizable" is simply a generic term that we can use to represent either an `Account` or a `Group`--you could use whatever makes sense for your scenario.

<div class="mermaid">
erDiagram
memberships {
    integer user_id
    integer organizable_id
    integer organizable_type
}
</div>

The final ERD shows how the `memberships` table will serve as a single join table used by both the `accounts` and `groups` tables to relate to the `users` table.

<div class="mermaid">
erDiagram
groups ||--o{ memberships : has
users ||--o{ memberships : has
accounts ||--o{ memberships : has

users {
    integer id
    string name
}

memberships {
    integer user_id
    integer organizable_id
    string organizable_type
}

groups {
    integer id
    string name
}

accounts {
    integer id
    string name
    string stripe_customer_id
}
</div>



### Implementation

To get started, we can add a migration to create the table with both columns. Using `t.references` allows us to easily set-up foreign keys and indices, and for `organizable`, we'll need to specify `polymorphic: true` so Rails knows that it should create the `*_id` and `*_type` columns.

```ruby
class CreateMemberships < ActiveRecord::Migration[7.0]
  def change
    create_table :memberships do |t|
      t.references :user
      t.references :organizable, polymorphic: true

      t.timestamps
    end
  end
end
```

Next, we'll add associations to the `Membership` model which show that a `Membership` belongs to a `User` as well as an "organizable" (`Account` or `Group`). Using the `polymorphic: true` option tells ActiveRecord that the association is polymorphic and it should use the `*_id` and `*_type` columns to derive the associated records.

```ruby
class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :organizable, polymorphic: true
end
```

We can add the `has_many` association for the `memberships` table to the `Account` model, but we'll need to specify the `as: :organizable` option so ActiveRecord know the relationship is polymorphic, thus requiring lookup via `*_id` and `*_type`. The association to the `users` is a `has_many :through` relationship given that `memberships` is a join table between the two.

```ruby
class Account < ApplicationRecord
  has_many :memberships, as: :organizable
  has_many :users, through: :memberships
end
```

The `Group` model has an identical implementation for its associations to `Membership` and `User`.

```ruby
class Group < ApplicationRecord
  has_many :memberships, as: :organizable
  has_many :users, through: :memberships
end
```

The `User` model will also need to have the association with `memberships` added. However, the polymorphic nature of the `organizable_id` and `organizable_type` columns complicates things a bit when attempting to form the relationship between the `User` model and the `Group` and `Account` models. We'll need to pass the `source` and `source_type` options to specify some additional details about the relationship so that Rails knows which model we are providing the polymorphic relationship for.

```ruby
class User < ApplicationRecord
  has_many :memberships
  has_many :accounts, through: :memberships, source: :organizable, source_type: 'Account'
  has_many :groups, through: :memberships, source: :organizable, source_type: 'Group'
end
```

### Conclusion

We've shown that polymorphism can allow us to simplify our implementation of two related entities, and Rails makes this easy for us. When adding a reference column, we can pass the `polymorphic: true` option to generate `*_id` and `*_type` columns which are used by ActiveRecord to look up associated records of different related models. These associations are defined in the corresponding models; we pass `polymorphic: true` as an option for the `belongs_to` association, and then add an association on the corresponding model with the `as:` option provided.
