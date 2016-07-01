Ea-box = require './ea-box'

fs = require 'fs'

boxes = [new Ea-box "测试盒 #name", 'in-service' for name in [1 to 10]]
# console.log "boxes: ", JSON.stringify boxes

fs.write-file-sync __dirname + '/../src/app/data/test/boxes.json', JSON.stringify {boxes}

