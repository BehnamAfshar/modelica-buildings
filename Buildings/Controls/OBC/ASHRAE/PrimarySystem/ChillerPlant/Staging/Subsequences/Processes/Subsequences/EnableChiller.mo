within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Processes.Subsequences;
block EnableChiller "Sequence for enabling chiller"

  parameter Integer nChi = 2 "Total number of chillers";
  parameter Modelica.SIunits.Time proOnTim = 300
    "Enabled chiller operation time to indicate if it is proven on";

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uNexEnaChi
    "Index of next enabling chiller"
    annotation (Placement(transformation(extent={{-240,100},{-200,140}}),
      iconTransformation(extent={{-140,80},{-100,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaUp
    "Indicate if there is stage-up command" annotation (Placement(
        transformation(extent={{-240,40},{-200,80}}), iconTransformation(extent=
           {{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uEnaChiWatIsoVal
    "Status of chiller chilled water isolation valve control: true=enabled valve is fully open"
    annotation (Placement(transformation(extent={{-240,10},{-200,50}}),
      iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChi[nChi]
    "Chiller status: true=ON"
     annotation (Placement(transformation(extent={{-240,-20},{-200,20}}),
       iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOnOff
    "Indicate if the stage require one chiller to be enabled while another is disabled"
    annotation (Placement(transformation(extent={{-240,-70},{-200,-30}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uNexDisChi
    "Next disabling chiller when there is any stage up that need one chiller on and another off"
    annotation (Placement(transformation(extent={{-240,-170},{-200,-130}}),
      iconTransformation(extent={{-140,-120},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChi[nChi]
    "Chiller enabling status"
    annotation (Placement(transformation(extent={{200,-60},{220,-40}}),
      iconTransformation(extent={{100,-10},{120,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yNewChi
    "Newly enabled chiller has been proven on by more than 5 minutes"
    annotation (Placement(transformation(extent={{200,-170},{220,-150}}),
        iconTransformation(extent={{100,-90},{120,-70}})));

protected
  final parameter Integer chiInd[nChi]={i for i in 1:nChi}
    "Chiller index, {1,2,...,n}";
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi[nChi] "Logical switch"
    annotation (Placement(transformation(extent={{100,110},{120,130}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    annotation (Placement(transformation(extent={{-160,50},{-140,70}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep(final nout=nChi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));
  Buildings.Controls.OBC.CDL.Logical.And and1[nChi] "Logical and"
    annotation (Placement(transformation(extent={{-40,110},{-20,130}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con[nChi](
    each final k=true) "True constant"
    annotation (Placement(transformation(extent={{-40,140},{-20,160}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold greEquThr3(
    final threshold=proOnTim)
    "Check the newly enabled chiller being operated by more than 5 minutes"
    annotation (Placement(transformation(extent={{-60,-120},{-40,-100}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[nChi]
    "Convert boolean input to real output"
    annotation (Placement(transformation(extent={{-160,-10},{-140,10}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold greEquThr[nChi](
    each final threshold=0.5)
    "Convert real input to boolean output"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi1[nChi]
    "Logical switch"
    annotation (Placement(transformation(extent={{100,-120},{120,-100}})));
  Buildings.Controls.OBC.CDL.Logical.And and3[nChi] "Logical and"
    annotation (Placement(transformation(extent={{40,-120},{60,-100}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1[nChi](
    each final k=false) "False constant"
    annotation (Placement(transformation(extent={{40,-90},{60,-70}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi2[nChi]
    "Logical switch"
    annotation (Placement(transformation(extent={{160,-60},{180,-40}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2 "Logical or"
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerReplicator intRep(final nout=nChi)
    "Replicate integer input"
    annotation (Placement(transformation(extent={{-160,110},{-140,130}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu[nChi]
    "Check next enabling isolation valve"
    annotation (Placement(transformation(extent={{-100,110},{-80,130}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim
    "Count the time after new chiller has been enabled"
    annotation (Placement(transformation(extent={{-100,-120},{-80,-100}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam[nChi]
    "Record the old chiller chilled water isolation valve status"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep1(final nout=nChi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg
    "Rising edge, output true at the moment when input turns from false to true"
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep2(final nout=nChi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{-20,-120},{0,-100}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep3(final nout=nChi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{80,-60},{100,-40}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 "Logical not"
    annotation (Placement(transformation(extent={{-160,-60},{-140,-40}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt[nChi](
    final k=chiInd) "Chiller index array"
    annotation (Placement(transformation(extent={{-160,80},{-140,100}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerReplicator intRep1(final nout=nChi)
    "Replicate integer input"
    annotation (Placement(transformation(extent={{-160,-160},{-140,-140}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu1[nChi]
    "Check next enabling isolation valve"
    annotation (Placement(transformation(extent={{-100,-160},{-80,-140}})));

equation
  connect(uNexEnaChi,intRep. u)
    annotation (Line(points={{-220,120},{-162,120}}, color={255,127,0}));
  connect(intRep.y,intEqu. u1)
    annotation (Line(points={{-139,120},{-102,120}}, color={255,127,0}));
  connect(uEnaChiWatIsoVal,and2. u2)
    annotation (Line(points={{-220,30},{-180,30},{-180,52},{-162,52}},
      color={255,0,255}));
  connect(uStaUp, and2.u1)
    annotation (Line(points={{-220,60},{-162,60}}, color={255,0,255}));
  connect(and2.y,booRep. u)
    annotation (Line(points={{-139,60},{-102,60}}, color={255,0,255}));
  connect(intEqu.y,and1. u1)
    annotation (Line(points={{-79,120},{-42,120}},  color={255,0,255}));
  connect(booRep.y,and1. u2)
    annotation (Line(points={{-79,60},{-60,60},{-60,112},{-42,112}},
      color={255,0,255}));
  connect(and1.y,logSwi. u2)
    annotation (Line(points={{-19,120},{98,120}}, color={255,0,255}));
  connect(con.y,logSwi. u1)
    annotation (Line(points={{-19,150},{0,150},{0,128},{98,128}}, color={255,0,255}));
  connect(tim.y,greEquThr3. u)
    annotation (Line(points={{-79,-110},{-62,-110}}, color={0,0,127}));
  connect(uChi,booToRea. u)
    annotation (Line(points={{-220,0},{-162,0}}, color={255,0,255}));
  connect(and2.y,edg. u)
    annotation (Line(points={{-139,60},{-120,60},{-120,-20},{-102,-20}},
      color={255,0,255}));
  connect(booToRea.y,triSam. u)
    annotation (Line(points={{-139,0},{-22,0}}, color={0,0,127}));
  connect(edg.y,booRep1. u)
    annotation (Line(points={{-79,-20},{-62,-20}}, color={255,0,255}));
  connect(booRep1.y,triSam. trigger)
    annotation (Line(points={{-39,-20},{-10,-20},{-10,-11.8}}, color={255,0,255}));
  connect(triSam.y,greEquThr. u)
    annotation (Line(points={{1,0},{18,0}}, color={0,0,127}));
  connect(greEquThr.y,logSwi. u3)
    annotation (Line(points={{41,0},{60,0},{60,112},{98,112}},
      color={255,0,255}));
  connect(and2.y,tim. u)
    annotation (Line(points={{-139,60},{-120,60},{-120,-110},{-102,-110}},
      color={255,0,255}));
  connect(greEquThr3.y,booRep2. u)
    annotation (Line(points={{-39,-110},{-22,-110}}, color={255,0,255}));
  connect(booRep2.y,and3. u1)
    annotation (Line(points={{1,-110},{38,-110}}, color={255,0,255}));
  connect(and3.y,logSwi1. u2)
    annotation (Line(points={{61,-110},{98,-110}}, color={255,0,255}));
  connect(con1.y,logSwi1. u1)
    annotation (Line(points={{61,-80},{80,-80},{80,-102},{98,-102}},
      color={255,0,255}));
  connect(uChi,logSwi1. u3)
    annotation (Line(points={{-220,0},{-180,0},{-180,-130},{80,-130},{80,-118},
      {98,-118}}, color={255,0,255}));
  connect(booRep3.y,logSwi2. u2)
    annotation (Line(points={{101,-50},{158,-50}}, color={255,0,255}));
  connect(uOnOff,not2. u)
    annotation (Line(points={{-220,-50},{-162,-50}}, color={255,0,255}));
  connect(logSwi1.y,logSwi2. u3)
    annotation (Line(points={{121,-110},{140,-110},{140,-58},{158,-58}},
      color={255,0,255}));
  connect(logSwi.y,logSwi2. u1)
    annotation (Line(points={{121,120},{140,120},{140,-42},{158,-42}},
      color={255,0,255}));
  connect(logSwi2.y,yChi)
    annotation (Line(points={{181,-50},{210,-50}}, color={255,0,255}));
  connect(not2.y,or2. u1)
    annotation (Line(points={{-139,-50},{38,-50}},color={255,0,255}));
  connect(greEquThr3.y,not1. u)
    annotation (Line(points={{-39,-110},{-30,-110},{-30,-70},{-22,-70}},
      color={255,0,255}));
  connect(not1.y,or2. u2)
    annotation (Line(points={{1,-70},{20,-70},{20,-58},{38,-58}},
      color={255,0,255}));
  connect(or2.y,booRep3. u)
    annotation (Line(points={{61,-50},{78,-50}},color={255,0,255}));
  connect(conInt.y,intEqu. u2)
    annotation (Line(points={{-139,90},{-110,90},{-110,112},{-102,112}},
      color={255,127,0}));
  connect(uNexDisChi, intRep1.u)
    annotation (Line(points={{-220,-150},{-162,-150}}, color={255,127,0}));
  connect(intRep1.y, intEqu1.u1)
    annotation (Line(points={{-139,-150},{-102,-150}}, color={255,127,0}));
  connect(conInt.y, intEqu1.u2)
    annotation (Line(points={{-139,90},{-110,90},{-110,-158},{-102,-158}},
      color={255,127,0}));
  connect(intEqu1.y, and3.u2)
    annotation (Line(points={{-79,-150},{20,-150},{20,-118},{38,-118}},
      color={255,0,255}));
  connect(greEquThr3.y, yNewChi)
    annotation (Line(points={{-39,-110},{-30,-110},{-30,-160},{210,-160}},
      color={255,0,255}));

annotation (
  defaultComponentName="enaChi",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(extent={{-120,146},{100,108}},
          lineColor={0,0,255},
          textString="%name")}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-200,-180},{200,180}}),
        graphics={
          Rectangle(
          extent={{-198,-62},{198,-178}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Rectangle(
          extent={{-198,178},{198,-38}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Text(
          extent={{-4,12},{196,-24}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Find next chiller when 
there is no chiller needs 
to be disabled"),
          Text(
          extent={{116,-112},{194,-120}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Disable 
small chiller")}));
end EnableChiller;
