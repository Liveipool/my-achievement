module.exports =
  name: "病患表单"
  type: 'grid-form'
  # data: require '../../../../../../hcp-basic/bin/index' .广州.中山大学附属第六医院.病患
  data: require 'gfc-schema-hcp-basic' .广州.中山大学附属第六医院.病患

  columns-in-a-row: 10
  rows:
    * "档案号(2)            ,  姓名(2)     ,  性别(2)         ,    诊疗次数(2) ,   初诊时间(2)"
    * "最后诊疗时间(2)       ,  年龄(2)     ,  出生日期(2)      ,    住院号(2)   ,  影像号(2)  "
    * "身高(2)              ,  体重(2)     ,  血型(2)         ,    出生地(2)   ,  民族(2)    "
    * "身份证号(2)           ,  婚姻状况(2) ,  联系电话(2)      ,    联系地址(4)               "
