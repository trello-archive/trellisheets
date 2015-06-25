# Trellisheets

Herein lies guidelines, resources, and examples for writing CSS for Trello.

## Is there a certain way I should write my CSS?

As much as possible, you should stick to the [`styleguide.md`](styleguide.md).
Read that first. It has everything you need to know.

The general idea is that you should break up your CSS into as many small
encapsulated parts as possible then import them as needed. See
[`/src/entries/core.less`](/src/entries/core.less) for an example of how to
structure and import files.

## Should I use these styles for the web client?

You won’t use the provided base styles and components for the web client. It
has very specific style needs and these styles don’t apply. You should still
stick to the style guide. These styles should be used as a starting point
everywhere else, like blogs, landing pages, etc.

## What do I do with these components, utilities, base style, etc.

Copy them in your project. Everything in this repo is up for change so you don't
want to be importing directly because it may not be backwards compatible. You’ll
be able to see when things changed.

You’re not expected to use the compiled version of `core.css` from this repo.
You should copy over the LESS files and have some build process in your project.
You can add components as needed.

You’ll likely have a core.css for all pages, then other CSS files for specific
pages. You can add another file to [`/src/entries`](/src/entries), import the
components for the page, and Gulp will handle the rest.

All the styles are in [`/src`](/src).

## What tech are we using here?

We’re using [LESS](http://lesscss.org/), [Gulp](http://gulpjs.com/), and
[Autoprefixer](https://github.com/postcss/autoprefixer).

Reading through the style guide, you’ll see that we try and keep our CSS is
pretty vanilla. We don’t heavily rely on preprocessors; we mainly just use LESS
for imports, variables, some mixins, and very shallow nesting (like `&:hover`).

Gulp builds the LESS files. You can use the example
[`package.json`](package.json) and [`gulpfile.coffee`](gulpfile.coffee) to get
started.

Autoprefixer has been tremendously useful and you’ll want to include it. You can
write CSS to spec and it will write the vendor-prefixed declarations for you. No
more `-webkit-*`. We typically target IE10+, Safari 6+, and the last three
versions of Chrome and Firefox.

You can replace LESS and Gulp with whatever preprocessor you like, so long as
you are conscious of the [`styleguide`](styleguide.md). The resources here are
written in LESS and Gulp, so it’s a good place to start unless you feel strongly
otherwise.

## Where did brand-colors.less come from?

They are exported from [Trellicolors](https://github.com/trello/trellicolors),
which is the canonical source. You can get them in LESS or SCSS flavored
variables. Also check out the [Colors section in the Brand
Guide](https://trello.com/about/branding#colors) for usage tips and guildelines.

## I want to build or add stylesheets.

1. `npm install`
2. Add to `src/**/` and import in respective `/src/entries` files.
3. `./tools/gulp`
