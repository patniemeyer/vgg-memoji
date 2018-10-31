
# Generating Memoji from Photos

This is the source code used in my article about generating Memoji from photos.
Please refer to the original article for context:

https://patniemeyer.github.io/2018/10/29/generating-memoji-from-photos.html

## eval-memoji.lua

This script grabs screenshots from a specified region of the screen, scores them with VGG Face against a folder of reference photos, and saves each captured image to a folder naming the file with its score. The script waits for you to hit enter on the keyboard for each capture.

## compare-memoji-multi.lua

This script takes a folder of references and a folder of target photos and uses VGG Face to rank the targets based on the output of a selected layer of the network and a simple dot product similarity measure. The top three matching images are displayed along with their scores.

If you have a folder of ranked output from eval-memoji.lua representing e.g. a Memoji with each feature variation, you can run this script on that output folder to match new reference files or experiment with other similarity metrics.

# Installing on Mac OS

## Homebrew

If you don't have it yet, install the Homebrew package manager:

https://brew.sh/

## Torch

Clone the torch repo to a folder called `distro`.  (Some of the install scripts insist on finding this name in the path.)

`git clone https://github.com/torch/torch7.git ./distro`

Run the `install-deps` script.

If anything important reports as outdated you can use
 `brew upgrade package` to update it.

Run the `install` script.

Install loadcaffe for loading models:

`luarocks install loadcaffe`

If you have trouble with `qlua` insisting on version 4 of Qt you can switch your installed version to 4 with brew :

`brew switch qt 4.8.7_2`
