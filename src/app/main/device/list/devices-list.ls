'use strict'
GFC.Widget.create 'list', { 
  module:
    name: 'app.devices', 
    schema: "中山大学.人机物智能融合实验室.设备"
    template-url: 'app/main/device/list/ui.gfc.html'
    item-state: 'app.device'

  menu:
    title : '设备列表' 
    image : '/assets/images/menu/test-plan.svg'
}
