import path from 'path'
import {ftruncate} from 'fs'
import fs from 'fs/promises'
import {FLAG_END} from '@rmw/fsrv/const'
import {FLAG_URL as _FLAG_URL} from './flag.mjs'
import { pack } from 'msgpackr'

FLAG_URL = Buffer.from [_FLAG_URL]

export default (conn, addr, url, out)=>
  await fs.mkdir(path.dirname(out), { recursive: true })
  offset = 0
  while true
    retry = 10

    while 1
      try
        console.log url, offset
        buf = await conn.send(
          addr
          Buffer.concat [
            FLAG_URL
            pack [
              url
              offset
            ]
          ]
          responseTimeout:60000
        )
        break
      catch err
        console.log err
        if not --retry
          return

    if 0 == buf.length
      break

    flag = buf[0]
    buf = Buffer.from buf[1..]

    if offset == 0
      if FLAG_END&flag
        await fs.writeFile out, buf
        return true
      else
        size = buf[...6].readUintBE(0,6)
        buf = buf[6..]
        size+=buf.length

        fd = await fs.open(out, "w")
        await new Promise(
          (resolve)=>
            ftruncate(
              fd.fd
              size
              (err)=>
                console.log "err", err
                resolve()
            )
        )
    else
      fd = await fs.open(out, "a")

    await fd.write(buf, 0, buf.length, offset)
    await fd.close()
    offset += buf.length
    # console.log buf.toString 'binary'

