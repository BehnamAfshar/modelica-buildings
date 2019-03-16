within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.FanSpeed.EnabledWSE;
block Controller "Tower fan control when waterside economizer is enabled"

  parameter Integer nChi=2 "Total number of chillers";
  parameter Modelica.SIunits.HeatFlowRate minUnLTon[nChi]={1e4,1e4}
    "Minimum cyclining load below which chiller will begin cycling"
    annotation (Dialog(tab="Integrated operation"));
  parameter Real minSpe=0.1
    "Allowed minimum value of waterside economizer tower maximum speed"
    annotation (Dialog(tab="Integrated operation"));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController intOpeCon=Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation (Dialog(tab="Integrated operation", group="Controller"));
  parameter Real kIntOpe=1 "Gain of controller"
    annotation (Dialog(tab="Integrated operation", group="Controller"));
  parameter Modelica.SIunits.Time TiIntOpe=0.5
    "Time constant of integrator block"
    annotation (Dialog(tab="Integrated operation", group="Controller"));
  parameter Modelica.SIunits.Time TdIntOpe=0.1
    "Time constant of derivative block"
    annotation (Dialog(tab="Integrated operation", group="Controller"));
  parameter Real minTowSpe=0.1 "Minimum tower fan speed"
    annotation (Dialog(tab="WSE-only"));
  parameter Real maxTowSpe=1 "Maximum tower fan speed"
    annotation (Dialog(tab="WSE-only"));
  parameter Real fanSpeChe=0.005 "Lower threshold value to check fan speed"
    annotation (Dialog(tab="WSE-only"));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController chiWatCon=Buildings.Controls.OBC.CDL.Types.SimpleController.PID
    "Type of controller" annotation (Dialog(tab="WSE-only", group="Controller"));
  parameter Real kWSE=1 "Gain of controller"
    annotation (Dialog(tab="WSE-only", group="Controller"));
  parameter Modelica.SIunits.Time TiWSE=0.5 "Time constant of integrator block"
    annotation (Dialog(tab="WSE-only", group="Controller"));
  parameter Modelica.SIunits.Time TdWSE=0.1 "Time constant of derivative block"
    annotation (Dialog(tab="WSE-only", group="Controller"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput chiLoa[nChi](
    each final unit="W",
    each final quantity="Power") "Current load of each chiller"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}}),
      iconTransformation(extent={{-140,80},{-100,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChi[nChi]
    "Chiller enabling status: true=ON"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWSE
    "Waterside economizer enabling status: true=ON"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uTowSpe(
     final min=0,
     final max=1,
     final unit="1") "Tower fan speed"
     annotation (Placement(transformation(extent={{-140,-50},{-100,-10}}),
       iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSup(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-140,-110},{-100,-70}}),
      iconTransformation(extent={{-140,-120},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yTowSpe(
    final min=0,
    final max=1,
    final unit="1")
    "Tower fan speed when WSE is enabled and there is any chiller running"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
      iconTransformation(extent={{100,-10},{120,10}})));

protected
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.FanSpeed.EnabledWSE.Subsequences.IntegratedOperation
    intOpe(
    final nChi=nChi,
    final minUnLTon=minUnLTon,
    final minSpe=minSpe,
    final conTyp=intOpeCon,
    final k=kIntOpe,
    final Ti=TiIntOpe,
    final Td=TdIntOpe)
    "Tower fan speed when the waterside economizer is enabled and the chillers are running"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.FanSpeed.EnabledWSE.Subsequences.WSEOperation
    wseOpe(
    final minTowSpe=minTowSpe,
    final maxTowSpe=maxTowSpe,
    final fanSpeChe=fanSpeChe,
    final chiWatCon=chiWatCon,
    final k=kWSE,
    final Ti=TiWSE,
    final Td=TdWSE)
    "Tower fan speed when the waterside economizer is running alone"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(final nu=nChi) "Logical or"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi "Logical switch"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1 "Logical switch"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer(final k=0) "Zero constant"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));

equation
  connect(intOpe.uChi, uChi)
    annotation (Line(points={{-42,88},{-80,88},{-80,40},{-120,40}}, color={255,0,255}));
  connect(intOpe.chiLoa, chiLoa)
    annotation (Line(points={{-42,80},{-120,80}}, color={0,0,127}));
  connect(intOpe.uWSE, uWSE)
    annotation (Line(points={{-42,72},{-60,72},{-60,0},{-120,0}}, color={255,0,255}));
  connect(wseOpe.uTowSpe, uTowSpe)
    annotation (Line(points={{-42,-52},{-60,-52},{-60,-30},{-120,-30}}, color={0,0,127}));
  connect(wseOpe.TChiWatSup, TChiWatSup)
    annotation (Line(points={{-42,-60},{-120,-60}}, color={0,0,127}));
  connect(wseOpe.TChiWatSupSet, TChiWatSupSet)
    annotation (Line(points={{-42,-68},{-60,-68},{-60,-90},{-120,-90}}, color={0,0,127}));
  connect(mulOr.y, swi.u2)
    annotation (Line(points={{-18.3,40},{-2,40}}, color={255,0,255}));
  connect(intOpe.yTowSpe, swi.u1)
    annotation (Line(points={{-19,80},{-10,80},{-10,48},{-2,48}}, color={0,0,127}));
  connect(wseOpe.yTowSpe, swi.u3)
    annotation (Line(points={{-19,-60},{-10,-60},{-10,32},{-2,32}}, color={0,0,127}));
  connect(uWSE, swi1.u2)
    annotation (Line(points={{-120,0},{58,0}}, color={255,0,255}));
  connect(swi.y, swi1.u1)
    annotation (Line(points={{21,40},{40,40},{40,8},{58,8}}, color={0,0,127}));
  connect(zer.y, swi1.u3)
    annotation (Line(points={{21,-30},{40,-30},{40,-8},{58,-8}}, color={0,0,127}));
  connect(swi1.y, yTowSpe)
    annotation (Line(points={{81,0},{110,0}}, color={0,0,127}));
  connect(uChi, mulOr.u)
    annotation (Line(points={{-120,40},{-42,40}}, color={255,0,255}));

annotation (
  defaultComponentName="towFanSpeWse",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          lineColor={0,0,255},
          textString="%name")}),                     Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Controller;
