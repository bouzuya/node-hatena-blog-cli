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
edit url: https://blog.hatena.ne.jp/bouzuya/bouzuya.hatenablog.com/atom/entry/17680117126990461664
title: special bouzuya entry
url: https://bouzuya.hatenablog.com/entry/2019/03/09/160527
```

## How to build

```bash
npm install
```

## License

[MIT](LICENSE)

## Badges

[![npm version][npm-badge-url]][npm-url]
[![Travis CI][travisci-badge-url]][travisci-url]
[![Dependencies status][david-dm-badge-url]][david-dm-url]

[david-dm-badge-url]: https://img.shields.io/david/bouzuya/node-hatena-blog-cli.svg
[david-dm-url]: https://david-dm.org/bouzuya/node-hatena-blog-cli
[npm-badge-url]: https://img.shields.io/npm/v/hatena-blog-cli.svg
[npm-url]: https://www.npmjs.com/package/hatena-blog-cli
[travisci-badge-url]: https://img.shields.io/travis/bouzuya/node-hatena-blog-cli.svg
[travisci-url]: https://travis-ci.org/bouzuya/node-hatena-blog-cli

## Author

[bouzuya][user] &lt;[m@bouzuya.net][email]&gt; ([https://bouzuya.net/][url])

[user]: https://github.com/bouzuya
[email]: mailto:m@bouzuya.net
[url]: https://bouzuya.net/
