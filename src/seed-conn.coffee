import SEED from '@rmw/seed'
import * as BOOT from './boot'
import YAML from 'yaml'
import Conn from './conn'
import {randomBytes} from 'crypto'
import BASE64 from 'urlsafe-base64'
import CONFIG from "@rmw/config"
import console from './console'

export default =>
  {seed} = CONFIG
  if seed
    seedbin = BASE64.decode seed
  else
    seedbin = randomBytes(32)
    CONFIG.seed = BASE64.encode seedbin

  seedhex = Buffer.from(seedbin).toString('hex')

  for await [ip, port] from SEED.nkn BOOT
    try
      return await Conn(seedhex, ip, port)
    catch err
      console.trace err
      continue
    break

