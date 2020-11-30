#!/usr/bin/env coffee

import {boot, seed} from '../src/seed'
do =>
  for await i from await boot()
    console.log await seed(i)
