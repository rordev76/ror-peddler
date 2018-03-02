## Contributing

In the spirit of [free software][free-sw], **everyone** is encouraged to help
improve this project. Here are some ways *you* can contribute:

[free-sw]: http://www.fsf.org/licensing/essays/free-sw.html

* Use pre-release versions.
* Report bugs.
* Suggest new features.
* Write or edit documentation.
* Write specifications.
* Write code (**no patch is too small**: fix typos, add comments, clean up
  inconsistent whitespace).
* Refactor code.
* [Fix issues.][issues]
* Review patches.

[issues]: https://github.com/hakanensari/peddler/issues

## Submitting an Issue

We use the [GitHub issue tracker][issues] to track bugs and features. Before
submitting a bug report or feature request, check to make sure it hasn't
already been submitted. When submitting a bug report, please include a [Gist][]
that includes a stack trace and any details that may be necessary to reproduce
the bug, including your gem version, Ruby version, and operating system.
Ideally, a bug report should include a pull request with failing specs.

Do not submit issues that are not specific to Peddler. If you have questions on how to use MWS, find help on [Amazon's seller forum][forum] or [Stack Overflow][so].

[gist]: https://gist.github.com/
[forum]: https://sellercentral.amazon.com/forums/c/amazon-marketplace-web-service-mws/
[so]: https://stackoverflow.com/search?q=peddler+%5Bruby%5D+or+%5Bruby-on-rails%5D+or+%5Bamazon-mws%5D+answers%3A1..+score%3A0..

## Submitting a Pull Request
1. [Fork the repository.][fork]
2. [Create a topic branch.][branch]
3. Add tests for your unimplemented feature or bug fix.
4. Run `bundle exec rake test`. If your tests pass, return to step 3.
5. Implement your feature or bug fix.
6. Run `bundle exec rake`. If your tests fail, return to step 5.
7. Run `open coverage/index.html`. If your changes are not completely covered
   by your tests, return to step 3.
8. Commit and push your changes.
9. [Submit a pull request.][pr]

[fork]: http://help.github.com/fork-a-repo/
[branch]: http://learn.github.com/p/branching.html
[pr]: http://help.github.com/send-pull-requests/
