# hatena-blog-cli

[Hatena::Blog](https://hatenablog.com/) command line interface (unofficial).

## Installation

```bash
npm install --global hatena-blog-cli
```

## Example

```
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
```

## How to build

```bash
npm install
```

## License

[MIT](LICENSE)

## Badges

## Badges

[![Build Status][travis-badge]][travis]
[![Dependencies status][david-dm-badge]][david-dm]

[travis]: https://travis-ci.org/bouzuya/node-hatena-blog-cli
[travis-badge]: https://travis-ci.org/bouzuya/node-hatena-blog-cli.svg?branch=master
[david-dm]: https://david-dm.org/bouzuya/node-hatena-blog-cli
[david-dm-badge]: https://david-dm.org/bouzuya/node-hatena-blog-cli.png

## Author

[bouzuya][user] &lt;[m@bouzuya.net][email]&gt; ([https://bouzuya.net/][url])

[user]: https://github.com/bouzuya
[email]: mailto:m@bouzuya.net
[url]: https://bouzuya.net/
