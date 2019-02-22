within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Processes.Subsequences;
block EnableCWPump
  "Start the next condenser water pump and/or change condenser water pump speed"

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uUpDevSta
    "Status of resetting status of device before enabling or disabling condenser water pump"
    annotation (Placement(transformation(extent={{-160,60},{-120,100}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaUp
    "Indicate if there is stage-up command"
    annotation (Placement(transformation(extent={{-160,20},{-120,60}}),
      iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaDow
    "Indicate if there is stage-down command"
    annotation (Placement(transformation(extent={{-160,-60},{-120,-20}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uSta
    "Current stage index"
    annotation (Placement(transformation(extent={{-160,-100},{-120,-60}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput ySta
    "Stage for enabling condenser water pumps"
    annotation (Placement(transformation(extent={{120,30},{140,50}}),
      iconTransformation(extent={{100,-10},{120,10}})));

protected
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea
    "Convert integer input to real output"
    annotation (Placement(transformation(extent={{-100,-90},{-80,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi "Logical switch"
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
  Buildings.Controls.OBC.CDL.Logical.And and2 "Logicla and"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1 "Logical switch"
    annotation (Placement(transformation(extent={{0,70},{20,90}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar(
    final p=-1, final k=1)
    "One stage lower than current stage"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Buildings.Controls.OBC.CDL.Logical.And and1 "Logicla and"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar1(
    final p=1,
    final k=1) "One stage higher than current stage"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi2 "Logical switch"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi3 "Logical switch"
    annotation (Placement(transformation(extent={{40,-50},{60,-30}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    "Convert integer input to real output"
    annotation (Placement(transformation(extent={{80,30},{100,50}})));

equation
  connect(uSta, intToRea.u)
    annotation (Line(points={{-140,-80},{-102,-80}}, color={255,127,0}));
  connect(uUpDevSta, and2.u1)
    annotation (Line(points={{-140,80},{-82,80}}, color={255,0,255}));
  connect(uStaUp, and2.u2)
    annotation (Line(points={{-140,40},{-100,40},{-100,72},{-82,72}},
      color={255,0,255}));
  connect(and2.y, swi1.u2)
    annotation (Line(points={{-59,80},{-2,80}}, color={255,0,255}));
  connect(addPar.y, swi1.u3)
    annotation (Line(points={{-19,60},{-10,60},{-10,72},{-2,72}},
      color={0,0,127}));
  connect(intToRea.y, swi1.u1)
    annotation (Line(points={{-79,-80},{-50,-80},{-50,88},{-2,88}},
                color={0,0,127}));
  connect(intToRea.y, addPar.u)
    annotation (Line(points={{-79,-80},{-50,-80},{-50,60},{-42,60}},
      color={0,0,127}));
  connect(uUpDevSta, and1.u1) annotation (Line(points={{-140,80},{-110,80},{-110,
          0},{-82,0}}, color={255,0,255}));
  connect(uStaDow, and1.u2) annotation (Line(points={{-140,-40},{-100,-40},{-100,
          -8},{-82,-8}}, color={255,0,255}));
  connect(addPar1.y, swi2.u3) annotation (Line(points={{-19,-20},{-10,-20},{-10,
          -8},{-2,-8}}, color={0,0,127}));
  connect(intToRea.y, addPar1.u) annotation (Line(points={{-79,-80},{-50,-80},{-50,
          -20},{-42,-20}}, color={0,0,127}));
  connect(and1.y, swi2.u2)
    annotation (Line(points={{-59,0},{-2,0}}, color={255,0,255}));
  connect(intToRea.y, swi2.u1) annotation (Line(points={{-79,-80},{-50,-80},{-50,
          8},{-2,8}}, color={0,0,127}));
  connect(uStaUp, swi.u2)
    annotation (Line(points={{-140,40},{38,40}}, color={255,0,255}));
  connect(swi1.y, swi.u1) annotation (Line(points={{21,80},{30,80},{30,48},{38,48}},
        color={0,0,127}));
  connect(uStaDow, swi3.u2)
    annotation (Line(points={{-140,-40},{38,-40}}, color={255,0,255}));
  connect(swi2.y, swi3.u1) annotation (Line(points={{21,0},{30,0},{30,-32},{38,-32}},
        color={0,0,127}));
  connect(intToRea.y, swi3.u3) annotation (Line(points={{-79,-80},{-50,-80},{-50,
          -48},{38,-48}}, color={0,0,127}));
  connect(swi3.y, swi.u3) annotation (Line(points={{61,-40},{70,-40},{70,20},{
          30,20},{30,32},{38,32}},
                                color={0,0,127}));
  connect(swi.y, reaToInt.u)
    annotation (Line(points={{61,40},{78,40}}, color={0,0,127}));
  connect(reaToInt.y, ySta)
    annotation (Line(points={{101,40},{130,40}}, color={255,127,0}));

annotation (
  defaultComponentName="enaNexCWP",
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-120,-100},{120,100}})),
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
          extent={{-98,-74},{-76,-86}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="uSta"),
        Text(
          extent={{-98,88},{-50,72}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uMinBypRes"),
        Text(
          extent={{-98,28},{-64,16}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uStaUp"),
        Text(
          extent={{76,8},{98,-4}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="ySta"),
        Text(
          extent={{-98,-12},{-60,-24}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uStaDow")}),
  Documentation(info="<html>
<p>
This block generates stage signal as input to condenser water pump block. 
</p>
<ul>
<li>
When there is no stage up command (<code>uStaUp</code> = false), it outputs 
current stage.
</li>
<li>
When there is stage up command (<code>uStaUp</code> = true) which means current 
stage has changed up to new stage,  and the minimum bypass flow has not been 
reset (<code>uMinBypSet</code> = false), it outputs previous stage 
(<code>ySta</code> = <code>uSta</code> - 1).
</li>
<li>
When there is stage up command (<code>uStaUp</code> = true)  and the minimum 
bypass flow has been reset (<code>uMinBypSet</code> = true), it outputs 
current stage so to enable new condenser water pump for current stage.
</li>
</ul>
</html>",
revisions="<html>
<ul>
<li>
Febuary 4, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end EnableCWPump;
