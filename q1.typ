#import "tables.typ": *
== 问题一的模型建立与求解

=== 模型建立

根据购电—充放电—库存之间的线性关系，设各时隙的购电量$g_t>=0$、充电输入$c_t$、放电输出$d_t$、未利用电量$w_t>=0$及末端库存$S_t$为连续决策变量，目标为
$ min_(g,c,d,w,S) C_1=sum_(t=1)^T p_t g_t. $ <eq-q1-objective>

供给端由外网、光伏和储能放电构成；未被负载消耗或储存的余电记为$w_t$。因此供需平衡与库存递推为
$ g_t+R_t+d_t=L_t+c_t+w_t, quad
  S_t=S_(t-1)+eta_c c_t-frac(d_t,eta_d). $ <eq-physical>
充电损耗作用于输入，放电损耗作用于储能抽取量，两者不能在单位换算时重复计入。代入设备参数，有
$ 1200<=S_t<=10800, quad 0<=c_t,d_t<=5000/6, quad eta_c=eta_d=0.9. $ <eq-bounds>

按前述左端点约定，$S_0$对应首个00:10区间开始前库存；首日缺失的00:00—00:10储能保持不变。题面自然日闭合与补足末时隙价值的周期连接分别为
$ S_0=6000, quad S_143=6000, quad S_144=6000. $ <eq-q1-boundary>
其中$S_143$是24:00的真实库存；$S_144$对应次日00:10，用于防止附件末格无代价放空储能。自然日储能表仍严格统计0:00—24:00，购电表按附件144格统计。上述时间口径与完整工作簿一致。

综上，@eq-q1-objective 在@eq-physical—@eq-q1-boundary 约束下构成确定性线性规划。目标函数与约束均不含变量乘积，允许以连续LP求解@boyd。

=== 模型求解

采用SciPy的HiGHS接口求解@highs。往返效率小于1并不意味着每个退化LP解都会自动互斥；但允许无成本未利用余电时，可等价消除同充同放。若$c_t,d_t>0$，令
$ Delta_t=min(c_t,d_t/0.81), quad
  (c'_t,d'_t,w'_t)=(c_t-Delta_t,d_t-0.81Delta_t,w_t+0.19Delta_t). $ <eq-cycle>
该变换使$c'_t d'_t=0$，不改变$g_t$、$S_t$与购电费用，且不破坏功率或容量上界。因此存在与松弛最优值相同的互斥解。另以含充放电二元互斥变量的MILP独立求解，费用与LP相同，为该论证提供数值核验。

LP的几何意义是沿费用降低方向移动至可行域边界；某一最优顶点可用于表示解，但不能据此声称最优解唯一。图中固定该时隙的其他状态，以购电和放电为坐标展示可行域截面。该二维图只用于解释局部约束，实际求解仍包含全天库存耦合。

#figure(image("figures/tikz_q1_feasible.pdf", width: 70%), caption: [问题一线性规划可行域截面]) <fig-q1-feasible>

=== 结果分析

最优单日购电费用为35126.9486元，购电量59482.6990 kWh；无储能方案分别为48052.0466元和61789.9 kWh。储能节费12925.0980元，比例为26.8981%，而购电量只下降约3.73%，说明主要收益来自购电时序调整，而非简单削减用电量。

#purchase(evidence.q1.table1_purchase.values(), evidence.q1.daily_purchase_kwh, evidence.q1.objective_total_cost, [微网在指定时间段的购电量及全天的购电量和购电费]) <tab-power-purchase>
#storage(evidence.q1.table2_storage.map(r => r.charge), evidence.q1.table2_storage.map(r => r.discharge), 6000, 6000, [储能设备在指定时间段的充放电量及0:00和24:00的储电量]) <tab-storage-schedule>

两表保持题面表1、表2的六列布局、时段顺序与底部合并单元格；电量单位为kWh，费用单位为元，展示值保留两位小数，计算使用未舍入数值。@tab-storage-schedule 的自然日充电总量20740.6661 kWh、放电总量16799.9396 kWh满足$0.9 sum c_t-sum d_t/0.9 approx 0$，与首末6000 kWh一致。

#figure(image("figures/fig_q1_dispatch_soc.pdf", width: 96%), caption: [问题一最优调度与储能状态]) <fig-q1-dispatch>

如@fig-q1-dispatch，储能在低价和光伏富余时段充电，在高价及净需求较大时放电。库存多次触及上下界，说明有限容量确实参与决定最优策略；功率上限则限制短时间内可搬移的电量。以不同顺序逐项恢复约束会改变费用增量的归因，故费用瀑布图仅作为固定恢复顺序下的分解，不能将其解释为独立的因果贡献。

为解释调度方向，考虑谷段输入1 kWh、随后在峰段输出$eta_c eta_d=0.81$ kWh。若两时段无其他活跃约束，则节费条件为$p_"low"<0.81p_"high"$。光伏富余的边际输入成本近于0，更宜优先储存；但容量已满或功率受限时仍会产生未利用电量。该局部条件解释了谷充峰放，不能替代包含完整负载、光伏及日闭合条件的LP求解。

以上结果提供后续问题的确定性基准。问题二至四面对预测误差和动态信息，不能直接复制本问以全年均值形成的调度轨迹，而需重新生成各时点可执行的合同。

#figure(image("figures/fig_q1_saving_waterfall.pdf", width: 80%), caption: [固定约束恢复顺序下的购电费用分解]) <fig-q1-waterfall>

充放电效率直接影响上述跨时段套利条件。下图在其余条件固定时重新求解各效率组合，展示模型对设备损耗的响应；扰动范围与定量结果见第七节。

#figure(image("figures/fig_sens_efficiency_contour.pdf", width: 65%), caption: [充放电效率变化下的最优费用]) <fig-efficiency>
