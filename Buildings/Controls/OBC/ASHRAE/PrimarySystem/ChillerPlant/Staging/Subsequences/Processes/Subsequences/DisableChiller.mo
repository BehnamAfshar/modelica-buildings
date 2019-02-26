within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Processes.Subsequences;
block DisableChiller "Sequence for disabling chiller"

  parameter Integer nChi = 2 "Total number of chillers";
  parameter Modelica.SIunits.Time proOnTim = 300
    "Enabled chiller operation time to indicate if it is proven on";

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uNexEnaChi
    "Index of next enabling chiller"
    annotation (Placement(transformation(extent={{-240,180},{-200,220}}),
      iconTransformation(extent={{-140,80},{-100,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaDow "Indicate if there is stage-down command"
    annotation (Placement(transformation(extent={{-240,120},{-200,160}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uEnaChiWatIsoVal
    "Status of chiller chilled water isolation valve control: true=enabled valve is fully open"
    annotation (Placement(transformation(extent={{-240,90},{-200,130}}),
      iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChi[nChi]
    "Chiller status: true=ON"
     annotation (Placement(transformation(extent={{-240,60},{-200,100}}),
       iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOnOff
    "Indicate if the stage require one chiller to be enabled while another is disabled"
    annotation (Placement(transformation(extent={{-240,-140},{-200,-100}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uNexDisChi
    "Next disabling chiller when there is any stage up that need one chiller on and another off"
    annotation (Placement(transformation(extent={{-240,-90},{-200,-50}}),
      iconTransformation(extent={{-140,-120},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChi[nChi]
    "Chiller enabling status"
    annotation (Placement(transformation(extent={{200,-130},{220,-110}}),
      iconTransformation(extent={{100,-10},{120,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yReaDemLim
    "Release demand limit"
    annotation (Placement(transformation(extent={{200,-70},{220,-50}}),
      iconTransformation(extent={{100,-90},{120,-70}})));

protected
  final parameter Integer chiInd[nChi]={i for i in 1:nChi}
    "Chiller index, {1,2,...,n}";
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi[nChi] "Logical switch"
    annotation (Placement(transformation(extent={{100,190},{120,210}})));
  Buildings.Controls.OBC.CDL.Logical.And                        and2
    annotation (Placement(transformation(extent={{-160,130},{-140,150}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep(final nout=nChi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{-100,130},{-80,150}})));
  Buildings.Controls.OBC.CDL.Logical.And and1[nChi] "Logical and"
    annotation (Placement(transformation(extent={{-40,190},{-20,210}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con[nChi](
    each final k=true) "True constant"
    annotation (Placement(transformation(extent={{-40,220},{-20,240}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold greEquThr3(
    final threshold=proOnTim)
    "Check the newly enabled chiller being operated by more than 5 minutes"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[nChi]
    "Convert boolean input to real output"
    annotation (Placement(transformation(extent={{-100,70},{-80,90}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold greEquThr[nChi](
    each final threshold=0.5)
    "Convert real input to boolean output"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi1[nChi]
    "Logical switch"
    annotation (Placement(transformation(extent={{100,-40},{120,-20}})));
  Buildings.Controls.OBC.CDL.Logical.And and3[nChi] "Logical and"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1[nChi](
    each final k=false) "False constant"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi2[nChi]
    "Logical switch"
    annotation (Placement(transformation(extent={{160,20},{180,40}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerReplicator intRep(final nout=nChi)
    "Replicate integer input"
    annotation (Placement(transformation(extent={{-160,190},{-140,210}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu[nChi]
    "Check next enabling isolation valve"
    annotation (Placement(transformation(extent={{-100,190},{-80,210}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim
    "Count the time after new chiller has been enabled"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam[nChi]
    "Record the old chiller chilled water isolation valve status"
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep1(final nout=nChi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg
    "Rising edge, output true at the moment when input turns from false to true"
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep2(final nout=nChi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep3(final nout=nChi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{80,20},{100,40}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt[nChi](
    final k=chiInd) "Chiller index array"
    annotation (Placement(transformation(extent={{-160,160},{-140,180}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerReplicator intRep1(final nout=nChi)
    "Replicate integer input"
    annotation (Placement(transformation(extent={{-140,-80},{-120,-60}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu1[nChi]
    "Check next enabling isolation valve"
    annotation (Placement(transformation(extent={{-100,-80},{-80,-60}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep4(final nout=nChi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{-100,-170},{-80,-150}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg1
    "Rising edge, output true at the moment when input turns from false to true"
    annotation (Placement(transformation(extent={{-100,-250},{-80,-230}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1[nChi]
    "Convert boolean input to real output"
    annotation (Placement(transformation(extent={{-100,-220},{-80,-200}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam1[nChi]
    "Record the old chiller chilled water isolation valve status"
    annotation (Placement(transformation(extent={{-20,-220},{0,-200}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep5(final nout=nChi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{-60,-250},{-40,-230}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold greEquThr1[nChi](
    each final threshold=0.5)
    "Convert real input to boolean output"
    annotation (Placement(transformation(extent={{40,-220},{60,-200}})));
  Buildings.Controls.OBC.CDL.Logical.And and4[nChi] "Logical and"
    annotation (Placement(transformation(extent={{40,-190},{60,-170}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con2[nChi](
    each final k=false)
    "False constant"
    annotation (Placement(transformation(extent={{40,-160},{60,-140}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi3[nChi]
    "Logical switch"
    annotation (Placement(transformation(extent={{100,-190},{120,-170}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi4[nChi]
    "Logical switch"
    annotation (Placement(transformation(extent={{160,-130},{180,-110}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep6(
    final nout=nChi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{40,-130},{60,-110}})));

equation
  connect(uNexEnaChi,intRep. u)
    annotation (Line(points={{-220,200},{-162,200}}, color={255,127,0}));
  connect(intRep.y,intEqu. u1)
    annotation (Line(points={{-139,200},{-102,200}}, color={255,127,0}));
  connect(uEnaChiWatIsoVal,and2. u2)
    annotation (Line(points={{-220,110},{-170,110},{-170,132},{-162,132}},
      color={255,0,255}));
  connect(uStaDow, and2.u1)
    annotation (Line(points={{-220,140},{-162,140}}, color={255,0,255}));
  connect(and2.y,booRep. u)
    annotation (Line(points={{-139,140},{-102,140}}, color={255,0,255}));
  connect(intEqu.y,and1. u1)
    annotation (Line(points={{-79,200},{-42,200}},  color={255,0,255}));
  connect(booRep.y,and1. u2)
    annotation (Line(points={{-79,140},{-60,140},{-60,192},{-42,192}},
      color={255,0,255}));
  connect(and1.y,logSwi. u2)
    annotation (Line(points={{-19,200},{98,200}}, color={255,0,255}));
  connect(con.y,logSwi. u1)
    annotation (Line(points={{-19,230},{0,230},{0,208},{98,208}}, color={255,0,255}));
  connect(tim.y,greEquThr3. u)
    annotation (Line(points={{-79,-30},{-62,-30}}, color={0,0,127}));
  connect(uChi,booToRea. u)
    annotation (Line(points={{-220,80},{-102,80}}, color={255,0,255}));
  connect(and2.y,edg. u)
    annotation (Line(points={{-139,140},{-120,140},{-120,50},{-102,50}},
      color={255,0,255}));
  connect(booToRea.y,triSam. u)
    annotation (Line(points={{-79,80},{-22,80}},color={0,0,127}));
  connect(edg.y,booRep1. u)
    annotation (Line(points={{-79,50},{-62,50}}, color={255,0,255}));
  connect(booRep1.y,triSam. trigger)
    annotation (Line(points={{-39,50},{-10,50},{-10,68.2}}, color={255,0,255}));
  connect(triSam.y,greEquThr. u)
    annotation (Line(points={{1,80},{18,80}}, color={0,0,127}));
  connect(greEquThr.y,logSwi. u3)
    annotation (Line(points={{41,80},{60,80},{60,192},{98,192}},
      color={255,0,255}));
  connect(and2.y,tim. u)
    annotation (Line(points={{-139,140},{-120,140},{-120,-30},{-102,-30}},
      color={255,0,255}));
  connect(greEquThr3.y,booRep2. u)
    annotation (Line(points={{-39,-30},{-22,-30}}, color={255,0,255}));
  connect(booRep2.y,and3. u1)
    annotation (Line(points={{1,-30},{38,-30}}, color={255,0,255}));
  connect(and3.y,logSwi1. u2)
    annotation (Line(points={{61,-30},{98,-30}}, color={255,0,255}));
  connect(con1.y,logSwi1. u1)
    annotation (Line(points={{61,0},{80,0},{80,-22},{98,-22}},
      color={255,0,255}));
  connect(uChi,logSwi1. u3)
    annotation (Line(points={{-220,80},{-160,80},{-160,-48},{80,-48},{80,-38},
      {98,-38}},  color={255,0,255}));
  connect(booRep3.y,logSwi2. u2)
    annotation (Line(points={{101,30},{158,30}},   color={255,0,255}));
  connect(logSwi1.y,logSwi2. u3)
    annotation (Line(points={{121,-30},{140,-30},{140,22},{158,22}},
      color={255,0,255}));
  connect(logSwi.y,logSwi2. u1)
    annotation (Line(points={{121,200},{140,200},{140,38},{158,38}},
      color={255,0,255}));
  connect(greEquThr3.y,not1. u)
    annotation (Line(points={{-39,-30},{-30,-30},{-30,30},{-22,30}},
      color={255,0,255}));
  connect(conInt.y,intEqu. u2)
    annotation (Line(points={{-139,170},{-110,170},{-110,192},{-102,192}},
      color={255,127,0}));
  connect(uNexDisChi,intRep1. u)
    annotation (Line(points={{-220,-70},{-142,-70}},  color={255,127,0}));
  connect(intRep1.y,intEqu1. u1)
    annotation (Line(points={{-119,-70},{-102,-70}}, color={255,127,0}));
  connect(conInt.y,intEqu1. u2)
    annotation (Line(points={{-139,170},{-110,170},{-110,-78},{-102,-78}},
      color={255,127,0}));
  connect(intEqu1.y,and3. u2)
    annotation (Line(points={{-79,-70},{20,-70},{20,-38},{38,-38}},
      color={255,0,255}));
  connect(not1.y, booRep3.u)
    annotation (Line(points={{1,30},{78,30}}, color={255,0,255}));
  connect(uStaDow, booRep4.u)
    annotation (Line(points={{-220,140},{-180,140},{-180,-160},{-102,-160}},
      color={255,0,255}));
  connect(uChi, booToRea1.u)
    annotation (Line(points={{-220,80},{-160,80},{-160,-210},{-102,-210}},
      color={255,0,255}));
  connect(uStaDow, edg1.u)
    annotation (Line(points={{-220,140},{-180,140},{-180,-240},{-102,-240}},
      color={255,0,255}));
  connect(booToRea1.y, triSam1.u)
    annotation (Line(points={{-79,-210},{-22,-210}}, color={0,0,127}));
  connect(edg1.y, booRep5.u)
    annotation (Line(points={{-79,-240},{-62,-240}}, color={255,0,255}));
  connect(booRep5.y, triSam1.trigger)
    annotation (Line(points={{-39,-240},{-10,-240},{-10,-221.8}}, color={255,0,255}));
  connect(triSam1.y, greEquThr1.u)
    annotation (Line(points={{1,-210},{38,-210}}, color={0,0,127}));
  connect(booRep4.y, and4.u2)
    annotation (Line(points={{-79,-160},{0,-160},{0,-188},{38,-188}},
      color={255,0,255}));
  connect(intEqu1.y, and4.u1)
    annotation (Line(points={{-79,-70},{20,-70},{20,-180},{38,-180}},
      color={255,0,255}));
  connect(and4.y, logSwi3.u2)
    annotation (Line(points={{61,-180},{98,-180}}, color={255,0,255}));
  connect(con2.y, logSwi3.u1)
    annotation (Line(points={{61,-150},{80,-150},{80,-172},{98,-172}},
      color={255,0,255}));
  connect(greEquThr1.y, logSwi3.u3)
    annotation (Line(points={{61,-210},{80,-210},{80,-188},{98,-188}},
      color={255,0,255}));
  connect(uOnOff, booRep6.u)
    annotation (Line(points={{-220,-120},{38,-120}}, color={255,0,255}));
  connect(booRep6.y, logSwi4.u2)
    annotation (Line(points={{61,-120},{158,-120}}, color={255,0,255}));
  connect(logSwi3.y, logSwi4.u3)
    annotation (Line(points={{121,-180},{140,-180},{140,-128},{158,-128}},
      color={255,0,255}));
  connect(logSwi4.y, yChi)
    annotation (Line(points={{181,-120},{210,-120}}, color={255,0,255}));
  connect(logSwi2.y, logSwi4.u1)
    annotation (Line(points={{181,30},{190,30},{190,-100},{140,-100},{140,-112},
      {158,-112}}, color={255,0,255}));
  connect(greEquThr3.y, yReaDemLim)
    annotation (Line(points={{-39,-30},{-30,-30},{-30,-60},{210,-60}},
      color={255,0,255}));

annotation (
  defaultComponentName="disChi",
  Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(extent={{-120,146},{100,108}},
          lineColor={0,0,255},
          textString="%name")}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-200,-260},{200,260}}),
        graphics={
          Rectangle(
          extent={{-198,-142},{198,-258}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Rectangle(
          extent={{-198,258},{198,-98}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Text(
          extent={{114,74},{184,54}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Enable small chiller"),
          Text(
          extent={{116,-78},{186,-96}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Disable large chiller"),
          Text(
          extent={{-152,-190},{190,-260}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Disable chiller when 
the down-process does 
not require any other 
chiller being enabled"),
          Text(
          extent={{-100,264},{190,210}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Disable chiller when 
the down-process requires
small chiller being enabled")}));
end DisableChiller;
