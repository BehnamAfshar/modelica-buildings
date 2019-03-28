﻿within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Processes.Subsequences;
block EnableChiIsoVal
  "Sequence of enable or disable chilled water isolation valve"

  parameter Integer nChi = 2
    "Total number of chiller, which is also the total number of chilled water isolation valve";
  parameter Modelica.SIunits.Time chaChiWatIsoTim = 300
    "Time to slowly change isolation valve";
  parameter Real iniValPos = 0
    "Initial valve position, if it needs to turn on chiller, the value should be 0";
  parameter Real endValPos = 1
    "Ending valve position, if it needs to turn on chiller, the value should be 1";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uChiWatIsoVal[nChi](
    each final unit="1",
    each final min=0,
    each final max=1) "Chilled water isolation valve position"
    annotation (Placement(transformation(extent={{-200,-120},{-160,-80}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput yUpsDevSta
    "Status of resetting status of device before enabling or disabling isolation valve"
    annotation (Placement(transformation(extent={{-200,-160},{-160,-120}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uNexChaChi
    "Index of next chiller that should change status"
    annotation (Placement(transformation(extent={{-200,-10},{-160,30}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaCha
    "Indicate if there is a stage up or stage down command"
    annotation (Placement(transformation(extent={{-200,-198},{-160,-158}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiWatIsoVal[nChi](
    each final unit="1",
    each final min=0,
    each final max=1) "Chiller chilled water isolation valve position"
    annotation (Placement(transformation(extent={{180,-50},{200,-30}}),
      iconTransformation(extent={{100,-10},{120,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yEnaChiWatIsoVal
    "Status of chiller chilled water isolation valve control: true=enabled valve is fully open"
    annotation (Placement(transformation(extent={{180,130},{200,150}}),
      iconTransformation(extent={{100,50},{120,70}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt[nChi](
    final k=chiInd) "Chiller index array"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));

protected
  final parameter Integer chiInd[nChi]={i for i in 1:nChi}
    "Chiller index, {1,2,...,n}";
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con7(
    final k=chaChiWatIsoTim) "Time to change chilled water isolation valve"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con8(final k=endValPos)
    "Ending valve position"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con6(final k=iniValPos)
    "Initial isolation valve position"
    annotation (Placement(transformation(extent={{-40,90},{-20,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con9(final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{0,90},{20,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Line lin1
    "Chilled water isolation valve setpoint"
    annotation (Placement(transformation(extent={{40,70},{60,90}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim
    "Count the time after changing up-stream device status"
    annotation (Placement(transformation(extent={{-100,70},{-80,90}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg
    "Rising edge, output true at the moment when input turns from false to true"
    annotation (Placement(transformation(extent={{-100,-150},{-80,-130}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Logical latch, maintain ON signal until condition changes"
    annotation (Placement(transformation(extent={{20,-180},{40,-160}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam[nChi]
    "Record the old chiller chilled water isolation valve status"
    annotation (Placement(transformation(extent={{-80,-110},{-60,-90}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep(final nout=nChi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{20,-150},{40,-130}})));
  Buildings.Controls.OBC.CDL.Logical.And and2 "Logical and"
    annotation (Placement(transformation(extent={{-40,-180},{-20,-160}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{-40,-210},{-20,-190}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi[nChi] "Logical switch"
    annotation (Placement(transformation(extent={{120,-50},{140,-30}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep1(final nout=nChi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{60,-180},{80,-160}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2[nChi] "Logical not"
    annotation (Placement(transformation(extent={{-20,-90},{0,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1[nChi] "Logical switch"
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi2[nChi] "Logical switch"
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu[nChi]
    "Check next enabling isolation valve"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerReplicator intRep(final nout=nChi)
    "Replicate integer input"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Buildings.Controls.OBC.CDL.Routing.RealReplicator reaRep(final nout=nChi)
    "Replicate real input"
    annotation (Placement(transformation(extent={{80,70},{100,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys3[nChi](
    each final uLow=0.025,
    each final uHigh=0.05) "Check if isolation valve is enabled"
    annotation (Placement(transformation(extent={{-120,210},{-100,230}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys4[nChi](
    each final uLow=0.925,
    each final uHigh=0.975) "Check if isolation valve is open more than 95%"
    annotation (Placement(transformation(extent={{-120,150},{-100,170}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3[nChi] "Logical not"
    annotation (Placement(transformation(extent={{-40,180},{-20,200}})));
  Buildings.Controls.OBC.CDL.Logical.Not not4[nChi] "Logical not"
    annotation (Placement(transformation(extent={{-40,150},{-20,170}})));
  Buildings.Controls.OBC.CDL.Logical.And and4[nChi] "Logical and"
    annotation (Placement(transformation(extent={{0,180},{20,200}})));
  Buildings.Controls.OBC.CDL.Logical.And and3[nChi] "Logical and"
    annotation (Placement(transformation(extent={{0,210},{20,230}})));
  Buildings.Controls.OBC.CDL.Logical.Or  or2[nChi] "Logicla or"
    annotation (Placement(transformation(extent={{40,210},{60,230}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd1(final nu=nChi)
    "Logical and"
    annotation (Placement(transformation(extent={{80,210},{100,230}})));
  Buildings.Controls.OBC.CDL.Logical.And3 and5
    "Check if the isolation valve has been fully open"
    annotation (Placement(transformation(extent={{140,130},{160,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys5(
    each final uLow=chaChiWatIsoTim - 1,
    each final uHigh=chaChiWatIsoTim + 1)
    "Check if it has past the target time of open CHW isolation valve "
    annotation (Placement(transformation(extent={{80,110},{100,130}})));

equation
  connect(uChiWatIsoVal, triSam.u)
    annotation (Line(points={{-180,-100},{-82,-100}}, color={0,0,127}));
  connect(con9.y, lin1.x1)
    annotation (Line(points={{21,100},{30,100},{30,88},{38,88}},
      color={0,0,127}));
  connect(con6.y, lin1.f1)
    annotation (Line(points={{-19,100},{-10,100},{-10,84},{38,84}},
      color={0,0,127}));
  connect(con7.y, lin1.x2)
    annotation (Line(points={{-19,50},{-10,50},{-10,76},{38,76}},
      color={0,0,127}));
  connect(con8.y, lin1.f2)
    annotation (Line(points={{21,50},{30,50},{30,72},{38,72}}, color={0,0,127}));
  connect(tim.y, lin1.u)
    annotation (Line(points={{-79,80},{38,80}}, color={0,0,127}));
  connect(yUpsDevSta, edg.u)
    annotation (Line(points={{-180,-140},{-102,-140}}, color={255,0,255}));
  connect(uStaCha, and2.u2)
    annotation (Line(points={{-180,-178},{-42,-178}}, color={255,0,255}));
  connect(edg.y, and2.u1)
    annotation (Line(points={{-79,-140},{-60,-140},{-60,-170},{-42,-170}},
      color={255,0,255}));
  connect(and2.y, lat.u)
    annotation (Line(points={{-19,-170},{19,-170}}, color={255,0,255}));
  connect(uStaCha, not1.u)
    annotation (Line(points={{-180,-178},{-80,-178},{-80,-200},{-42,-200}},
      color={255,0,255}));
  connect(not1.y, lat.u0)
    annotation (Line(points={{-19,-200},{0,-200},{0,-176},{19,-176}},
      color={255,0,255}));
  connect(lat.y, booRep1.u)
    annotation (Line(points={{41,-170},{58,-170}}, color={255,0,255}));
  connect(booRep1.y, swi.u2)
    annotation (Line(points={{81,-170},{100,-170},{100,-40},{118,-40}},
      color={255,0,255}));
  connect(swi.y, yChiWatIsoVal)
    annotation (Line(points={{141,-40},{190,-40}}, color={0,0,127}));
  connect(booRep.y, triSam.trigger)
    annotation (Line(points={{41,-140},{60,-140},{60,-120},{-70,-120},
      {-70,-111.8}}, color={255,0,255}));
  connect(and2.y, booRep.u)
    annotation (Line(points={{-19,-170},{0,-170},{0,-140},{18,-140}},
      color={255,0,255}));
  connect(booRep1.y, not2.u)
    annotation (Line(points={{81,-170},{100,-170},{100,-110},{-40,-110},
      {-40,-80},{-22,-80}}, color={255,0,255}));
  connect(not2.y, swi1.u2)
    annotation (Line(points={{1,-80},{20,-80},{20,-60},{58,-60}},
      color={255,0,255}));
  connect(triSam.y, swi1.u3)
    annotation (Line(points={{-59,-100},{40,-100},{40,-68},{58,-68}},
      color={0,0,127}));
  connect(swi1.y, swi.u3)
    annotation (Line(points={{81,-60},{90,-60},{90,-48},{118,-48}},
      color={0,0,127}));
  connect(uChiWatIsoVal, swi1.u1)
    annotation (Line(points={{-180,-100},{-140,-100},{-140,-52},{58,-52}},
      color={0,0,127}));
  connect(swi2.y, swi.u1)
    annotation (Line(points={{81,10},{100,10},{100,-32},{118,-32}},
      color={0,0,127}));
  connect(uNexChaChi, intRep.u)
    annotation (Line(points={{-180,10},{-82,10}}, color={255,127,0}));
  connect(intRep.y, intEqu.u1)
    annotation (Line(points={{-59,10},{-22,10}}, color={255,127,0}));
  connect(intEqu.y, swi2.u2)
    annotation (Line(points={{1,10},{58,10}}, color={255,0,255}));
  connect(lin1.y, reaRep.u)
    annotation (Line(points={{61,80},{78,80}}, color={0,0,127}));
  connect(lat.y, tim.u)
    annotation (Line(points={{41,-170},{50,-170},{50,-220},{-120,-220},
      {-120,80},{-102,80}}, color={255,0,255}));
  connect(reaRep.y, swi2.u1)
    annotation (Line(points={{101,80},{120,80},{120,50},{40,50},{40,18},
      {58,18}}, color={0,0,127}));
  connect(triSam.y, swi2.u3)
    annotation (Line(points={{-59,-100},{40,-100},{40,2},{58,2}},
      color={0,0,127}));
  connect(uChiWatIsoVal, hys4.u)
    annotation (Line(points={{-180,-100},{-140,-100},{-140,160},{-122,160}},
      color={0,0,127}));
  connect(uChiWatIsoVal, hys3.u)
    annotation (Line(points={{-180,-100},{-140,-100},{-140,220},{-122,220}},
      color={0,0,127}));
  connect(hys3.y, and3.u1)
    annotation (Line(points={{-99,220},{-2,220}}, color={255,0,255}));
  connect(hys4.y, and3.u2)
    annotation (Line(points={{-99,160},{-80,160},{-80,212},{-2,212}},
      color={255,0,255}));
  connect(hys4.y, not4.u)
    annotation (Line(points={{-99,160},{-42,160}}, color={255,0,255}));
  connect(hys3.y, not3.u)
    annotation (Line(points={{-99,220},{-60,220},{-60,190},{-42,190}},
      color={255,0,255}));
  connect(not4.y, and4.u2)
    annotation (Line(points={{-19,160},{-12,160},{-12,182},{-2,182}},
      color={255,0,255}));
  connect(not3.y, and4.u1)
    annotation (Line(points={{-19,190},{-2,190}}, color={255,0,255}));
  connect(and3.y, or2.u1)
    annotation (Line(points={{21,220},{38,220}}, color={255,0,255}));
  connect(and4.y, or2.u2)
    annotation (Line(points={{21,190},{30,190},{30,212},{38,212}},
      color={255,0,255}));
  connect(tim.y, hys5.u)
    annotation (Line(points={{-79,80},{-60,80},{-60,120},{78,120}},
      color={0,0,127}));
  connect(mulAnd1.y, and5.u1)
    annotation (Line(points={{101.7,220},{120,220},{120,148},{138,148}},
                                                     color={255,0,255}));
  connect(and5.y, yEnaChiWatIsoVal)
    annotation (Line(points={{161,140},{190,140}}, color={255,0,255}));
  connect(or2.y, mulAnd1.u)
    annotation (Line(points={{61,220},{78,220}}, color={255,0,255}));
  connect(conInt.y, intEqu.u2)
    annotation (Line(points={{-59,-20},{-40,-20},{-40,2},{-22,2}},
      color={255,127,0}));

  connect(hys5.y, and5.u3) annotation (Line(points={{101,120},{120,120},{120,132},
          {138,132}}, color={255,0,255}));
  connect(yUpsDevSta, and5.u2) annotation (Line(points={{-180,-140},{-130,-140},
          {-130,140},{138,140}}, color={255,0,255}));
annotation (
  defaultComponentName="enaChiIsoVal",
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-160,-240},{180,240}}),
          graphics={
          Rectangle(
          extent={{-158,238},{178,122}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Text(
          extent={{-38,184},{172,150}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Check if all enabled CHW isolation valves 
have been fully open")}),
    Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(extent={{-120,146},{100,108}},
          lineColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-100,-74},{-64,-86}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uStaCha"),
        Text(
          extent={{-98,-32},{-48,-46}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yUpsDevSta"),
        Text(
          extent={{-98,86},{-50,74}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="uNexEnaChi"),
        Text(
          extent={{-98,46},{-44,34}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uChiWatIsoVal"),
        Text(
          extent={{42,8},{96,-4}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yChiWatIsoVal"),
        Text(
          extent={{32,68},{96,52}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yEnaChiWatIsoVal")}),
 Documentation(info="<html>
<p>
Block updates chiller chilled water isolation valve enabling status when 
there is stage-up command. It will also generate status to indicate if the 
valve reset process has finished.
This development is based on ASHRAE RP-1711 Advanced Sequences of Operation for 
HVAC Systems Phase II – Central Plants and Hydronic Systems (Draft 4 on January 7, 
2019), section 5.2.4.18, part 5.2.4.18.5.
</p>
<p>
When there is stage-up command (<code>uStaUp</code>=true) and next chiller 
head pressure control has been enabled (<code>yEnaHeaCon</code>=true),
the chilled water isolation valve of next enabling chiller indicated 
by <code>uNexEnaChi</code> will be enabled. The valve will open slowly. 
For example, this could be accomplished by resetting the valve position X /seconds, 
where X = (1 - 0) / <code>turOnChiWatIsoTim</code>.  It will generate 
array <code>yChiWatIsoVal</code> which indicates chiller chilled water isolation 
valve position setpoint. <code>yEnaChiWatIsoVal</code> will be true when the 
enabled valves are fully open. 
</p>
</html>", revisions="<html>
<ul>
<li>
Febuary 4, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end EnableChiIsoVal;
