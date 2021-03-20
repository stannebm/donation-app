# Snowpack React

## Getting Started

This folder can be compiled separately from Phoenix, if you are a frontend developer
Otherwise, running `mix phx.server` will call the "watchers" function `node`, that in turn compiles this

## FAQ

#### What is the mount option in `snowpack.config.js`?

It allows different folders to be treated differently.
Some folders require transpiling/processing etc, but should be used as-is.

The significance is the eventual output of snowpack in `priv/static`.

#### Why use `snowpack bundle --watch --no-bundle` instead of `snowpack dev`?

Snowpack dev runs a standalone server independent of phoenix code. If phoenix code changes, assets will be stale.
