data = require '../form/device-form.ui' .data
console.log "data: ", JSON.stringify data
module.exports =  
  name: '设备列表'
  type: 'datatable'
  data:  data
  # data: require 'gfc-schema-hcp-basic' .广州.中山大学附属第六医院.病患
  columns-in-a-row: 12

    # 控件声明DSL：名称#属性|过滤器@控件(布局)
    # '姓名@搜索栏(6.4居右), 初诊时间#时间@搜索栏(4), #添加病患@按钮(2)'

  table-head:
    '类型, 厂商, 型号, 使用者.姓名#使用者, 供应商.名称#供应商, 维修服务.名称#维修服务, 维修服务.电话#维修服务电话'
  
  footer:
    # "@每页行数选择器(4), @当前页数据位置信息(居右), @分页浏览按钮(居右)"
    "rt<'bottom'<'left'<'length'l>><'right'<'info'i><'pagination'p>>>" # data-table DSL https://datatables.net/reference/option/dom
