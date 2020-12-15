# Contributing to this project

Thank you for taking your time to contribute in some way to this project,
reporting issues or providing suggestions or performing code reviews. These
are the contributing guidelines for this project.

By contributing to this project we assume you have already read this
contributing guidelines and you agree to them. Please, do not contribute to
the project if you don't agree with the contents of this document.

## 1. Reporting issues

### 1.1 What belongs on the issue tracker?

The issue tracker is the homeplace for bug reports, suggestions, discussions
about the project and such. If there is something **related to the source code
project** you want to talk about, this is the place. Examples:

* Hey, I found a bug on this website. If I open this page, it doesn't work.
* Hey, this is a cool idea that could make the website better.
* Hey, I'm using your project to learn Rails. Can you explain to me how this
  piece of code at this file works?

Examples of things that don't belong on the issue tracker: questions about the
content of the tutorials on the website. Hasn't happened so far, but it's a
warning. Use the official communities for that, please.

### 1.2 Multiple issues

If you have multiple topics to report, send multiple issues. Issues are free
to create, and no one has to pay for them, don't worry. Send 5 issues in a batch
if you need.

Why? Well: the issue tracker will assign an unique number to each issue. It is
important to keep the issues limited to one topic per issue because it makes
tracing the reports easier, specially when it comes to bug reports. If you send
a single issue with a lot of questions or unrelated bugs, it makes hard to know
when an issue is actually _fixed_. If you send a single issue with a lot of
unrelated issues inside, you may be requested to submit again your issue
following this rule and your original issue may be closed.

### 1.3 Technical specs

Bug reports should include as much technical information as you can provide.
It is required to know how did you reach the bug so that it can be replicated.
If you are reporting bugs as an user, provide the following information:

* Browser, browser version, operating system.
* URL you were visiting.
* Expected behaviour. This is what _should_ have happened.
* Actual behaviour. This is what _really_ happened (and shouldn't).

If you cloned the web application and you were running locally the application
when the bug happened, please include the following information:

* Operating system running your Ruby engine.
* Version for the following assets: Ruby, PostgreSQL, Yarn, Node.js version. 
* URL or controller + action you were visiting.
* Stack trace if available.
* Expected behaviour. This is what _should_ have happened.
* Actual behaviour. This is what _really_ happened (and shouldn't).

If you are using unsupported software (MySQL instead of PostgreSQL, for
instance, or an older version of the Ruby platform), your issue may be marked
as `wontfix`. Use updated versions of the assets required to run the
application.

## 2. Sending pull requests

### 2.1 What belongs on a pull request

If you want to submit code to this project, use the pull request. Pull requests
can be reviewed by the project owner, and in fact you'll be likely asked
questions. Don't worry, this is not an exam, but given that the project is
already running on a web server, it is required that the code you submit is
considered safe to run on a live application, without causing bad experience for
final users or introducing application or security issues.

### 2.2 Always create a tracking issue before starting your work

This project is not a general purpose framework for creating channel websites.
There is a roadmap specific to this project designed by the project owners.
Therefore, unfortunatelly not all ideas fit in this project source code.

**Always create a tracking issue before starting to work in a PR**. Don't just
send a surprise PR with a lot of work, it's not funny and may cause your PR to
get closed. By sending a tracking issue beforehand, it is possible to discuss
new features, provide extra help if required... plus, if an idea doesn't fit
into the project, it's easier to know that before wasting an afternoon writing
code, don't you think?

If a tracking issue already exists and you feel you want to work on that,
communicate that beforehand also. For instance, send a comment to the issue
telling you want to help on that or you want to do that if it's not assigned.
Again, it's all about avoiding surprises.

### 2.3 Never work on trunk branch

This repository protects `trunk` branch. Even owners cannot push directly
into `trunk`, a pull request is always required. The reason is that code
merged into `trunk` is automatically deployed to the servers, so we want to
make sure that the code that enters `trunk` is a complete feature, not just a
work in progress, as that may have unexpected consequences to visitors browsing
the site.

**Always fork the project and start a feature branch**. Never commit directly
on `trunk` even in your own forks, because if I update my trunk branch, you
need to be able to pull my newest commits into your own fork. Stale code that
is not up to date with upstream cannot be safely merged.

It doesn't matter how many commits you do. It doesn't matter how many
_merge trunk into my-branch_ commits you do. Pull requests are always merged
using a squash, so even a PR with 100 commits will be merged as a single
commit. So don't be afraid to work as atomically as possible on your feature.
It won't cause clutter once merged.

### 2.4 Always provide tests

Because code merged into `trunk` is automatically deployed to the servers,
it is required to know beforehand whether the new code is safe to run in the
servers or whether it will cause regressions or bugs that may harm the visitor
experience.

Therefore, **always provide tests for your code**. There are model tests,
controller tests, even integration tests check that the generated HTML code
works as expected. Pull requests that don't provide tests and that refuse
to cooperate in this rule may be closed.

### 2.5 Always link to a tracking issue on a pull request

Because you made a tracking issue, right? Untracked pull requests may be closed.

To link to a tracking issue on GitHub, type `#` followed by the number for the
issue. So if your tracking issue is number 55, provide a link to the issue by
adding `#55` into your pull request description, so that a link is generated.
