# makigas.es

This repository contains both the public website and the backoffice
dashboard to manage content. It is a standard Ruby on Rails project, but
it comes from the RoR 4.x era, so there are some decisions that
currently exist because they haven't been tackled yet:

- I am not using ActiveStorage, because it did not exist at the time.
  There is interest in migrating to ActiveStorage, but currently I am
  still using Paperclip (or KtPaperclip). Thus, models that require
  images currently have the data in the models themselves.
- I am not using the modern JavaScript pipeline suggested by Ruby on
  Rails, but I do this because every couple of years they change the
  "approach" and it is very annoying. Currently I am settled in using
  esbuild externally, so I just `npm run bundle:watch` in a separate
  terminal whenever I want to work with the application, and call it a
  day. esbuild packs the stuff into `app/assets/builds`, and this is
  enough.

Besides from that, it is a standard Ruby on Rails fullstack project. No
frontend framework, barely any JavaScript. The website content is
rendered server side using ERB and HAML (this is another debt point that
I'd like to tackle at some point: unify the layout into one single
markup language).

The directories of interest are:

- Any standard Rails path like app/controllers, app/models, app/views
  and app/helpers.
- I use ViewComponent, so app/components.
- The JavaScript bundles live in app/javascript, but I detail more about
  this below.
- I have a couple of services for more complex application logic in
  app/services.
- My spec files at spec/.

In regards to JavaScript: I have two entrypoints in
app/javascript/packs:

- six: it is the name of the frontend design (eventually we'll move to
  seven, which is the next iteration, once all the debt is cleaned.)
- dashboard: it is the name of the backoffice design (currently it is a
  Bootstrap application, but I'd like to remove Bootstrap).

I barely use any JavaScript in this site. Mainly for minor things such
as making sure that some widgets are initially scrolled, or for
controlling the Plausible analytics system, or to render YouTube embeds.

But there is a lot of CSS files in app/javascript/six for the design.
And there is a lot of technical debt that eventually will have to be
solved.
