within Buildings.Applications.DHC.CentralPlants.Gen1st.Cooling.Controls;
model ChilledWaterPumpSpeed
  "Controller for variable speed chilled water pumps"

  parameter Integer numPum(min=1, max=2)=2 "Number of chilled water pumps, maximum is 2";

  parameter Modelica.SIunits.PressureDifference dpSetPoi "Pressure difference setpoint";

  parameter Modelica.SIunits.Time tWai "Waiting time";

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate of single chilled water pump";

  parameter Real minSpe(unit="1",min=0,max=1) = 0.05
    "Minimum speed ratio required by chilled water pumps";

  parameter Real k(min=0) = 1 "Gain of controller";

  parameter Modelica.SIunits.Time Ti=60
    "Time constant of Integrator block" annotation (Dialog(enable=
          controllerType == Modelica.Blocks.Types.SimpleController.PI or
          controllerType == Modelica.Blocks.Types.SimpleController.PID));

  parameter Modelica.SIunits.Time Td(min=0)=0.1
    "Time constant of Derivative block" annotation (Dialog(enable=
          controllerType == Modelica.Blocks.Types.SimpleController.PD or
          controllerType == Modelica.Blocks.Types.SimpleController.PID));

  Modelica.Blocks.Interfaces.RealInput masFloPum(
    final unit="kg/s")
    "Total mass flowrate of chilled water pumps"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));

  Modelica.Blocks.Interfaces.RealInput dpMea(
    final unit="bar")
    "Measured pressure difference"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));

  Modelica.Blocks.Interfaces.RealOutput y[numPum](
    unit="1",min=0,max=1) "Pump speed signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Modelica.Blocks.Math.Product pumSpe[numPum] "Output pump speed"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

  Modelica.Blocks.Sources.RealExpression dpSet(y=dpSetPoi)
    "Pressure difference setpoint"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));

  Buildings.Applications.DataCenters.ChillerCooled.Controls.VariableSpeedPumpStage pumStaCon(
    tWai=tWai,
    m_flow_nominal=m_flow_nominal,
    minSpe=minSpe)
    "Chilled water pump staging control"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Buildings.Controls.Continuous.LimPID conPID(
    controllerType=Modelica.Blocks.Types.SimpleController.PID,
    Ti=Ti,
    k=k,
    Td=Td)      "PID controller of pump speed"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
equation
  connect(pumStaCon.masFloPum, masFloPum) annotation (Line(points={{-12,8},{-20,
          8},{-20,40},{-120,40}}, color={0,0,127}));
  connect(dpMea, conPID.u_m) annotation (Line(points={{-120,-40},{-50,-40},{-50,
          -12}}, color={0,0,127}));
  connect(dpSet.y, conPID.u_s) annotation (Line(points={{-79,0},{-62,0}}, color={0,0,127}));
  connect(conPID.y, pumStaCon.speSig) annotation (Line(points={{-39,0},{-20,0},{
          -20,4},{-12,4}}, color={0,0,127}));
  connect(pumStaCon.y, pumSpe.u1) annotation (Line(points={{11,0},{28,0},{28,6},{38,6}}, color={0,0,127}));
  connect(conPID.y, pumSpe[1].u2) annotation (Line(points={{-39,0},{-30,0},{-30,
          -20},{28,-20},{28,-6},{38,-6}}, color={0,0,127}));
  connect(conPID.y, pumSpe[2].u2) annotation (Line(points={{-39,0},{-30,0},{-30,
          -20},{28,-20},{28,-6},{38,-6}}, color={0,0,127}));
  connect(pumSpe.y, y) annotation (Line(points={{61,0},{110,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
                                        Text(
        extent={{-150,150},{150,110}},
        textString="%name",
        lineColor={0,0,255})}),             Diagram(coordinateSystem(
          preserveAspectRatio=false)));
end ChilledWaterPumpSpeed;
