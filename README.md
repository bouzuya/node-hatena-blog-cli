# hatena-blog-cli

[Hatena::Blog][blog] command life interface (unofficial).

## Installation

    $ npm install -g hatena-blog-cli

## Example

    $ # show usage
    $ hatena-blog --help

    $ # configure
    $ export HATENA_USERNAME='username'
    $ export HATENA_BLOG_ID='blog id'
    $ export HATENA_API_KEY='api key'

    $ # create an entry
    $ hatena-blog create --title 'special bouzuya entry' bouzuya.md
    title: special bouzuya entry
    url: http://bouzuya.hatenablog.com/entry/2014/08/31/202340

## License

[MIT](LICENSE)

## Author

[bouzuya][user] &lt;[m@bouzuya.net][mail]&gt; ([http://bouzuya.net][url])

## Badges

[![Build Status][travis-badge]][travis]
[![Dependencies status][david-dm-badge]][david-dm]

[blog]: http://hatenablog.com/
[travis]: https://travis-ci.org/bouzuya/node-hatena-blog-cli
[travis-badge]: https://travis-ci.org/bouzuya/node-hatena-blog-cli.svg?branch=master
[david-dm]: https://david-dm.org/bouzuya/node-hatena-blog-cli
[david-dm-badge]: https://david-dm.org/bouzuya/node-hatena-blog-cli.png
[user]: https://github.com/bouzuya
[mail]: mailto:m@bouzuya.net
[url]: http://bouzuya.net
