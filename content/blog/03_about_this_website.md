# The creation of this website

When I finish the first two articles on iOS development, I thought about how to share my content to others.
I initially thought about using Medium or other Content Management System (CMS) such as WordPress.
However, my friend talked about a static website hosting service **Netlify**, which allows users to create a webhook to their version control repository, runs a build script, then deploy it to the world.
As a geek, this is appealing...
The idea of drafting your content on my beloved text editor, committing it to Github, then have it automatically rolled out just gave me chills.
Thus, I follow such path: using a web hosting service, buy a domain, learn to code the whole website from scratch with `ReactJS`...

## The Hosting

For hosting, I use Netlify, which is simple but quite limited.
It offers custom build script capabilities and only delivers static sites, without active backend running.
Because my requirement is simple, I do not need to maintain dynamic content, so I feel okay using such service.

Initially, my repository only have a markdown file, and a folder for iOS projects, with no frontend website...
As a result, I test out Netlify service quickly using a simple script to convert markdown file to html, and had Netlify serve that file.

After 15 minutes, the site was up and running, with a wall of text and code blocks rendered poorly.
However, initial testing prove that this hosting strategy is sufficient to deploy my content.
The journey now begins...


## The Domain

The default domain name is hard to remember, so I headed over to `GoDaddy.com` and grab a more memorable domain name `bachld.xyz`.
Initially, I used *Login with Facebook* on GoDaddy and purchase such domain name.
However, I could not use it until I verify my email address.
Unfortunately, my Facebook email was created long ago, and I forgot all information regarding authorization of the email address...
As a result, I spent a long hour with GoDaddy customer service to switch the email to one of my current email address.
That worked out pretty well thanks to their supportive customer service staff (Yay!!).

After I was able to use the domain name, it is time to setup the DNS...
For some reasons, I was not able to setup the DNS correctly, accessing [www.bachld.xyz](https://www.bachld.xyz) is perfectly fine, but accessing [bachld.xyz](https://bachld.xyz) gives security warning.
However, when allowing *Proceeds anyway*, accessing both domain is fine.
I tried switching from using GoDaddy DNS to using Netlify DNS but it does not help...
This remains one of the thing I need to work on for a fix.
## The Frontend

The frontend website is made using ReactJS.
This is the first time I learn to create a website, I have to learn from the beginning: HTML, CSS, and JS.
However, I did not learn step-by-step, I only learn enough as I create the website.
I try to minimize the use of dependency and use as naked React as possible.

The frontend contains of a list of blogs with their description, clicking on each item will bring us to the detail page of the blog with its full content.
The detail page is rendered using Markdown.

The page is working as expected when loaded from the home page.
However, navigate directly to detail page resulted in Netlify's 404 page.

## Summary so far

In summary, the website is hosted statically using Netlify.
The frontend is created using ReactJS, and the content is rendered as Markdown.

There are two problems left: handling response when users go directly into detail page and handle security certificate problem when the users do not enter subdomain to the website (accessing [bachld.xyz](https://bachld.xyz) instead of [www.bachld.xyz](https://www.bachld.xyz).

## Redirects

As it turns out, configuring Netlify for routing is easy.
To accomodate single page application, I simply need to direct all request to `index.html`.
We can do that by simply adding Netlify `_redirects` file:
```
/* index.html 200
```

Which means: for any page, direct it to `index.html` with response code 200 OK.

