# Snowpack React

## FAQ

#### What is the mount option in `snowpack.config.js`?

It allows different folders to be treated differently.
Some folders require transpiling/processing etc, but should be used as-is.

#### Why use `snowpack bundle --watch --no-bundle` instead of `snowpack dev`?

Snowpack dev runs a standalone server independent of phoenix code. If phoenix code changes, assets will be stale.
