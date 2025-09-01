---
layout: post
title:  "My approach for using LLMs to assist in development"
date:   2025-07-14
---

I'm an AI skeptic who still uses LLMs daily for development work. Here's the workflow I've developed to get real value from these tools without falling into the trap of letting them do my thinking for me.

<!--more-->

- [Introduction](#introduction)
- [Finding the right models to work with](#finding-the-right-models-to-work-with)
- [Planning with models](#planning-with-models)
- [Ensuring higher quality output](#ensuring-higher-quality-output)
- [Conclusion](#conclusion)

## Introduction

Everyone has their own preferences for integrating LLMs into their development workflows; some eschew model-aided development altogether, while others seemingly use AI to produce most if not all of their work product. Most people fall somewhere along the spectrum, and I imagine the distribution resembles a bell curve, as in most things.

Personally, I am a bit of an AI skeptic. I don't think AGI is happening anytime soon. While model and tool capabilities have improved significantly, I don't generally have a lot of confidence in code generated autonomously by AI. The whole AI ecosystem reeks of greed and grift; I just can't shake the feeling that the technology isn't going to live up to the hype and bad things are going to happen, but a few people are going to make a ton of money. Sound familiar?

Still, there are practical applications of AI that exist today and are incredibly useful. Here are just a few real-world examples:

* I developed an internal tool for managing our deployments that generates summaries and release announcements to share with stakeholders by essentially feeding in a diff of our `main` and `production` branches. We previously had to do this manually ourselves, but now it's as simple as running the tool and pasting it in Slack.
* I implemented a stage in one of our ETL pipelines to clean up messy raw text by using an LLM to incorporate the original text and other related data points into a much simpler, easier to read text description.
* I used an LLM to help me learn the Go programming language through building non-trivial projects and interrogating the model about language features, design patterns, tooling, etc. While I wouldn't rate myself as an expert, it did give me a solid base that I continue to build on.

These are just a few examples off the top of my head. Clearly, AI __in its current state__ is useful, so I have a hard time understanding why some developers are so animated in their distaste and dismissal of it.

With all this in mind, I'm going to share how I have been able to work effectively with LLMs.

## Finding the right models to work with

I am fond of the Claude series of models, and generally prefer products that incorporate their use. They perform well, often ahead of competing models. The tone the models use is less obsequious, and the generated text content is easier to read with less fluff. Anecdotally, most of the developers I know personally agree Claude performs better at coding tasks, and the general chatter on [Lobste.rs](https://lobste.rs) seems to confirm this.

In addition to developing models that perform well relative to other offerings in the market, Anthropic has been the first company to publish model cards and system prompts. Their model and product rollouts are more thoughtful than those of their competitors; they place a strong emphasis on alignment testing for new models, which leads to slower delivery times. This trade-off seems worthwhile to me, given the extreme impact that artificial intelligence is projected to and already having.

They always seem to be one step behind OpenAI in some respects, although they have led in other areas, including when they created the [Model Context Protocol](https://modelcontextprotocol.io) last year. I was excited when MCP was first announced, which led me to create the first Ruby gem that implements the protocol. While I am still assessing its viability as an additional offering to serve customers, it has been an incredible boon to my development efforts. I have seen a dramatic improvement in the utility of LLMs for development since crafting prompts, tools, and resources that the models can use to gather context from my Rails apps via MCP.

Ultimately, I believe that models will (and are already starting to) become commidities. I experimented with different models in the early days, but hardly ever bother doing so anymore. I think it makes more sense to select a model based off pricing, the provider, and other such considerations; model performance won't be much of a differentiation moving forward.

## Planning with models

Personally, I've found LLMs to be helpful in exploring a problem space and planning future development work. Over time, I've developed a planning workflow that works well for me and adapts easily to new tools.

Here is an outline of the workflow that I generally use when planning a new feature or system improvement:

- Draft requirements document.
    - Be specific in what you are trying to achieve, the constraints that exist, etc.
- Prompt model to brainstorm high-level approaches to meet the requirements.
- Select 2-3 of the most promising approaches.
- Draft implementation documents for each approach. 
    - Keep a running record of the solutions as they evolve.
    - Include a file tree, generated code, and mermaid diagrams.
    - Generated code is considered disposable.
        - It should closely approximate the eventual solution.
        - It does not need to be production-ready
        - It does not need test coverage.
        - It does not need to even work, really. The idea is to just get an idea of what **could** work.
- Interrogate the model to expand on the selected approaches.
    - Evaluate generated code for correctness and ergonomics.
    - Question the model as to why it made certain design decisions.
    - Shape the evolution of each solution by providing critical feedback.
- Prepare implementation documents for review.
    - Summarize each of the generated components without AI assistance.
        - This tests your understanding of the generated solutions.
        - Ask the model additional questions as necessary to develop a full understanding.
    - Provide the model with the implementation documents.
    - Instruct the model to evaluate your summaries for correctness.
        - Update your summaries if necessary.
        - Revisit earlier design decisions if a newfound understanding necessitates doing so.
    - Instruct the model to update the file tree and diagrams.
    - Instruct the model to generate pithy pros and cons of each approach.
        - Evaluate these for relevance to the project and product architecture.
        - These should include considerations of performance, maintainability, ergonomics, scalability, and more.
- Present implementation approaches in a roundtable meeting with other developers
    - Solicit feedback on the correctness, maintainability, and ergonomics of each solution.
    - Document recommendations for changes.

This workflow has served me well over the past six months or so, and I think its largely because __I don't delegate critical thinking to the models__.

I think most people overestimate the capabilities of the model they are using, which is easy to do given the speed and confidence with which they provide answers. Instead, you should recognize that LLMs are probabilistic in nature, over-index on their training data, hallucinate non-existent APIs, make crazy assumptions, and just generally break in weird, unexpected ways. You'll get far better results from LLMs if you keep yourself in the loop and question everything.

## Ensuring higher quality output

There are a few steps you can take to ensure higher quality output:

- Context management
    - Store artifacts in a project folder in markdown format.
    - Use MCP servers to provide context to the model.
        - Git repositories, file system, databases, etc.
- Prompt design
    - Keep examples of effective prompts in a repository for adaptation and reuse between projects.
- Focused interrogations
    - Keep model interrogations focused on a single purpose.
    - Update artifacts during and between interrogations to capture changes.
        - Projects in Claude Desktop are perfect for this.
    - Begin a new interrogation when the conversation length becomes excessive.
- Document quality
    - Be concise and use active voice.
    - Place important information at the beginning of the document.
    - Use a template to ensure the LLM organizes its output appropriately.
- Response quality
    - Include model instructions that help ensure responses align with your expectations.
        - Code style (standardrb, preferred RSpec style, etc.)

## Conclusion

The workflow I've outlined keeps LLMs where they belong: as tools that augment development, not replace thinking. They're useful for exploring problem spaces, generating boilerplate, and catching oversights, but they're also prone to hallucinating APIs and making bizarre assumptions. The key is maintaining that critical distance. Use them to handle the tedious parts while keeping the interesting problems for yourself.

The hype will continue, and we'll keep hearing about how AI is going to replace developers. Meanwhile, those of us actually shipping software will keep doing what we've always done: adopting tools that make us more productive while maintaining healthy skepticism about silver bullets. If you're considering LLMs for development, give them a try, but never let them do your thinking for you.
