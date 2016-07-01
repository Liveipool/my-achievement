'use strict'
GFC.Widget.create 'edit', { # 如何安排增删改？
  module:
    name: 'app.patient'
    schema: "广州.中山大学附属第六医院.病患"
    submit: !-> console.log "submit form"
}
