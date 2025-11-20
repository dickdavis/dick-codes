---
layout: post
title:  "A rant I've been waiting to express for some time now"
date:   2025-11-15
---

Sometimes things happen that we just can't let go of unless we address them. *Deep Inhale*

<!--more-->

{: .toc-container}

* TOC
{:toc}

## Beware of strong opinons

If you've been in software development for any length of time, you'll have noticed that there is an abundance of so-called "best practices", strong opinions, frameworks, methodologies, and more. You've probably seen a thousand articles with headlines like "THIS is the One, True Way to do Agile," or "Test-Driven Development Will Change Your Life FOREVER," or "How Pair/Mob Programming Will Make Your Dev Team 100x More Effective."

I sampled a lot of these Kool-Aid flavors early on in my career, but eventually they all started to taste the same: like just some other dude's opinion, man. Don't get me wrong. There is merit to some of these ideas, but I just don't understand the dogmatic zeal of their proponents. I mean, if it works for you, cool, but it always seems to be an all-or-nothing sort of deal where you are expected to acknowledge the superiority of their idea, shave your head, and religiously adhere to the practice.

## My unfortunate encounter

There is a prominent contracting agency in the Ruby world that is full of such ideas, some good and others... yeah. I worked with a couple of their developers on a project once, and while I really enjoyed working with them, their cult-like adherence to their internal style guide made collaboration frustrating. One of the most contentious disagreements we had was over test set-up (TEST SET-UP!!!). 

According to their style guide, you should prefer an xUnit-style test setup in which each scenario contains all the setup needed to run the tests. No usage of any of the helpers that RSpec provides for simplifying test set-up (i.e., `let`, `subject`, etc.) and minimal use of `before` and `after` hooks. Shared examples were another big no-no, though matchers were OK.

In our discussions, I'd grant them that sometimes this makes sense, like when using a shared test setup for a particular set of scenarios would make it harder to maintain and understand what is being tested. By all means, if explicitly repeating the test setup helps make the spec easier to read and understand, **do it**. But why throw the baby out with the bathwater? The vast majority of RSpec scenarios are simple to read, understand, and maintain using the DSL as intended by the creators.

**I mean, if you are so opposed to using everything that makes RSpec, well, RSpec, then why not just write the test cases in minitest?**

I tried reasoning with them to no avail, and it sticks with me just how dogmatically they stuck to their position. It wouldn't have been an issue worth contending over, but it all started when they demanded I refactor my specs to their preferred approach. The whole episode is just absolutely baffling to me in retrospect. I've seen people get excited about test-driven development or pair programming, but advocating an unorthodox, non-mainstream misuse of RSpec and then demanding that other developers adhere to it is next-level cult shit.

It is one thing to advocate for standardization. I support that in general, but I hesitate a bit when we are discussing standardizing a non-standard practice that I've never seen used in any of the Ruby shops or open source projects I've worked on. Writing all of our specs in such a way that any slight change to test setup requires updating every scenario over and over and over again? Nah, hard pass, that's not for me.

## Wrapping up and letting go

I'm fine with people having different opinions and approaches to improving code quality. In fact, that is a sign of a healthy team. You **should** be able to give and receive feedback, and you **should** feel comfortable speaking up when something doesn't look quite right or could be improved. Code reviews **should** be more than just an "LGTM" approval. 

But what I'm not OK with is a lack of good-faith, rational discussion between colleagues. I'm not OK with cult-like adherence to a practice and then forcing that mind-virus onto your teammates and into your codebase. Those contractors are long gone now, and I still feel the pain of working with them every time I open up one of their 500 LOC specs to make a dozen identical changes to test setup. I'll leave the agency unnamed, but man, you should probably think twice before working with any contracting agencies whose name rhymes with **FraughtKnot**. 

And if you do end up working with them, don't let them anywhere near your infrastructure. That's a story for another time...
