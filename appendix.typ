#import "tables.typ": *
#heading(numbering: none)[附录]
#heading(level: 2, numbering: none)[附录一：指定日期完整结果表]

第二问正文仅保留指定日期紧急购电汇总，其余第二至四问结果表列于本附录。购电表报告最终有效合同电量，不含紧急补购；全天费用包含紧急费及适用的调整费。合同电量与紧急电量之和为实际购电量。充放电表按自然日0:00—24:00统计，交易费用按附件144个左端点标签统计。各表保留题面列结构和合并单元格，展示舍入不参与复算。

#heading(level: 3, numbering: none)[第二问：计划购电与储能运行]
#result-days("q2", "问题二")
#heading(level: 3, numbering: none)[第三问：购电、储能与紧急电量]
#result-days("q3", "问题三")
#emergency("q3", "问题三")
#pagebreak()
#heading(level: 3, numbering: none)[第四问4-2：购电、储能与紧急电量]
#result-days("q42", "问题四4-2")
#emergency("q42", "问题四4-2")
#pagebreak()
#heading(level: 3, numbering: none)[第四问4-3：购电、储能与紧急电量]
#result-days("q43", "问题四4-3")
#emergency("q43", "问题四4-3")

#pagebreak()
#heading(level: 2, numbering: none)[附录二：补充图表]

以下图表来自“国赛第四问”最终图表工程，用于展示典型运行、对照实验与参数扰动。

#figure(image("figures/fig_load_calendar.pdf", width: 92%), caption: [全年日总负载日历热图：检验周节律])
#figure(image("figures/fig_pv_hovmoller.pdf", width: 83%), caption: [全年光伏出力时空分布])
#figure(image("figures/fig_forecast_decay.pdf", width: 88%), caption: [光伏预报误差随提前期变化])
#figure(image("figures/fig_q2_typical_days.pdf", width: 94%), caption: [问题二四个题定日期的运行轨迹])
#figure(image("figures/fig_q2_emergency_raster.pdf", width: 92%), caption: [问题二紧急购电事件分布])
#figure(image("figures/fig_drawio_mpc_timeline_v2.pdf", width: 94%), caption: [滚动决策时序与已执行合同冻结])
#figure(image("figures/fig_q3_value_dumbbell.pdf", width: 92%), caption: [问题三状态反馈及预报信息的顺序边际价值])
#figure(image("figures/fig_q3_ablation_bar.pdf", width: 90%), caption: [问题三预测、风险规则与信息刷新消融])
#figure(image("figures/fig_q4_method_heatmap.pdf", width: 91%), caption: [波动电价下各候选方法比较])
#figure(image("figures/fig_q4_info_value_diverging.pdf", width: 91%), caption: [同联合策略下预测电价相对真实价格已知的月度费用差])
#figure(image("figures/fig_sens_capacity_pareto.pdf", width: 90%), caption: [可用容量、功率与运行费用的关系])

#pagebreak()
#heading(level: 2, numbering: none)[附录三：完整建模工程代码]

本附录完整列出最终建模工程随文code目录中的全部41个Python源文件，不再截取函数片段。包括总入口、一月初始化、训练选择、数据读取、第一至四问预测与调度、结果导出和验证脚本；为完整保存工程，同时列出其中的既有报告生成辅助脚本。辅助脚本中的历史报告文字不作为当前论文结论，当前论文以正文及正式结果文件为准。图表绘制脚本另随交付包图表代码目录保存。

每个文件按原行号连续列出，跨页标注文件名及页段；长行只在显示中续行，行号栏“>”表示同一源代码行的延续。所有注释、导入、函数和主程序均保留，复制运行应使用随文原始.py文件而非带行号的排版文本。运行所需原始附件与全年缓存仍位于桌面修订工程，具体入口和依赖见随文交付说明。

其中build_lp为公共函数，第1问调用时禁止紧急购电、启用闭合条件并固定自然日24:00库存，不能把默认参数直接当作第1问配置。

#let codefiles = json("data/code_full.json")
#for record in codefiles {
  for (part, rows) in record.pages.enumerate() {
    pagebreak()
    block(breakable: false)[
      #text(size: 10pt, weight: "bold")[#record.path]
      #par(first-line-indent: 0pt)[#text(size: 9pt)[完整文件共#record.lines 行；第#(part+1)/#record.pages.len()页段]]
      #set par(first-line-indent: 0pt, leading: 1pt, spacing: 0pt)
      #show raw: set text(font: ("DejaVu Sans Mono", "SimSun"), size: 8pt)
      #table(columns: (28pt, 1fr), inset: (x: 0pt, y: 0.5pt), column-gutter: 5pt, stroke: none,
        ..rows.map(line => (
          text(font: "DejaVu Sans Mono", fill: gray, size: 7pt, line.number),
          raw(line.text, theme: none, block: false),
        )).flatten(),
      )
    ]
  }
}
