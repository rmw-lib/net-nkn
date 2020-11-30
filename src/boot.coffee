#!/usr/bin/env coffee

import {ip_port_str, str_ip_port} from '@rmw/ip-port-bin'
import axios from '@rmw/axios'
import console from './console'
import {randomBytes} from 'crypto'
import {thisdir} from '@rmw/thisfile'
import {dirname, join} from 'path'
import sodium from 'libsodium-wrappers'
import fsline from '@rmw/fsline'

DIR = dirname thisdir `import.meta`

export boot = ->
  for await i from fsline(join(DIR, 'seed/nkn.csv'))
    yield i.split(":")

  i = 10
  while --i>0
    id = (""+i).padStart(4,"0")
    yield ["mainnet-seed-#{id}.nkn.org"]

export seed = (...args)=>
  await sodium.ready
  seed = _seed
  _seed.apply _seed, args

DEFAULT_PORT = 30003
SUFFIX = ":"+DEFAULT_PORT

export addressNew = =>
  s = randomBytes 32
  key = sodium.crypto_sign_seed_keypair s
  Buffer.from(key.publicKey).toString('hex')

_seed = (ip, port)=>
  url = "http://"+ip_port_str(ip,port or DEFAULT_PORT)
  try
    {data} = await axios.post(
      url
      {
        id: 'nkn-sdk-js',
        jsonrpc: '2.0',
        method: 'getwsaddr',
        params:{
          address:addressNew()
        }
      }
      {
        retry:1
        timeout:3000
      }
    )
  catch err
    if err.code
      console.error err.code, url
    else
      console.error err
    return
  {result} = data
  addr = result?.rpcAddr
  if not addr
    return
  if addr.endsWith SUFFIX
    addr = addr[...-SUFFIX.length]
  str_ip_port(addr)

