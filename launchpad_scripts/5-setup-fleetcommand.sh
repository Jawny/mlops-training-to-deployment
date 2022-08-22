#!/bin/bash
# Create a Fleet Command location
ngc fleet-command location create --address "launchpad address" --version "1.18.0" --desc "launchpad location" joliao-launchpad
# Add a system to your Fleet Command Location
ngc fleet-command location add-system joliao-launchpad:launchpad-system --desc "launchpad system"