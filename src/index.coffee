#!/usr/bin/env coffee

import { unpack } from 'msgpackr'
import Conn from './seed-conn'
import CONFIG from "@rmw/config"
import BASE64 from 'urlsafe-base64'
import {FLAG_FILE} from '@rmw/fsrv/const'
import {FLAG_URL} from './flag.mjs'
import Fsrv from '@rmw/fsrv'


do =>
  conn = await Conn()

  fsrv = Fsrv "/Users/z/Downloads"

  conn.onMessage ({src, payload})=>
    flag = payload[0]
    if flag & FLAG_FILE
      console.log "file"
    else
      if FLAG_URL & flag
        [url,offset] = unpack(payload[1..])

        return await fsrv.read url, offset

    return ''

  console.log BASE64.encode Buffer.from(conn.addr,'hex')
