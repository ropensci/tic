# tic & CI Client Packages - An Overview

## Introduction

Most of the setup work that needs to be done for specific CI systems is
handled by the respective R client packages such as
[{circle}](https://docs.ropensci/circle/). These enable the repo on the
CI system and ensure that deployment permissions are granted.

After everything has been set up, the rest of the work goes to {tic}.

- Creation of the CI YAML templates.
- Which steps are going to be run.
- Deployment: Yes/no

In essence,
[`tic::use_tic()`](https://docs.ropensci.org/tic/dev/reference/use_tic.md)
is a wrapper for creating CI YAML templates and setting up deployment on
the CI systems which is powered by the client packages.

## CI Client Packages

Currently, the following CI client packages exist:

- [{circle}](NA)

The client package for *travis* was archived in November 2020.

For *Appveyor* there is
[r-appveyor](https://github.com/krlmlr/r-appveyor) from Kirill Müller.
This project makes it possible in the first place to run R checks on
Appveyor but does not provide access to the *Appveyor* API and is not
used by {tic} currently. Also, it does not come with automation for
deployment setup. Appveyor support has been removed from {tic} in
December 2020 due to a strong focus on GitHub Actions.

For *GitHub Actions* there is
[{ghactions}](https://github.com/maxheld83/ghactions) from Max Held
which comes with functions helping to set up YAML templates and other
convenience. It does not provide API access and is not used by {tic}
currently.
