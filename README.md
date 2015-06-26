# Trellisheets

Herein lies guidelines, resources, and examples for writing CSS for Trello.

## Is there a certain way I should write my CSS?

As much as possible, you should stick to the [`styleguide.md`](styleguide.md).
Read that first. The general idea is that you should break up your CSS into as
many small encapsulated parts as possible then import them as needed.
[`/src/entries/core.less`](/src/entries/core.less) is an example of how to
structure and import files.

## Should I use these styles for the web client?

The web client does’t use the base styles and components provided here, but it
does stick to the style guide (please read it). These styles should be used as
a starting point for almost everything else: blogs, landing pages, etc.

## What do I do with these components, utilities, base style, etc.

You should copy over the LESS files and have some build process in your project.
You’re not expected to use the compiled version of `core.css` from this repo.

You’ll likely have a core.css for all the pages on the site, then other CSS
files for specific pages. You can add another file to
[`/src/entries`](/src/entries), import the components for the page, and Gulp
will handle the rest.

All the styles are in [`/src`](/src).

## What tech are we using here?

We’re using [LESS](http://lesscss.org/), [Gulp](http://gulpjs.com/), and
[Autoprefixer](https://github.com/postcss/autoprefixer).

Reading through the style guide (have you read it yet?), you’ll see that we
try and keep our CSS pretty vanilla. We don’t heavily rely on preprocessors; we
mainly just use LESS for imports, variables, some mixins, and very shallow
nesting (like `&:hover`).

Gulp builds the LESS files. You can use the example
[`package.json`](package.json) and [`gulpfile.coffee`](gulpfile.coffee) to get
started. Those are just boilerplate; you’ll change these up a bit for your
project.

Autoprefixer has been tremendously useful and you’ll want to include it. You can
write CSS to spec and it will write the vendor-prefixed declarations for you. No
more `-webkit-*`. We typically target IE10+, Safari 6+, and the last three
versions of Chrome and Firefox.

You can replace LESS and Gulp with whatever preprocessor you like, so long as
you are conscious of the [`styleguide`](styleguide.md) which should have read by
now. The resources here are import-ready and written in LESS, so it’s a good
place to start.

## Where did brand-colors.less come from?

They are exported from [Trellicolors](https://github.com/trello/trellicolors),
which is the canonical source. You can get them in LESS or SCSS flavored
variables. Also check out the [Colors section in the Brand
Guide](https://trello.com/about/branding#colors) for how we use brand colors.

## I want to build or add stylesheets.

1. Read the [style guide](styleguide.md).
2. `npm install`
3. Add to `src/**/` and import in respective `/src/entries` files.
4. `./tools/dev` (runs tools/gulp and tools/serve)
5. Add to public/index.html if you want.
6. Visit [localhost:8080](http://localhost:8080)
