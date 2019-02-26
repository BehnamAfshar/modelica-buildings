﻿within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Processes.Subsequences;
block ResetMinBypass
  "Sequence for reset minimum chilled water bypass flow setpoint"

  parameter Modelica.SIunits.Time aftByPasSetTim = 60;
  parameter Modelica.SIunits.VolumeFlowRate minFloDif = 0.01
    "Minimum flow rate difference to check if bybass flow achieves setpoint";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VBypas_flow(
    final min=0,
    final unit="m3/s",
    quantity="VolumeFlowRate") "Measured bypass flow rate"
    annotation (Placement(transformation(extent={{-200,-60},{-160,-20}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VBypas_setpoint(
    final min=0,
    final unit="m3/s",
    quantity="VolumeFlowRate") "Bypass flow setpoint"
    annotation (Placement(transformation(extent={{-200,-100},{-160,-60}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaCha
    "Indicate if there is stage change"
    annotation (Placement(transformation(extent={{-200,30},{-160,70}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uUpsDevSta
    "Status of resetting status of device before reset minimum bypass flow setpoint"
    annotation (Placement(transformation(extent={{-200,60},{-160,100}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yMinBypRes
    "Minimum chilled water flow bypass setpoint reset status"
    annotation (Placement(transformation(extent={{160,70},{180,90}}),
      iconTransformation(extent={{100,-10},{120,10}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Feedback floDif
    "Bypass flow rate difference"
    annotation (Placement(transformation(extent={{-140,-50},{-120,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Abs abs "Absolute value of input"
    annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys(
    final uLow=minFloDif-0.005,
    final uHigh=minFloDif+0.005)
    "Check if bypass achieves setpoint"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 "Logical not"
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));
  Buildings.Controls.OBC.CDL.Logical.And3 and1 "Logical and"
    annotation (Placement(transformation(extent={{120,70},{140,90}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim "Time after achiving setpoint"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
  Buildings.Controls.OBC.CDL.Logical.And and2 "Logical and"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold greEquThr(
    final threshold=aftByPasSetTim)
    "Check if it is 1 minute after new setpoint achieved"
    annotation (Placement(transformation(extent={{60,-50},{80,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg
    "Rising edge, output true at the moment when input turns from false to true"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Logical latch, maintain ON signal until condition changes"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));

equation
  connect(uUpsDevSta, and2.u1)
    annotation (Line(points={{-180,80},{-62,80}}, color={255,0,255}));
  connect(uStaCha, and2.u2)
    annotation (Line(points={{-180,50},{-120,50},{-120,72},{-62,72}},
      color={255,0,255}));
  connect(VBypas_flow, floDif.u1)
    annotation (Line(points={{-180,-40},{-142,-40}}, color={0,0,127}));
  connect(VBypas_setpoint, floDif.u2)
    annotation (Line(points={{-180,-80},{-130,-80},{-130,-52}},
      color={0,0,127}));
  connect(floDif.y, abs.u)
    annotation (Line(points={{-119,-40},{-102,-40}}, color={0,0,127}));
  connect(abs.y, hys.u)
    annotation (Line(points={{-79,-40},{-62,-40}}, color={0,0,127}));
  connect(hys.y, not2.u)
    annotation (Line(points={{-39,-40},{-22,-40}}, color={255,0,255}));
  connect(not2.y, tim.u)
    annotation (Line(points={{1,-40},{18,-40}}, color={255,0,255}));
  connect(tim.y, greEquThr.u)
    annotation (Line(points={{41,-40},{58,-40}}, color={0,0,127}));
  connect(and2.y, and1.u1)
    annotation (Line(points={{-39,80},{40,80},{40,88},{118,88}},
      color={255,0,255}));
  connect(and1.y,yMinBypRes)
    annotation (Line(points={{141,80},{170,80}}, color={255,0,255}));
  connect(hys.y, edg.u)
    annotation (Line(points={{-39,-40},{-30,-40},{-30,0},{-22,0}},
      color={255,0,255}));
  connect(uStaCha, not1.u)
    annotation (Line(points={{-180,50},{-120,50},{-120,30},{-102,30}},
      color={255,0,255}));
  connect(not1.y, lat.u0)
    annotation (Line(points={{-79,30},{-20,30},{-20,24},{39,24}},
      color={255,0,255}));
  connect(edg.y, lat.u)
    annotation (Line(points={{1,0},{20,0},{20,30},{39,30}},
      color={255,0,255}));
  connect(lat.y, and1.u2)
    annotation (Line(points={{61,30},{80,30},{80,80},{118,80}},
      color={255,0,255}));
  connect(greEquThr.y, and1.u3)
    annotation (Line(points={{81,-40},{100,-40},{100,72},{118,72}},
      color={255,0,255}));

annotation (
  defaultComponentName="minBypRes",
  Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          lineColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-96,88},{-36,74}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uUpsDevSta"),
        Text(
          extent={{-96,48},{-58,34}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uStaCha"),
        Text(
          extent={{32,8},{98,-8}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yMinBypRes"),
        Text(
          extent={{-98,-34},{-38,-48}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VBypas_flow"),
        Text(
          extent={{-98,-72},{-16,-86}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VBypas_setpoint")}),
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-160,-100},{160,100}})),
  Documentation(info="<html>
<p>
Block that generates minimum bypass flow reset status when there is 
stage-up command.
This development is based on ASHRAE RP-1711 Advanced Sequences of Operation for 
HVAC Systems Phase II – Central Plants and Hydronic Systems (Draft 4 on January 7, 
2019), section 5.2.4.18, part 5.2.4.18.2 and part 5.2.4.18.3.
</p>
<p>
When there is stage-up command (<code>uStaUp</code> = true) and the operating chillers 
have reduced the demand (<code>uChiDemRed</code> = true), 
check if the minimum bypass flow rate <code>VBypas_flow</code> has achieved 
its new set point <code>VBypas_setpoint</code>. 
After new setpoint is achieved, wait for 1 minute (<code>byPasSetTim</code>) to 
allow loop to stabilize. It will then set <code>yMinBypRes</code> to true.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 31, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ResetMinBypass;
