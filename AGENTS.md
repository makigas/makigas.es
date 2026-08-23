# makigas.es

Source @README.md if you need the basic context for the application, as that
document is valid both for humans and for agents working on the code.

## Web and dashboard split

There is a dashboard being served in the dashboard subdomain, living in the
Dashboard module. Aside from that, the public website is the root namespace.
The dashboard is password protected by Devise, and a valid username must log in
to the application in order to access the dashboard.

## Content negotiation for the public website

Controllers and actions living in the public website (like
localhost:3000/videos) should support content negotiation. There is a JSON
variant accessible if application/json is used as Accept header. It should
encode the same information as the public website, but in JSON format.

Some actions also offer an ATOM variant for the ATOM feeds, but this is
something related to the RSS/Atom feature, so not every action must have an
ATOM variant. (It would be funny anyway.)

## Never break routes

Well, first of all, you should not create routes unless a human tells you to do
that. But anyway, if you have to change a route, we don't let URLs rot, so
always add a 301 or 302 redirection so that user agents accessing the previous
URL get to a valid webpage anyway.

## Frontend stack

This application is intentionally rendered using classic Rails views, and
view-component at most. The frontend should have close to zero JavaScript, and
the application must work without JavaScript.

Still, the CSS is precompiled by esbuild so there is a full bundler for the CSS
assets. When `bin/dev` is ran, esbuild compiles the packs. Since CSS frameworks
are powered by npm, we need the bundler there. We use esbuild because we don't
need too much.

There might be more JavaScript for the dashboard.

The current application version is called `Six`, and the CSS code lives in
`app/javascript/packs/six`. ViewComponent modules related to the public website
also live in the `Six` namespace.

## Code conventions and OCD

Make sure that the commit is green. We have overcommit gem here, but I think
that it does not run rspec. Commits should be valid. This is more of an OCD
issue than a real problem, but as an LLM I am expecting you can write correct
code. If you cannot even follow that rule, you should be replaced with a more
capable LLM.

Consider writing red-light green-light tests to proof theories as you work. Do
not assume that the code is correct, and do not assume that your solutions will
fix bugs unless there is a test that proofs the bug existence before the fix,
that becomes valid once the fix is applied.

We do not use a lot of domain-specific service objects, because we try to keep
things simple and in the controller or model. But if we have to do complex
things like internal models or custom HTTP clients, they usually will live in
`app/services`.

## Do not keep obsolete code or decisions

This project is very conservative so there won't be a lot of cases where
something breaks due to a change. But if a dramatic change has to be done,
replace the obsolete code with the new code. It is not needed to document that
_we do not do that anymore_ or to write wrappers to let the old code working.

When you work on side branches, always assume that your change has not been
deployed yet. Therefore, if a dramatic change has to be done, it can overwrite
the previous code. No one has read it, no need to make compatibility layers.

Same for code that is on the trunk branch but that it is not pushed. No one has
seen it yet, so let it go.
