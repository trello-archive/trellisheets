# TrelliCSS

Guidelines and examples for writing Trello-rific CSS and resources for making
Trello branded sites.


## I just need a component, utility, base style, etc. Where’s that?

See `/src/styles/`. Feel free to pull it into your project.


## I have some components and stuff. How should I write my CSS?

Before you do anything, read the `styleguide.md`. It’s best to break up your
CSS into as many small encapsulated parts as possible then import them as
needed.


## What tech are we using here?

We’re using [Gulp](http://gulpjs.com/), [LESS](http://lesscss.org/),
and [Autoprefixer](https://github.com/postcss/autoprefixer).

Reading through the style guide, you’ll see that we try and keep our CSS is
pretty vanilla. We don’t use too many preprocessor functions, mainly just
imports, variables, some mixins, and very shallow nesting (like &:hover).
You can easily replace LESS with whatever preprocessor you like, but the
resources here are written in LESS, so it’s a good place to start unless you
feel strongly otherwise.

Gulp builds the LESS files. You can use the example `package.json` and
`gulpfile.coffee` to get started, but you can also bring your own build tool.

Autoprefixer has been trememdously useful and you’ll want to include it.
There are wrappers for most preprocessors and build tools.


## Where did brand-colors.less come from?

They are exported from [Trellicolors](https://github.com/trello/trellicolors),
which is the canonical source. You can get them in LESS or SCSS flavored
variables. Also check out the
[Colors section in the Brand Guide](https://trello.com/about/branding#colors)
for usage tips and guildelines.


## I want to build the styles.

Okay. Run these things.

1. `npm install`
2. Add to `src/<foo>` and import in respective `/src/entries` files
2. `./tools/gulp`
