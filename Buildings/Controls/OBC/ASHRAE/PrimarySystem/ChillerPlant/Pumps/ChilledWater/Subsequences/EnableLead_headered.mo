﻿within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Subsequences;
block EnableLead_headered
  "Sequence for enabling lead pump of plants with headered primary chilled water pumps"
  parameter Integer nChi=2 "Total number of chiller CHW isolation valve";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiIsoVal[nChi]
    "Chilled water isolation valve status"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yLeaPum
    "Lead pump status"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
      iconTransformation(extent={{100,-10},{120,10}})));

protected
  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(final nu=nChi)
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch leaPumSta "Lead pump status"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(final k=true)
    "Logical true"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1(final k=false)
    "Logical false"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));

equation
  connect(uChiIsoVal, mulOr.u)
    annotation (Line(points={{-120,0},{-82,0},{-82,0},{-42,0}},color={255,0,255}));
  connect(mulOr.y,leaPumSta. u2)
    annotation (Line(points={{-18.3,0},{38,0}}, color={255,0,255}));
  connect(con.y,leaPumSta. u1)
    annotation (Line(points={{-19,40},{20,40},{20,8},{38,8}},color={255,0,255}));
  connect(con1.y,leaPumSta. u3)
    annotation (Line(points={{-19,-30},{20,-30},{20,-8},{38,-8}},
      color={255,0,255}));
  connect(leaPumSta.y, yLeaPum)
    annotation (Line(points={{61,0},{110,0}}, color={255,0,255}));

annotation (
  defaultComponentName="enaLeaChiPum",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,150},{100,110}},
          lineColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-94,12},{-40,-10}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uChiIsoVal"),
        Text(
          extent={{42,12},{96,-10}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yLeaPum")}),
   Diagram(coordinateSystem(preserveAspectRatio=false)),
   Documentation(info="<html>
<p>
Block that enable and disable leading primary chilled water pump, for plants
with headered primary chilled water pumps, 
according to ASHRAE RP-1711 Advanced Sequences of Operation for HVAC Systems Phase II –
Central Plants and Hydronic Systems (Draft 4 on January 7, 2019), 
section 5.2.6 Primary chilled water pumps, part 5.2.6.1 and section 5.2.6.2.
</p>
<p>
1. Primary chilled water pumps shall be lead-lag.
</p>
<p>
2. The lead primary chilled water pump shall be enabled when any chiller
CHW isolation valve <code>uChiIsoVal</code> is commanded open, shall be disabled
when chiller CHW isolation valves are commanded closed.
</p>
</html>", revisions="<html>
<ul>
<li>
January 28, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end EnableLead_headered;
