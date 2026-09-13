#let evidence = json("data/evidence.json")
#let fmt(x) = {
  let s=str(calc.round(x, digits: 2))
  let parts=s.split(".")
  if parts.len()==1 { s+".00" } else { parts.at(0)+"."+parts.at(1)+(if parts.at(1).len()==1 { "0" } else { "" }) }
}
#let purchase-times = ("10:00-10:10", "12:00-12:10", "14:00-14:10", "16:00-16:10", "18:00-18:10", "20:00-20:10")
#let windows = ("0:00-4:00", "4:00-8:00", "8:00-12:00", "12:00-16:00", "16:00-20:00", "20:00-24:00")
#let purchase(values, total, cost, caption) = figure(
  text(size: 9.5pt)[#table(
    columns: (1.35fr, 1fr, 1.35fr, 1fr, 1.35fr, 1fr),
    align: center + horizon, inset: (x: 2pt, y: 3pt), stroke: 0.5pt,
    table.header([时间段], [购电量], [时间段], [购电量], [时间段], [购电量]),
    ..range(6).map(i => (purchase-times.at(i), fmt(values.at(i)))).flatten(),
    table.cell(colspan: 2)[全天购电量], fmt(total),
    table.cell(colspan: 2)[全天购电费], fmt(cost),
  )], caption: figure.caption(position: top, caption),
)
#let storage(a, b, s0, s24, caption) = figure(
  text(size: 9.5pt)[#table(
    columns: (1.35fr, 1fr, 1fr, 1.35fr, 1fr, 1fr),
    align: center + horizon, inset: (x: 2pt, y: 3pt), stroke: 0.5pt,
    table.header([时间段], [充电量], [放电量], [时间段], [充电量], [放电量]),
    ..range(6).map(i => (windows.at(i), fmt(a.at(i)), fmt(b.at(i)))).flatten(),
    table.cell(colspan: 2)[0:00 储电量], fmt(s0),
    table.cell(colspan: 2)[24:00 储电量], fmt(s24),
  )], caption: figure.caption(position: top, caption),
)
#let dates = ("2025-03-20", "2025-06-21", "2025-09-23", "2025-12-21")
#let result-days(branch, name) = {
  for date in dates {
    let row = evidence.series.at(branch).dates.at(date)
    block(breakable: false)[
      #purchase(row.contract_slots, row.contract_total, row.cost, [#name，#date：指定时段购电量及全天汇总])
      #storage(row.charge, row.discharge, row.S00, row.S24, [#name，#date：自然日充放电与边界储电量])
    ]
  }
}
#let emergency(branch, name) = {
  let rows = evidence.series.at(branch).dates
  let n = calc.max(3, ..dates.map(d => rows.at(d).events.len()))
  figure(
    text(size: 9pt)[#table(
      columns: (1.45fr, 0.85fr) * 4,
      align: center + horizon, inset: (x: 1.5pt, y: 3pt), stroke: 0.5pt,
      table.header(
        ..("2025.3.20", "2025.6.21", "2025.9.23", "2025.12.21").map(d => table.cell(colspan: 2, d)),
        ..([时间段], [购电量]) * 4,
      ),
      ..range(n).map(i => dates.map(d => {
        let es = rows.at(d).events
        if i < es.len() { (es.at(i).at(0), fmt(es.at(i).at(1))) } else { ([-], [-]) }
      }).flatten()).flatten(),
    )], caption: figure.caption(position: top, [#name：微网在指定日期的紧急购电量]),
  )
}
