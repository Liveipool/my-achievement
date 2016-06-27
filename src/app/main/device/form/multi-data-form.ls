'use strict'
GFC.Widget.create 'edit', { # 如何安排增删改？
  module:
    name: 'app.multi-datas'
    schema: "中山大学.人机物智能融合实验室.设备"
    template-url: 'app/main/multi-data/form/ui.gfc.html'
    submit: !-> console.log "submit form"
}
