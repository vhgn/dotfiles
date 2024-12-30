#!/bin/bash
ls -d */ | xargs stow --dotfiles --restow $@
