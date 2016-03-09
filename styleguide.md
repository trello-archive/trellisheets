# Trello CSS Style Guide

Writing CSS is hard. Even if you know all the intricacies of position and float and overflow and z-index, it’s easy to end up with spaghetti code where you need inline styles, !important rules, unused cruft, and general confusion. This guide provides some architecture for writing CSS so it stays clean and maintainable for generations to come.

There are eight _fascinating_ parts.

1. [Tools](#1-tools)
2. [Components](#2-components)
    - [Modifiers](#modifiers)
    - [State](#state)
    - [Media Queries](#media-queries)
    - [Keeping It Encapsulated](#keeping-it-encapsulated)
    - [Structure](#structure)
3. [JavaScript](#3-javascript)
4. [Mixins](#4-mixins)
5. [Utilities](#5-utilities)
6. [File Structure](#6-file-structure)
7. [Style](#7-style)
8. [Miscellany](#8-miscellany)
    - [Performance](#performance)
9. [Further Reading](#9-further-reading)


## 1. Tools

> Use only imports, variables, and mixins (and only for vender-prefixed features) from CSS preprocessors.

To keep our CSS readable, we try and keep our CSS very vanilla. We use LESS, but only use imports, data-uri, variables, and some mixins (only for vender-prefixed stuff). We use imports so that variables and mixins are available everywhere and it all outputs to a single file. We occasionally use nesting, but only for very shallow things like `&:hover`. We don’t use more complex functions like guards and loops.

If you follow the rest of the guide, you shouldn’t need the complex functions in preprocessors. Have I piqued your interest? Read on…


## 2. Components

> Use the `.component-descendant-descendant` pattern for components.

Components help encapsulate your CSS and prevent run-away cascading styles and keep things readable and maintainable. Central to componentizing CSS is namespacing. Instead of using descendant selectors, like `.header img { … }`, you’ll create a new hyphen-separated class for the descendant element, like `.header-image { … }`.

Here’s an example with descendant selectors:

``` LESS
.global-header {
  background: hsl(202, 70%, 90%);
  color: hsl(202, 0%, 100%);
  height: 40px;
  padding: 10px;
}

  .global-header .logo {
    float: left;
  }

    .global-header .logo img {
      height: 40px;
      width: 200px;
    }

  .global-header .nav {
    float: right;
  }

    .global-header .nav .item {
      background: hsl(0, 0%, 90%);
      border-radius: 3px;
      display: block;
      float: left;
      -webkit-transition: background 100ms;
      transition: background 100ms;
    }

    .global-header .nav .item:hover {
      background: hsl(0, 0%, 80%);
    }
```

And here’s the same example with namespacing:

``` LESS
.global-header {
  background: hsl(202, 70%, 90%);
  color: hsl(202, 0%, 100%);
  height: 40px;
  padding: 10px;
}

  .global-header-logo {
    float: left;
  }

    .global-header-logo-image {
      background: url("logo.png");
      height: 40px;
      width: 200px;
    }

  .global-header-nav {
    float: right;
  }

    .global-header-nav-item {
      background: hsl(0, 0%, 90%);
      border-radius: 3px;
      display: block;
      float: left;
      -webkit-transition: background 100ms;
      transition: background 100ms;
    }

    .global-header-nav-item:hover {
      background: hsl(0, 0%, 80%);
    }
```

Namespacing keeps specificity low, which leads to fewer inline styles, !important declarations, and makes things more maintainable over time.

Make sure **every selector is a class**. There should be no reason to use id or element selectors. No underscores or camelCase. Everything should be lowercase.

Components make it easy to see relationships between classes. You just need to look at the name. You should still **indent descendant classes** so their relationship is even more obvious and it’s easier to scan the file. Stateful things like `:hover` should be on the same level.


### Modifiers

> Use the `.component-descendant.mod-modifier` pattern for modifier classes.

Let’s say you want to use a component, but style it in a special way. We run into a problem with namespacing because the class needs to be a sibling, not a child. Naming the selector `.component-descendant-modifier` means the modifier could be easily confused for a descendant. To denote that a class is a modifier, use a `.mod-modifier` class.

For example, we want to specially style our sign up button among the header buttons. We’ll add `.global-header-nav-item.mod-sign-up`, which looks like this:

``` HTML
<!-- HTML -->

<a class="global-header-nav-item mod-sign-up">
  Sign Up
</a>
```

``` LESS
// global-header.less

.global-header-nav-item {
  background: hsl(0, 0%, 90%);
  border-radius: 3px;
  display: block;
  float: left;
  -webkit-transition: background 100ms;
  transition: background 100ms;
}

.global-header-nav-item.mod-sign-up {
  background: hsl(120, 70%, 40%);
  color: #fff;
}
```

We inherit all the `global-header-nav-item` styles and modify it with `.mod-sign-up`. This breaks our namespace convention and increases the specificity, but that’s exactly what we want. This means we don’t have to worry about the order in the file. For the sake of clarity, put it after the part of the component it modifies. Put modifiers on the same indention level as the selector it’s modifying.

**You should never write a bare `.mod-` class**. It should always be tied to a part of a component. `.header-button.mod-sign-up { background: green; }` is good, but `.mod-sign-up { background: green; }` is bad. We could be using `.mod-sign-up` in another component and we wouldn’t want to override it.

You’ll often want to overwrite a descendant of the modified selector. Do that like so:

``` LESS
.global-header-nav-item.mod-sign-up {
  background: hsl(120, 70%, 40%);
  color: #fff;

  .global-header-nav-item-text {
    font-weight: bold;
  }

}
```

Generally, we try and avoid nesting because it results in runaway rules that are impossible to read. This is an exception.

Put modifiers at the bottom of the component file, after the original components.


### State

> Use the `.component-descendant.is-state` pattern for state. Manipulate `.is-` classes in JavaScript (but not presentation classes).

State classes show that something is enabled, expanded, hidden, or what have you. For these classes, we’ll use a new `.component-descendant.is-state` pattern.

Example: Let’s say that when you click the logo, it goes back to your home page. But because it’s a single page app, it needs to load things. You want your logo to do a loading animation. This should sound familiar to Trello users.

You’ll use a `.global-header-logo-image.is-loading` rule. That looks like this:

``` LESS
.global-header-logo-image {
  background: url("logo.png");
  height: 40px;
  width: 200px;
}

.global-header-logo-image.is-loading {
  background: url("logo-loading.gif");
}
```

JavaScript defines the state of the application, so we’ll use JavaScript to toggle the state classes. The `.component.is-state` pattern decouples state and presentation concerns so we can add state classes without needing to know about the presentation class. A developer can just say to the designer, “This element has an .is-loading class. You can style it however you want.”. If the state class were something like `global-header-logo-image--is-loading`, the developer would have to know a lot about the presentation and it would be harder to update in the future.

Like modifiers, it’s possible that the same state class will be used on different components. You don’t want to override or inherit styles, so it’s important that **every component define its own styles for the state**. They should never be defined on their own. Meaning you should see `.global-header.is-hidden { display: none; }`, but never `.is-hidden { display: none; }` (as tempting as that may be). `.is-hidden` could conceivably mean different things in different components.

We also don’t indent state classes. Again, that’s only for descendants. State classes should appear at the bottom of the file, after the original components and modifiers.


### Media Queries

> Use media query variables in your component.

It might be tempting to add something like a `mobile.less` file that contains all your mobile-specific rules. We want to avoid global media queries and instead include them inside our components. This way when we update or delete a component, we’ll be less likely to forget about the media rules.

Rather than writing out the media queries every time, we’ll use a media-queries.less file with media query variables. It should look something like this:

``` LESS
@highdensity:  ~"only screen and (-webkit-min-device-pixel-ratio: 1.5)",
               ~"only screen and (min--moz-device-pixel-ratio: 1.5)",
               ~"only screen and (-o-min-device-pixel-ratio: 3/2)",
               ~"only screen and (min-device-pixel-ratio: 1.5)";

@small:        ~"only screen and (max-width: 750px)";
@medium:       ~"only screen and (min-width: 751px) and (max-width: 900px)";
@large:        ~"only screen and (min-width: 901px) and (max-width: 1280px)";
@extra-large:  ~"only screen and (min-width: 1281px)";

@print:        ~"print";
```

To use a media query:

``` LESS
// Input
@media @large {
  .component-nav { … }
}

/* Output */
@media only screen and (min-width: 901px) and (max-width: 1280px) {
  .component-nav { … }
}
```

You can use commas to include multiple variables, like `@media @small, @medium { … }`.

This means we’re using the same breakpoints throughout and you don’t have to write the same media query over and over. Repeated phrases like media queries are easily compressed so you don’t need to worry about CSS size getting too big. This practice was taken from [this CodePen from Eric Rasch](http://codepen.io/ericrasch/pen/HzoEx).

Note that print is a media attribute, too. Keep your print rules inside components. We don’t want to forget about them either.

Put media rules at the bottom of the component file.


## Keeping It Encapsulated

Components can be large parts of the layout or just a button. In your templates, you'll likely end up with components inside each other, like a button inside a list.

Components shouldn’t know anything about each other and should be reusable in other places. Everything you need to know about the component should be in the file. Inversely, you shouldn’t overwrite or include component styles in other components. This has a lot of advantages:

1. You can see everything about the component in the file.
2. You don’t have to worry about other components overriding a style.
3. You can reuse the component elsewhere.
4. Components are small and readable.

-----

As an example, you should keep list and item components separate. For a list of boards, you’ll want to separate `board-list.less`, which defines the grid and layout, from `board-tile.less`, which defines the board styles within. With all the modifiers, states, and media queries, this keeps file size down, which in turn makes it more readable. This also allows us to reuse the board tile component elsewhere.

-----

Now a more complex example. You may reuse the `button` component inside the `member-list` component. We need to change the button’s size and positioning to fit the list. The smaller button can be reused in multiple places, so we’ll add a modifier in the button component (like, `.button.mod-small`), which we’ll use in member-list (and elsewhere). Now we do the positioning within the member list component, since that’s specific to the member list.

Here’s an example:

``` HTML
<!-- HTML -->

<div class="member-list">
  <div class="member-list-item">
    <p class="member-list-item-name">Gumby</p>
    <div class="member-list-item-action">
      <button class="mod-small">Add</button>
    </div>
  </div>
</div>
```

``` LESS
// button.less

button {
  background: #fff;
  border: 1px solid #999;
  padding: 8px 12px;
}

button.mod-small {
  padding: 6px 10px;
}


// member-list.less

.member-list {
  padding: 20px;
}

  .member-list-item {
    margin: 10px 0;
  }

    .member-list-item-name {
      font-weight: bold;
      margin: 0;
    }

    .member-list-item-action {
      float: right;
    }
```

A _bad, no good_ thing to do would be this:

``` HTML
<!-- HTML -->

<div class="member-list">
  <div class="member-list-item">
    <p class="member-list-item-name">Pat</p>
    <button class="member-list-item-button">Add</button>
  </div>
</div>
```

``` LESS
// member-list.less

.member-list-item-button {
  float: right;
  padding: 6px 10px;
}
```

In the _bad, no good_ example, `.member-list-item-button` overrides styles specific to the button component. It assumes things about button that it shouldn’t have to know anything about. It also prevents us from reusing the small button style and makes it hard to clean or change up later if needed.

You should end up with a lot of components. That’s encouraged. Always be asking yourself if everything inside a component is absolutely related and can’t be broken down into more components. If you start to have a lot of modifiers and descendants, it might be time to break it up. As a general rule, you should break up components that are **longer than 300 lines**.

## Structure

Structure your component like so…

1. The name, location, usage and notes in the comments
2. Base components with descendants
3. Modifiers (if any)
4. States (if any). States came after modifiers since you may need to overwrite styles.
5. Media Queries (if any)

An example:

``` LESS
// Component (The name)

// Used in the main section of the app. (Where it’s used.)

// Usage:
// <div class="component">
//   <p class="component-decendant">
//     <span class="component-decendant-descendant"></span>
//   </p>
// </div>
//
// (How it's used.)

// Put any other notes here, too.

.component {
  /* … */
}

  .component-descendant {
    /* … */
  }

    .component-descendant-descendant {
      /* … */
    }


// Modifiers

.component.mod-small {
  /* … */
}


// State

.component.is-highlighted {
  /* … */
}

.component.mod-small.is-highlighted {
  /* … */
}


// Media Queries

@media @small {

  .component {
    width: 100%;
  }

}


```


## 3. JavaScript

> Separate style and behavior concerns by using `.js-` prefixed classes for behavior.

For example:

``` HTML
<!-- HTML -->

<div class="content-nav">
  <a href="#" class="content-nav-button js-open-content-menu">
    Menu
  </a>
</div>
```

``` JavaScript
// JavaScript (with jQuery)

$(".js-open-content-menu").on("click", function(e){
  openMenu();
});
```

Why do we want to do this? The `.js-` class makes it clear to the next person changing this template that it is being used for some JavaScript event and should be approached with caution.

Be sure to **use a descriptive class name**. The intent of `.js-open-content-menu` is more clear than `.js-menu`. A more descriptive class is less likely to conflict with other classes and it’s lots easier to search for. The class should almost always include a verb since it’s tied to an action.

**`.js-` classes should never appear in your stylesheets**. They are for JavaScript only. Inversely, there is never a reason to see presentation classes like `.header-nav-button` in JavaScript. You will see state classes like `.is-state` in your JavaScript and your stylesheets as `.component.is-state`.


## 4. Mixins

> Prefix mixins with `.m-` and only use them sparingly for shared styles.

Mixins are shared styles that are used in more than one component. Mixins should not be standalone classes or used in markup. They should be single level and contain no nesting. Mixins make things complicated fast, so **use sparingly**.

Previously, we used mixins for browser prefixed features, but we use [autoprefixer](https://www.npmjs.com/package/autoprefixer) for that now.

When using a mixin, it should include the parenthesis to make it more obvious that it’s a mixin. Example usage:

``` LESS
// mixins.less
.m-list-divider () {
  border-bottom: 1px solid @light-gray-300;
}

// component.less
.component-descendent {
  .m-list-divider();
}
```


## 5. Utilities

> Prefix utility classes with `.u-`.

Sometimes we need a universal class that can be used in any component. Things like clear fixes, vertical alignment, and text truncation. Denote these classes by prefixing them with `.u-`. For example:

``` LESS
.u-truncate-text {
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
```

A few utility rules:

1. No utility class should be so complex that it includes nesting styles.
2. Utilities should never be overwritten or included in components or mixins.
3. Use of utility classes should be limited. Include the styles in the components when possible. We don’t need something like `.u-float-left { float: left; }` where including `float: left;` in the component is more visible.
4. You should be able to fit all the utility classes in a single file.


## 6. File Structure

The file will look something like this:

``` LESS
@charset "UTF-8"

@import "normalize.css"

// Variables
@import "variables/media-queries.less"
@import "variables/colors.less"
@import "variables/other-variables-like-fonts.less"

// Mixins
@import "mixins/mixins.less"

// Utils
@import "utils/utils.less"


// Components

// Board Components
@import "components/board/board-component-1.less"
@import "components/board/board-component-2.less"

// Header Components
@import "components/header/header-component-1.less"
@import "components/header/header-component-2.less" // and so forth


```

Include [normalize.css](http://necolas.github.io/normalize.css/) at the top of the file. It standardizes CSS defaults across browsers. You should use it in all projects. Then include variables, mixins, and utils (respectively).

Then include the components. Each component should have its own file and include all the necessary modifiers, states, and media queries. If components are well encapsulated, the order should not matter. Break up components into logical folders by section.

This should output a single `app.css` file (or something similarly named).


## 7. Style

Even following the above guidelines, it’s still possible to write CSS in a ton of different ways. Writing our CSS in a consistent way makes it more readable for everyone. Take this bit of CSS:

``` LESS
.global-header-nav-item {
  background: hsl(0, 0%, 90%);
  border-radius: 3px;
  display: block;
  float: left;
  padding: 8px 12px;
  transition: background 100ms;
}
```

It sticks to these style rules:

-	Use a new line for every selector and every declaration.
- Use two new lines between rules.
-	Add a single space between the property and value, for example `prop: value;` and not `prop:value;`.
-	Alphabetize declarations.
-	Use 2 spaces to indent, not 4 spaces and not tabs.
-	No underscores or camelCase for selectors.
- Use shorthand when appropriate, like `padding: 15px 0;` and not `padding: 15px 0px 15px 0px;`.
-	Generally, use the brand color variables. When using a color, especially grayscale tones, prefer hsl(a) over hex and rgb(a) when adding colors. It’s easier to adjust the lightness or darkness, since you only have one variable to tweak.
- No trailing whitespace.
- Keep line length under 80 characters.

Many of these are preferences, but standardizing makes reading code easier.

Note: Since we use [autoprefixer](https://github.com/postcss/autoprefixer), we don't have to worry about writing browser prefixed declarations, like `-webkit-feature`. If you are not using prefixer on your project, then put the standard declaration last. For example: `-webkit-transition: all 100ms; transition: all 100ms;`. Browsers will optimize the standard declaration, but continue to keep the old one around for compatibility. Putting the standard declaration after the vendor one means it will get used and you get the most optimized version.


## 8. Miscellany

You might get the impression from this guide that our CSS is in great shape. That is not the case. While we’ve always stuck to .js classes and often use namespaced-component-looking classes, there is a mishmash of styles and patterns throughout. That’s okay. Going forward, you should rewrite sections according to these rules. Leave the place nicer than you found it.

Some additional things to keep in mind:

- Comments rarely hurt. If you find an answer on Stack Overflow or in a blog post, add the link to a comment so future people know what’s up. It’s good to explain the purpose of the file in a comment at the top.
- In your markup, order classes like so `<div class="component mod util state js"></div>`.
- You can embed common images and files under 10kb using datauris. In the Trello web client, you can use `embed(/path/to/file)` to do this. This saves a request, but adds to the CSS size, so only use it on extremely common things like the logo.
- Avoid body classes. There is rarely a need for them. Stick to modifiers within your component.
- Explicitly write out class names in selectors. Don’t concatenate strings or use preprocessor trickery to build a class name. We want to be able to search for class names and that makes it impossible. This goes for `.js-` classes in JavaScript, too.
- If you are worried about long selector names making our CSS huge, don’t be. Compression makes this a moot point.


### Performance

Performance probably deserves it’s own guide, but I’ll talk about two big concepts: selector performance and layouts/paints.

Selector performance seems to matters less and less these days, but can be a problem in a complex, single-page app with thousands of DOM elements (like Trello). [The CSS Tricks article about selector performance](http://css-tricks.com/efficiently-rendering-css/) should help explain the important concept of the key selector. Seemingly specific rules like `.component-descendant-descendant div` are actual quite expensive in complex apps because rules are read _from right to left_. It needs to look up all the divs first (which could be thousands) then go up the DOM from there.

[Juriy Zaytsev’s post on CSS profiling](http://perfectionkills.com/profiling-css-for-fun-and-profit-optimization-notes/) profiles browsers on selector matching, layouts, paints, and parsing times of a complex app. It confirms the theory that highly specific selectors are bad for big apps. Harry Roberts of CSS Wizardry also wrote about [CSS selector performance](http://csswizardry.com/2011/09/writing-efficient-css-selectors/).

You shouldn’t have to worry about selector performance if you use components correctly. It will keep specificity about as low as it gets.

Layouts and paints can cause lots of performance damage. Be cautious with CSS3 features like text-shadow, box-shadow, border-radius, and animations, [especially when used together](http://www.html5rocks.com/en/tutorials/speed/css-paint-times/). We wrote a big blog post about performance [back in January 2014](http://blog.fogcreek.com/we-spent-a-week-making-trello-boards-load-extremely-fast-heres-how-we-did-it/). Much of this was due to layout thrashing caused by JavaScript, but we cut out some heavy styles like borders, gradients, and shadows, which helped a lot.


## 9. Further Reading

This styleguide was influenced by discussions about CSS around the web. Here’s some additional reading on CSS architecture, which might be helpful:

- [Medium’s CSS guidelines.](https://gist.github.com/fat/a47b882eb5f84293c4ed) I ~~stole~~ learned a lot from this.
- The BEM, or “block, element, modifier”, methodology is similar to our components. It is well explained in [this CSS Wizardry article](http://csswizardry.com/2013/01/mindbemding-getting-your-head-round-bem-syntax/).
- [RSCSS](http://rscss.io/index.html)
- [18F CSS Coding Styleguide](https://pages.18f.gov/frontend/css-coding-styleguide/)
- [“CSS At…” from CSS Tricks](http://css-tricks.com/css/). A big list of CSS practices at various companies.
