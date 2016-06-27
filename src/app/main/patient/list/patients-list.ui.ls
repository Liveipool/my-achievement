module.exports =  病患:
  type: 'datatable'
  data:  require '../form/patient-form.ui' .病患.data

  columns-in-a-row: 12

  header:
    # 控件声明DSL：名称#属性|过滤器@控件(布局)
    '姓名@搜索栏(6.4居右), 初诊时间#时间@搜索栏(4), #添加病患@按钮(2)'

  table-head:
    '姓名, 性别, 年龄, 出生地#城市/区, 初诊时间|短时间, 最后诊疗时间, 诊疗次数'
  
  footer:
    # "@每页行数选择器(4), @当前页数据位置信息(居右), @分页浏览按钮(居右)"
    "rt<'bottom'<'left'<'length'l>><'right'<'info'i><'pagination'p>>>" # data-table DSL https://datatables.net/reference/option/dom
