#!/usr/bin/env coffee

import down from './down'
import Conn from './seed-conn'
import CONFIG from "@rmw/config"
import BASE64 from 'urlsafe-base64'
import path from 'path'

do =>
  conn = await Conn()
  addr = "9AUn_bbzb6EkpQSjpvYWM_exVXM42LEjijXG47YUGlY"
  addr = BASE64.decode(addr).toString 'hex'

  for url in [
    "desktop.ini"
    "data.csv"
  ]
    console.log await down(conn, addr, url, path.join("/tmp/rmw", url))
  process.exit()
  # conn.onMessage ({src, payload})=>
  #   console.log src, payload
  #
  # console.log BASE64.encode Buffer.from(conn.addr,'hex')
