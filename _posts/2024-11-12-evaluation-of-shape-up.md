---
layout: post
title:  "Evaluation of Shape Up"
date:   2024-11-12 01:00:00 -0500
---

I read the book *Shape Up* by Ryan Singer, taking extensive notes about the methodology and assessing its viability for adoption by product teams.

<!--more-->

- [Bottom-line up front](#bottom-line-up-front)
  - [Pros](#pros)
  - [Cons](#cons)
- [Shaping](#shaping)
  - [Set boundaries](#1-set-boundaries)
  - [Rough out the elements](#2-rough-out-the-elements)
  - [Address risks and rabbit holes](#3-address-risks-and-rabbit-holes)
  - [Write the pitch](#4-write-the-pitch)
- [Betting](#betting)
- [Building](#building)

## Bottom-line up front

Shape Up is an interesting product methodology that works well for 37signals, but probably not for most product teams. There are some aspects of the framework that are worth integrating, though I would caution against implementing Shape Up as described by the book.

### Pros

- Appetites communicate expectations clearly to the implementation team for how much time the business is willing to invest in a project.
- Fixed-time, variable scope projects help deliver value incrementally and predictably.
- Performing much of the derisking upfront helps uncover potential issues that are better sorted out before the project is picked up to be worked.
- Shaping the project at a high-level allows the implementation team broad latitude in fulfilling the intent while remaining within the business's time-box for the schedule.
- Writing out a "pitch"—the framework's version of a PRD or one-pager—and disseminating it to the team for review gives everyone time to think of questions, look for gotchas, and consider alternatives prior to committing to the work.
- Flexibility in allowing implementation teams relative autonomy to make decisions and trade-offs when building the solution.
- Committing to a "bet" ensures the team is able to focus on building and delivering the project without being pulled in multiple directions.
- Placing the onus for task creation on the people building the project—not a centralized figure or architect—results in a more accurate picture of what actually needs to be done.
- Designers and programmers collaborate heavily, making it easier to have discussions around what tasks need to be discovered, how the system works, what needs to get cut from scope, etc.
- Preventing work from being carried over from cycle to cycle ensures the team has a strong sense of ownership for the project and incentivizes them to ship on schedule.
- The focus on shipping functional software at the end of each cycle ensures value is constantly being added to the product and business.

### Cons

- Appetites seem poorly thought out; there are only two types of appetites—6 weeks or 2 weeks—so there isn't much flexibility.
- Heavily relies on business stakeholders to drive the shaping process which creates a dichotomy between thinkers and doers.
- By eschewing high-fidelity mockups during discovery, the team is unable to perform user testing that would help ensure the team is building the right thing.
- Hill charts are not commonly used and digital options are limited aside from Basecamp (the inventors of the hill chart).
- Sometimes urgent tasks should take priority over a project's work, and the framework's insistence on not interrupting the team—while logical—could work to the detriment of the business overall.
- Quality and performance issues are likely to occur given the lack of a requirement for code review or QA.
- Scope hammering can lead to unsatisfactory results which can only be corrected by shaping and betting on a new project.

## Shaping

The high-level planning process for refining, evaluating, and derisking new projects. The goal is to narrow down the problem space and outline a solution that fits within the amount of time the organization wants to spend on it. Ideally done by stakeholders and engineering leadership, with input from other team members as necessary. The shaping process has 4 steps: setting boundaries, roughing out the elements of the design, addressing risk, and writing the pitch.

### 1. Set boundaries

**Appetite**: How much the organization wants to spend on a given problem. Two sizes: 6 weeks for big batch projects and 2 weeks for small batch projects.

**Fixed-time, variable scope**: Set contraints around how long projects should take according to the appetite, and then adjust scope accordingly. If a project is expected to take longer than 6 weeks, decompose into multiple projects.

**Narrow problem definition**: Ensure the problem is understood well. Size the problem so as to maximize the value added for the time spent.

### 2. Rough out the elements

- Use breadboards to map processes to user interactions.
    - Places - areas in the application a user can navigate to.
    - Affordances - components a user can act upon.
    - Connection lines - show how the affordances take a user to places.
- Use fat marker sketches to express a rough, incomplete creative draft of the solution.
- Leave room for the team to adjust the solution as necessary.
- Not considered final work.

### 3. Address risks and rabbit holes

- Slow down and play out the use case, looking for gaps and missing pieces.
- Ask the following questions:
    - Does this require new technical work we've never done before?
    - Are we making assumptions about how the parts fit together?
    - Are we assuming a design solution exists that we couldn't come up with ourselves?
    - Is there a hard decision we should settle in advance so it doesn't trip up the team?
- Explicitly declare what is out of scope for the project.
- Explicitly call out any use cases that are specifically not supported.
- Cut back anything that isn't necessary.
- Discuss idea with technical expert to assess feasibility of delivering project within appetite and identify any technical risks.

### 4. Write the pitch

The purpose of the pitch is to present a good potential bet. It is essentially a presentation; it can be in document or slide format. It consists of a problem, appetite, solution, rabbit holes, and no-gos.

**Problem**: The problem definition should consist of a single specific story illustrating why the status quo does not work.

**Appetite**: Include the appetite in the pitch to avoid unproductive conversations and oversolutioning.

**Solution**: Presents the solution to the problem as constrained by the appetite. Includes visualizations to help make it more concrete. Includes appropriate level of detail, leaving space for teams to refine and implement.

**Rabbit holes**: Explicitly callout potential considerations that are not central to the problem but need to be accounted for to deliver the project.

**No-gos**: Explicitly callout anything that is out of scope for the project.

## Betting

- Favor decentralized ownership of projects/pitches instead of a backlog that requires grooming from the team.
- Individuals pitch their project ideas to stakeholders during a meeting scheduled for the cooldown cycle.
- Everyone has an opportunity to review pitches ahead of the meeting.
- Pitches are either accepted or rejected at the meeting (called a "betting table" in the framework's terminology); the accepted pitches are included in the next 6 week build cycle, whereas the rejected pitches are discarded.
- Several common questions are asked and answered during the betting table meeting:
    - Does the problem matter?
    - Is the appetite right?
    - Is the solution attractive?
    - Is this the right time?
    - Are the right people available?
- Discarded pitches can be brought back to the betting table consideration after the individual with ownership over it addresses the weaknesses in the project idea.
- An accepted pitch is called a "bet".
- Bets have several characteristics:
    - They have a payout. The project should have a functional deliverable at the end of each cycle.
    - They are commitments. Once a bet is made, the team is committed to working on it exclusively for the entire cycle.
    - They have a cap on the downside. Since each bet only has 6 weeks for completion, the most the business stands to lose are the 6 weeks spent building it.
- Once work has begun on a project, stakeholders must honor the commitment that was made and refrain from interrupting the team.
- Builders work on projects in 6 week cycles while shapers work on new project ideas concurrently.
- The 6 week cycle is followed by a 2 week cooldown cycle where programmers can address technical debt or bugs, and shapers pitch their project ideas to stakeholders.
- Bets do not get extended if they are not completed by the end of the 6 week cycle.
    - This eliminates the risk of runaway projects.
    - A project that runs over its allotted time indicates a problem in the shaping of it.
    - This dynamic also causes teams to feel a sense of ownership over the project as no one wants to throw away the hard work they have done.
- Bugs are not given special priority. Instead, teams can work on addressing them during cooldown, bring the bug fix to a betting table, or schedule a bug smash.
- Each cycle must start with a clean slate. No work is carried over between cycles.
- There are two modes of working:
    - R&D mode:
        - Bet on the time for spiking on key features, not a pitch.
        - Senior team members do the work.
        - Shipping a finished product is not the goal; spiking is.
    - Production mode:
        - Shaping is deliberate; pitches are drafted and betted on.
        - Not limited to senior team members.
        - Shipping a finished project is the goal.
- The final phase of a large project is the cleanup phase.
    - Shaping is not conducted.
    - There are no clear team boundaries.
    - Work is continuously shipped.
    - Should not last longer than 2 cycles.

## Building

- Projects are not assigned or decomposed into tasks by any centralized figure.
- The team defines their own tasks and approach to the work.
- The team has full autonomy to operate within the boundaries of the pitch.
- The team deploys their work at the end of the cycle; testing and QA must happen within the cycle.
- The project begins with a kick-off meeting that allows the team to ask clarifying questions.
- The majority of the work that needs to be done is discovered during the early part of the cycle.
- The framework emphasizes that the best way to find out what needs to be done is to dig in and start doing the work.
- The team should aim to build something functional to demo within the first week.
    - This allows for the team to build momentum by establishing early wins.
- Programmers are able to do foundational modeling work based on the pitch without needing pixel-perfect designs.
- Programmers and designers should engage with each other closely as the work progresses.
- Teams should focus on solving the challenging parts of the project first as this helps to reduce the chance for failure late in the cycle.
- Tasks should be grouped into scopes that align with different components of the project.
- Scopes will change over time as the team gains a better understanding of the interdependencies of the project.
- Well-made scopes show the anatomy of the project. Teams know they have the scopes right when:
    - They can see the whole project with no complexity hidden.
    - The conversations about the project flow because of the shared language.
    - New tasks are easily bucketed into existing scopes.
- Nice-to-have's should be marked as such and deprioritized.
- Teams should use hill charts to communicate project status to managers.
- Teams should aim to ship functional software, not perfect. Comparisons should be made to the baseline user experience rather than an idealized future version of the software.
- Given the constraints the cycle imposes, teams must efficiently hammer out the overall scope of the project. This entails making tradeoffs and having discussions about what is truly needed to meet the intent of the pitch. Some questions that help with scope hammering:
    - Is this a must-have for the new feature?
    - Could we ship without this?
    - What happens if we don't do this?
    - Is this a new problem or a pre-existing one that customers already live with?
    - How likely is this case or condition to occur?
    - When this case occurs, which customers see it? Is it core or more of an edge case?
    - What's the actual impact of this case or condition in the event it does happen?
    - When something doesn't work well for a particular use case, how aligned is that use case with our intended audience?
- Teams can ship work without formal checkpoints such as QA or code review.
- In rare cases, projects can be extended:
    - The outstanding tasks must be true must-have's.
    - The outstanding work must be all downhill.
