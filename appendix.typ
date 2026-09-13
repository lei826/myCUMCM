#heading(numbering: none)[附录]

#heading(level: 2, numbering: none)[附录一：补充图表与运行口径]

以下图表均来自“国赛第四问”最终图表工程；代码和数据以桌面修订工程为准。保留用于解释模型、检验假设或展示对照的图，删除与主体重复的概念场景和技术路线图，不改变求解方法。

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

#heading(level: 2, numbering: none)[附录二：最新建模参考代码]

按“程序名称、文件来源、行号、等宽代码”形式列出核心实现。下列片段直接从最新工程源文件按函数边界读取，保留原行号；长行仅在排版中续行，行号栏“>”表示同一源代码行的延续。为控制附录长度，不重复列出导出界面和绘图样式代码。完整源文件位于随文code目录，正式结果表位于结果工作簿目录；依赖数据及全年缓存仍以桌面修订工程为运行基准。

其中build_lp为公共函数：第1问调用时禁止紧急购电，启用闭合条件并固定自然日24:00库存；不能将函数默认参数直接当作第1问配置。

#let listing(path, names) = {
  let record=json("data/code_excerpts.json").at(path)
  heading(level: 3, numbering: none, [#path])
  for entry in record {
    block(breakable: entry.display.len() > 26, inset: 5pt, stroke: 0.35pt)[
      #text(size: 9pt, weight: "bold")[#entry.name（源文件第#entry.start 行起）]
      #set par(first-line-indent: 0pt, leading: 2pt, spacing: 0pt)
      #show raw: set text(font: ("DejaVu Sans Mono", "SimSun"), size: 8pt)
      #table(columns: (24pt, 1fr), inset: (x: 0pt, y: 1pt), column-gutter: 5pt, stroke: none,
        ..entry.display.map(line => (
          text(font: "DejaVu Sans Mono", fill: gray, size: 7pt, if line.number == "↪" { ">" } else { line.number }),
          raw(line.text, theme: none, block: false),
        )).flatten(),
      )
    ]
    v(5pt)
  }
}
#listing("training.py", ())
#listing("q1_q2/code/utils.py", ())
#listing("q1_q2/code/q2_rolling.py", ())
#listing("q3/code/forecast_v5.py", ())
#listing("q3/code/dispatch_v5.py", ())
#listing("q4/code/dispatch.py", ())
