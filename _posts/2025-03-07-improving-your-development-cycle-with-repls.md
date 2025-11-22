---
layout: post
title:  "Improving Your Development Cycle with REPLs"
date:   2025-03-07 01:00:00 -0500
tags:   [ruby, tools, workflow]
---

Iterate faster by using vim, tmux, and vim-slime to write and debug your code in a Read, Eval, Print Loop (REPL).

<!--more-->

{: .toc-container}

* TOC
{:toc}

## Motivation

Using a REPL can help you quickly iterate, but the default behavior of Ruby's REPL isn't exactly the best developer experience. Loading project files, reloading project files... Writing, rewriting, paging back in the REPL history to rerun something you previously wrote... It can get tedious.

There's a better way.

## Optimizing the REPL

The first thing you'll need is a REPL. The standard REPL included with Ruby is `irb`, though many developers also use `pry`.

I'm sure this isn't groundbreaking news to you. I'd be willing to wager everyone has used either `irb` or `pry` before, mostly in the form of `bin/rails console` which fires up a REPL with the Rails environment loaded.

This behavior--loading the project environment when starting the REPL--makes things simple to get started interacting with your code in the REPL.

Let's make a small executable that provides similar behavior for non-Rails projects.

Create a file named `bin/console` with the following contents:

```ruby
#!/usr/bin/env ruby

require "bundler/setup"
require "irb"
require "irb/command"

class ReloadProject < IRB::Command::Base
  category "Reload project"
  description "Reloads the project files"
  help_message <<~HELP
    Reloads the project files.

    Usage: rp
  HELP

  def execute(_arg)
    original_verbosity = $VERBOSE
    $VERBOSE = nil

    # Assuming project files are located in `lib/`--change if necessary
    lib_path = File.expand_path('../../lib', __FILE__)
    Dir.glob(File.join(lib_path, '**', '*.rb')).sort.each do |file|
      load file
    end

    puts "Project reloaded successfully."
  ensure
    $VERBOSE = original_verbosity
  end
end

IRB::Command.register(:rp, ReloadProject)

# Assuming project files are located in `lib/`--change if necessary
Dir.glob(File.join('../lib', '**', '*.rb')).sort.each do |file|
  require_relative file
end

IRB.start(__FILE__)
```

Save the file and make it executable with `chmod +x bin/console`. Now you can run `bin/console` and it will start the REPL with your project loaded.

As an added bonus, you can now quickly reload your project files by executing command `rp` from within the REPL.

## Setting up vim-slime

If you couldn't tell from the introductory text, this post is focused on using vim, tmux, and [vim-slime](https://github.com/jpalardy/vim-slime) to interact with the REPL. If the exquisite pairing of vim and tmux isn't your jam, vim-slime also works with neovim, screen, kitty and more. Check out the repo for integration details.

Install the vim-slime plugin:

```bash
mkdir -p ~/.vim/pack/plugins/start
cd ~/.vim/pack/plugins/start
git clone https://github.com/jpalardy/vim-slime.git
```

Configure vim-slime to use tmux as a target by adding the following to your `~/.vimrc`:

```
let g:slime_target = "tmux"
```

## Putting it all together

Open up two panes in tmux, with vim in one pane and your REPL (`bin/console`) in the other. The basic workflow is:

* Write some code in vim.
* Highlight the code you want to evaluate.
* Hit `C-c C-c` to send the code to the REPL.
* Check the REPL to see the result.

Super simple.

The big payoff here is that you no longer need to do any context switching. You can write all the code directly in your text editor and dispatch any section of it to the REPL to evaluate it in real time, thus avoiding the clunkiness of using the REPL directly.

And it works with any REPL, including `pry`, `irb`, and `rails console`. Even better: you can use it with any language that has a REPL.

Enjoy.
