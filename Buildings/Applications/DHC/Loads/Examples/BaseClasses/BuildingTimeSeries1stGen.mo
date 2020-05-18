within Buildings.Applications.DHC.Loads.Examples.BaseClasses;
model BuildingTimeSeries1stGen

  replaceable package Medium_a =
      IBPSA.Media.Steam.Interfaces.PartialPureSubstanceWithSat
    "Medium model for port_a (inlet)";
  replaceable package Medium_b =
      IBPSA.Media.Steam.Interfaces.PartialPureSubstanceWithSat
    "Medium model for port_b (outlet)";

  parameter Real QHeaLoa[:, :]=[0, 200E3; 6, 200E3; 6, 50E3; 18, 50E3; 18, 75E3; 24, 75E3]
    "Heating load profile for the building";
  parameter Modelica.SIunits.Power Q_flow_nominal
    "Nominal heat flow rate";

  parameter Modelica.SIunits.AbsolutePressure pSte_nominal
    "Nominal steam pressure";
  final parameter Modelica.SIunits.SpecificEnthalpy dh_nominal=
    Medium_a.enthalpyOfVaporization_sat(Medium_a.saturationState_p(pSte_nominal))
    "Nominal change in enthalpy";
  final parameter Modelica.SIunits.MassFlowRate m_flow_nominal=
    Q_flow_nominal/dh_nominal
    "Nominal mass flow rate";

  parameter Modelica.SIunits.Time riseTime=120
    "Rise time of the filter (time to reach 99.6 % of an opening step)";

  Modelica.Blocks.Sources.CombiTimeTable QHea(
    table=QHeaLoa,
    timeScale=3600,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    "Heating demand"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Applications.DHC.EnergyTransferStations.Heating1stGenIdeal ets(
    redeclare final package Medium_a = Medium_a,
    redeclare final package Medium_b = Medium_b,
    m_flow_nominal=m_flow_nominal,
    Q_flow_nominal=Q_flow_nominal,
    pSte_nominal=pSte_nominal)
                          "Energy transfer station"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
        Medium_a)
    annotation (Placement(transformation(extent={{90,-70},{110,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium =
        Medium_b)
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Blocks.Interfaces.RealOutput Q_flow(
    final quantity="HeatFlowRate",
    final unit="W",
    displayUnit="kW") "Total heat transfer rate"
    annotation (Placement(transformation(extent={{100,70},{120,90}}),
        iconTransformation(extent={{100,70},{120,90}})));
equation
  connect(port_a, ets.port_a) annotation (Line(points={{100,-60},{-40,-60},{-40,
          0},{-10,0}},
                    color={0,127,255}));
  connect(ets.port_b, port_b) annotation (Line(points={{10,0},{100,0}},
                 color={0,127,255}));
  connect(QHea.y[1], Q_flow)
    annotation (Line(points={{-59,80},{110,80}}, color={0,0,127}));
  connect(ets.Q_flow, QHea.y[1]) annotation (Line(points={{-12,6},{-40,6},{-40,
          80},{-59,80}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Polygon(
          points={{20,-70},{60,-85},{20,-100},{20,-70}},
          lineColor={0,128,255},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          visible=not allowFlowReversal),
        Line(
          points={{55,-85},{-60,-85}},
          color={0,128,255},
          visible=not allowFlowReversal),
                                Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Polygon(
        points={{0,80},{-78,38},{80,38},{0,80}},
        lineColor={95,95,95},
        smooth=Smooth.None,
        fillPattern=FillPattern.Solid,
        fillColor={95,95,95}),
      Rectangle(
          extent={{-64,38},{64,-70}},
          lineColor={150,150,150},
          fillPattern=FillPattern.Sphere,
          fillColor={255,0,0}),
      Rectangle(
        extent={{-42,-4},{-14,24}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{16,-4},{44,24}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{16,-54},{44,-26}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{-42,-54},{-14,-26}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-149,-114},{151,-154}},
          lineColor={0,0,255},
          textString="%name")}), Diagram(coordinateSystem(preserveAspectRatio=false)));
end BuildingTimeSeries1stGen;
