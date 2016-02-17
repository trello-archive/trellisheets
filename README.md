# Trellisheets

Herein lies guidelines, base styles, tools, and examples for writing CSS for
Trello.


## Styleguide

The first thing you should do is read the [`styleguide.md`](styleguide.md).
In general, break up your CSS into as many small, modular, encapsulated parts as
possible, then import them as needed.


## I’m making a new Trello site. How do I do that, briefly?

Copy the styles from [`/src`](/src). Copy the `package.json`, `gulpfile.coffee`,
and `tools/`. Use `./tools/build` to build. Tweak the tooling for your project.
Strip any packages or components you don’t use.


## I’m making a new Trello site. How do I do that, in detail?

We’re using…

- [Gulp](http://gulpjs.com/), a build tool
- [LESS](http://lesscss.org/), a CSS preprocessor, and
- [Autoprefixer](https://github.com/postcss/autoprefixer), which applies
browser prefixes

You can replace LESS and Gulp with whatever you like, so long as
you are adhere to the [`styleguide`](styleguide.md) which you should read. The
styles and tooling here are written for LESS, so it’s a good place to start.

All the packages for building our CSS are on `npm`. Use `npm install` to install
them. You probably don’t want to include the packages in your project, so
include `node_modules` in your `.gitignore`, like [here](.gitignore).

Gulp builds the LESS files. You can use the example
[`package.json`](package.json) and [`gulpfile.coffee`](gulpfile.coffee) to get
started. Those are just boilerplate; you’ll change these for your project.
Specifically, you don’t need `http-server`. You can just remove the line.

What’s in `/tools`? `./tools/build` just calls the default gulp task which
builds the files in [`/src/entries`](/src/entries). These are minified and
production-ready. `./tools/watch` will watch for changes to style files and
automatically rebuild them. Use this for development. You can bring your own
scripts and tooling, of course.

You’ll likely have a core.css for all the pages on the site, then other CSS
files for specific pages, depending on the size of the project. Gulp will build
any files in [`/src/entries`](/src/entries), so just add them there.

Reading through the style guide (have you read it yet?), you’ll see that we
try and keep our CSS pretty vanilla. We don’t heavily rely on preprocessors. We
mainly just use LESS for imports, variables, some mixins, and very shallow
nesting (like `&:hover`).

Autoprefixer has been tremendously useful. You can
write CSS to spec and it will write the vendor-prefixed declarations for you. No
more `-webkit-*`. If we drop browsers in the future, all we have
to do is change the browser list in the gulpfile. See
[browserslist](https://github.com/ai/browserslist#queries) for more information.



## Are these the styles we use on the web client?

No. The web client doesn't use the base styles and components provided here, but
it does stick to the style guide (please read it). These styles should be used
as a starting point for almost everything else: blogs, landing pages, etc.


## Where does `brand-colors.less` come from?

They are exported from [Trellicolors](https://github.com/trello/trellicolors),
which is the canonical source. You can get them in LESS or SCSS flavored
variables. Also check out the [Colors section in the Brand
Guide](https://trello.com/about/branding#colors) for how we use brand colors.


## I want to edit or add stylesheets to this repo.

1. Read the [style guide](styleguide.md).
2. `npm install`
3. Add CSS to `src/**/` and import in respective `/src/entries` files.
4. `./tools/watch`, to build and watch styles
5. `./tools/serve`, to serve the site
7. Visit [localhost:8080](http://localhost:8080) to test.
6. Add to public/index.html or another example page.
8. Make changes in a branch and open a pull request.
