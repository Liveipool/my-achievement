gfc = require '../../../../../../hcp-basic/bin/index'
# gfc = require 'gfc-schema-hcp-basic'
b = gfc.basic

module.exports = 
  name: '设备表单'
  type: 'grid-form'
  data:  b.schema-definition-helper.create-based-on b, (b)-> # console.log "b.系统常用.引用用户: ", b.系统常用.引用用户 ; schema =
    id: "中山大学.人机物智能融合实验室.设备"
    description: "HCP系统中使用的设备信息"
    type: "object"
    properties:
      类型:   enum: ['工作站', '台式机', '笔记本', '显卡', '投影仪']
      厂商:   enum: ['IBM', 'HP', '华为', 'CISCO'] # TODO
      型号:   type: "string", pattern: "^\\S{1,50}$", faker: 'random.uuid'
      使用者:  b.系统常用.引用用户
      供应商:  b.公司
      维修服务:  b.公司 <<< required: ['名称', '电话']
      价格:    type: "string", faker: 'commerce.price'
      固定资产编号: gfc.中山大学.固定资产编号
      维修记录: 
        type: "array"
        items: 
          type: "object"
          properties:
            修理日期: b.日期.二十年内
            报修人: b.系统常用.引用用户
            状态: enum: ['报修待审', '维修中', '修好', '报废']
          required: ['修理日期', '报修人', '状态']
      使用记录: 
        type: "array"
        items:
          type: "object",
          properties:
            开始日期: b.日期.二十年内 
            结束日期: b.日期.二十年内
            使用人: b.系统常用.引用用户
            状态: enum: ['申请中', '使用中', '使用结束']
          required: ['开始日期', '使用人', '状态']
    required: ['类型', '厂商', '型号', '使用者', '供应商', '维修服务', '价格', '固定资产编号', '维修记录', '使用记录']

  columns-in-a-row: 10
  rows: # TODO: 厂商 + 型号
    * '类型(2)                ,  厂商(2)                ,  使用者.姓名#使用者(2)         ,    供应商.名称#供应商(2),   价格(2）'
    * '维修服务.名称#维修服务(2) ,  维修服务.电话#维修电话(2),  维修记录[]报修人@人员标签列表(2),    使用记录[]使用人(4)' 
