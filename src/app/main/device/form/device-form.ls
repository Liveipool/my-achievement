'use strict'
GFC.Widget.create 'edit', { # 如何安排增删改？
  module:
    name: 'app.device'
    schema: "中山大学.人机物智能融合实验室.设备"
    template-url: 'app/main/device/form/device-form.ui.html'
    submit: !-> console.log "submit form"
}
