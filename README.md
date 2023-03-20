# Time Shift

This repository contains a sample Flutter application using Shorebird's CodePush solution.

This example is built using the [Flutter Particle Clock](https://github.com/miickel/flutter_particle_clock).

App icons generated from icon.png using [App Icon Generator](https://www.appicon.co/).

## Goal

The purpose of this app is to be a test-balloon for store approvals.  Currently it's only
been submitted to Google Play App Store, but we will eventually submit it to other stores.

## Design

Purpose is to have something worth code-pushing to.  In this case, we figured it might
be fun to have an app to which we could code-push a differnet clockface every hour.

Flutter ran a clock contest a few years back and there are numerous gorgeous examples
of clocks built with Flutter:
https://docs.flutter.dev/clock

Current built only has a single clock in it, but a straightforward expansion would
be to include multiple clockfaces controlled by a compile-time flag and then
write a script which builds N-different versions of the app for the N clock faces
and pushes a new one to Shorebird every hour.

Another feature I'd like to add is more prevelent display of the author's name
and link.  e.g. if you tap the clock it could say "@miickel" in the corner
and when you click on it it could open the original source in a browser window.

Patches welcome.
