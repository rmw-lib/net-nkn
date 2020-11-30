#!/usr/bin/env coffee

import nkn from 'nkn-sdk'
import {ip_port_str} from '@rmw/ip-port-bin'

export default (seed, ip, port)=>
  port = port or 30003
  client = new nkn.MultiClient({
    seed
    rpcServerAddr:"http://"+ip_port_str(ip, port)
  })
  new Promise (resolve, reject)=>
    timeout = setTimeout(
      =>
        reject()
      30000
    )
    client.onConnect =>
      clearTimeout(timeout)
      resolve client
