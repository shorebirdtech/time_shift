# Time Shift

This repository contains a sample Flutter application using Shorebird's CodePush solution.

This example is built using the [Flutter Particle Clock](https://github.com/miickel/flutter_particle_clock).

App icons generated from icon.png using [App Icon Generator](https://www.appicon.co/).

## Goal

The purpose of this app is to be a test-balloon for store approvals.  Currently it's only
been submitted to Google Play App Store, but we will eventually submit it to other stores.

* [Google Play App Store](https://play.google.com/store/apps/details?id=dev.shorebird.u_shorebird_clock)

## Design

Purpose is to have something worth code-pushing to.  In this case, we figured it might
be fun to have an app to which we could code-push a different clockface every hour.

Flutter ran a clock contest a few years back and there are numerous gorgeous examples
of clocks built with Flutter:
https://docs.flutter.dev/clock

The current build contains two clocks. It is currently hard coded to show the Particle
Clock, but a straightforward expansion would be to control which clock face is shown
with a compile-time flag and then write a script which builds N-different versions of
the app for the N clock faces and pushes a new one to Shorebird every hour.

Another feature I'd like to add is more prevalent display of the author's name
and link.  e.g. if you tap the clock it could say "@miickel" in the corner
and when you click on it it could open the original source in a browser window.

Patches welcome.
