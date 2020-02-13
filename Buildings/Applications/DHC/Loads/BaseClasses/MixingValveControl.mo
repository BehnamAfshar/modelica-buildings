within Buildings.Applications.DHC.Loads.BaseClasses;
block MixingValveControl "Mixing valve controller"
  extends Modelica.Blocks.Icons.Block;
  import Type_dis = Buildings.Applications.DHC.Loads.Types.DistributionType
    "Types of distribution system";
  parameter Type_dis typDis = Type_dis.HeatingWater
    "Type of distribution system"
    annotation(Evaluate=true);
  parameter Real k(
    min=0,
    unit="1") = 0.1 "Gain of controller";
  parameter Modelica.SIunits.Time Ti(min=Constants.small) = 10
    "Time constant of integrator block";
  // IO CONNECTORS
  Modelica.Blocks.Interfaces.RealInput TSupSet(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    final displayUnit="degC")
    "Supply temperature set point"
    annotation (Placement(transformation(
      extent={{-20,-20},{20,20}},
      rotation=0,
      origin={-120,-40}),
      iconTransformation(
      extent={{-10,-10},{10,10}},
      rotation=0,
      origin={-110,-40})));
  Modelica.Blocks.Interfaces.IntegerInput modChaOve(final unit="1") if
    typDis == Type_dis.ChangeOver
    "Operating mode in change-over (1 for heating, -1 for cooling)"
    annotation (Placement(
      transformation(
      extent={{-20,-20},{20,20}},
      rotation=0,
      origin={-120,80}),
      iconTransformation(
      extent={{-10,-10},{10,10}},
      rotation=0,
      origin={-110,80})));
  Modelica.Blocks.Interfaces.RealInput TSupMes(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    final displayUnit="degC")
    "Supply temperature (sensed)"
    annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,-80}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,-80})));
  Modelica.Blocks.Interfaces.RealOutput yVal(final unit="1")
    "Valve control signal"
    annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={120,0}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,0})));
  // COMPONENTS
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea if
    typDis == Type_dis.ChangeOver
    "Conversion to real"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant tru(k=true)
    "True constant"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer(k=0)
    "Zero constant"
    annotation (Placement(transformation(extent={{-70,-30},{-50,-10}})));
  Modelica.Blocks.Math.IntegerToBoolean toBoo(threshold=0) if
    typDis == Type_dis.ChangeOver
    "Conversion to boolean (true if heating mode)"
    annotation (Placement(transformation(extent={{-10,10},{10,30}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID conTSup(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    final k=k,
    final Ti=Ti,
    final yMax=1,
    final yMin=-1,
    final reverseAction=false,
    final reset=if typDis == Type_dis.ChangeOver then
      Buildings.Controls.OBC.CDL.Types.Reset.Parameter else
      Buildings.Controls.OBC.CDL.Types.Reset.Disabled,
    final y_reset=0)
    "PI controller tracking supply temperature"
    annotation (Placement(transformation(extent={{-70,-70},{-50,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Min negPar
    "Negative part of control signal"
    annotation (Placement(transformation(extent={{-10,-90},{10,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Max posPar
    "Positive part of control signal"
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
  Buildings.Controls.OBC.CDL.Logical.ZeroCrossing zerCro if
    typDis == Type_dis.ChangeOver
    "Zero crossing yields true signal"
    annotation (Placement(transformation(extent={{0,70},{20,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain opp(k=-1)
    "Opposite value"
    annotation (Placement(transformation(extent={{20,-90},{40,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi
    "Logical switch"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
  Modelica.Blocks.Sources.BooleanExpression fixMod(
    final y=typDis == Type_dis.HeatingWater)
    "Fixed operating mode"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  if typDis == Type_dis.ChangeOver then
    connect(modChaOve, intToRea.u)
      annotation (Line(points={{-120,80},{-82,80}}, color={255,127,0}));
    connect(tru.y, zerCro.enable)
      annotation (Line(points={{-18,60},{10,60},{10,68}},
                                                        color={255,0,255}));
    connect(intToRea.y, zerCro.u)
      annotation (Line(points={{-58,80},{-2,80}},  color={0,0,127}));
    connect(modChaOve, toBoo.u)
      annotation (Line(points={{-120,80},{-90,80},{-90,20},{-12,20}},
                    color={255,127,0}));
    connect(toBoo.y, swi.u2)
      annotation (Line(points={{11,20},{30,20},{30,0},{68,0}},
               color={255,0,255}));
    connect(zerCro.y, conTSup.trigger)
      annotation (Line(points={{22,80},{40,80},{40,
          40},{-80,40},{-80,-76},{-68,-76},{-68,-72}}, color={255,0,255}));
  else
    connect(fixMod.y, swi.u2)
      annotation (Line(points={{11,0},{68,0}},
                     color={255,0,255}));
  end if;
  connect(conTSup.y, posPar.u2) annotation (Line(points={{-48,-60},{-20,-60},{
          -20,-46},{-12,-46}},
                           color={0,0,127}));
  connect(zer.y, posPar.u1) annotation (Line(points={{-48,-20},{-40,-20},{-40,
          -34},{-12,-34}},
                      color={0,0,127}));
  connect(zer.y, negPar.u1) annotation (Line(points={{-48,-20},{-40,-20},{-40,
          -74},{-12,-74}},
                      color={0,0,127}));
  connect(conTSup.y, negPar.u2) annotation (Line(points={{-48,-60},{-20,-60},{
          -20,-86},{-12,-86}},
                           color={0,0,127}));
  connect(negPar.y, opp.u)
    annotation (Line(points={{12,-80},{18,-80}}, color={0,0,127}));
  connect(opp.y, swi.u3) annotation (Line(points={{42,-80},{60,-80},{60,-8},{68,
          -8}},     color={0,0,127}));
  connect(posPar.y, swi.u1) annotation (Line(points={{12,-40},{40,-40},{40,8},{68,
          8}},       color={0,0,127}));
  connect(conTSup.u_s, TSupSet) annotation (Line(points={{-72,-60},{-90,-60},{-90,
          -40},{-120,-40}}, color={0,0,127}));
  connect(TSupMes, conTSup.u_m) annotation (Line(points={{-120,-80},{-60,-80},{-60,
          -72}}, color={0,0,127}));
  connect(swi.y, yVal) annotation (Line(points={{92,0},{120,0}},
        color={0,0,127}));

  annotation (
  defaultComponentName="conVal",
  Documentation(info="
<html>
<p>
This model implements a generic controller for a three-way mixing valve. 
Three operating modes are supported:
</p>
<ul>
<li>
Heating: the controller tracks a minimum supplied temperature.
</li>
<li>
Cooling: the controller tracks a maximum supplied temperature.
</li>
<li>
Change-over: the controller tracks either a minimum or a maximum
supplied temperature depending on the actual value of the integer input
variable <code>modChaOve</code> (+1 for heating, -1 for cooling). 
The model instantiates only one PI block to limit the number of state 
variables in large models. Therefore the PI gain 
is independent from the change-over mode: the reverse action is modeled 
by taking the opposite value of the PI block output. Eventually the 
integral part is reset whenever the change-over mode is switched.
</li>
</ul>
<p>
See 
<a href=\"modelica://Buildings.Applications.DHC.Loads.Validation.FlowDistributionChangeOver\">
Buildings.Applications.DHC.Loads.Validation.FlowDistributionChangeOver</a>
for a simulation with change-over.
</p>
</html>
"),
  Icon(coordinateSystem(preserveAspectRatio=false)),
  Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end MixingValveControl;