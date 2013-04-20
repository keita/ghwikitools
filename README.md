# ghwikitools

ghwikitools is a set of GitHub wiki management tools.

## Functions

- Snippets
- Internationalization

## Installation

    gem install ghwikitools

## Snippets

Snippets are re-usage texts. For example, there is a page("Test.md") with metadata that is formed as two Markdown comments.

    <!-- >>> Header -->
    
    <!-- <<< Header -->
    
    This is a page.

This page embeds "Header" snippet. The snippet is written as ERB file at "snippet/Header.md" in the GitHub wiki cloned repository.

    This is a header of [[<%= @page.wikiname %>]].

ghwikitools updates the page as follows:

    <!-- >>> Header -->
    
    This is a header of [[Test]].
    
    <!-- <<< Header -->
    
    This is a page.

There are header and footer snippets as default. You can make snippets as you like.

### Internationalization

GitHub wiki doesn't support internationalization directly, but you can use ghwikitools as internationalization system. This can do with the following convenstion:

- wikiname with language code like "Test.ja" is Japanese version of "Test" page
- make Header snippet as language links
- you update wiki pages with ghwikitools when new pages are appended

Header file is written like this:

    Languages: [[English|<%= @page.wikiname %>]] | [[日本語|<%= @page.wikiname(:ja) %>]]

## Usage

### List

   ghwikitools list

This command shows all ghwikitools commands.

### Update

    ghwikitools update

This command inserts header and footer metadata, and updates all snippets.

## Licence

ghwikitools is free software distributed under MIT licence.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
