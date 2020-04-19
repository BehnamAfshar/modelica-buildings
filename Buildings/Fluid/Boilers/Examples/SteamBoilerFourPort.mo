within Buildings.Fluid.Boilers.Examples;
model SteamBoilerFourPort
  "Test model for the steam boiler with four fluid ports"
  extends Modelica.Icons.Example;

  package MediumSte = IBPSA.Media.Steam "Steam medium";
  package MediumWat = IBPSA.Media.Water (T_max = 200+273.15)
    "Water medium";
//  package MediumAir = Modelica.Media.IdealGases.MixtureGases.CombustionAir
//    "Fresh air for combustion (N2,O2)";
  package MediumFlu = Buildings.Media.Air
    "Flue gas assumed to be air";
//  package MediumFlu =
//      Modelica.Media.IdealGases.MixtureGases.FlueGasLambdaOnePlus (
//      reference_X={0.718,0.009,0.182,0.091})
//    "Flue gas with excess air (N2,O2,H2O,CO2)";

//  parameter Modelica.SIunits.MassFlowRate m_flow_nominal = 1
//    "Nominal mass flow rate";

  parameter Modelica.SIunits.AbsolutePressure pOut_nominal=861844.7
    "Nominal pressure for the boiler";

  parameter Modelica.SIunits.Temperature TIn_nominal = 20+273.15
    "Nominal temperature of inflowing water";

//  parameter Modelica.SIunits.Temperature TSat_nominal=
//    MediumSte.saturationTemperature(p_nominal)
//    "Nominal saturation temperature";

//  parameter Modelica.SIunits.SpecificEnthalpy dh_nominal=
//    MediumSte.dewEnthalpy(MediumSte.setSat_T(TSat_nominal)) -
//    MediumSte.bubbleEnthalpy(MediumSte.setSat_T(TSat_nominal))
//    "Nominal change in enthalpy";

  parameter Modelica.SIunits.Power Q_flow_nominal=9143815.2
    "Nominal heat flow rate";
//        m_flow_nominal * (dh_nominal + MediumWat.cp_const*(TSat_nominal - MediumWat.T_default))

  parameter Modelica.SIunits.MassFlowRate m1_flow_nominal=Q_flow_nominal/dh_nominal
    "Nominal mass flow rate for water side";

  parameter Modelica.SIunits.MassFlowRate m2_flow_nominal=4.0697
    "Nominal mass flow rate for air side";

  parameter Modelica.SIunits.Temperature TOut_nominal = MediumSte.saturationTemperature(pOut_nominal)
    "Nominal temperature leaving the boiler";

  parameter Modelica.SIunits.SpecificHeatCapacityAtConstantPressure cp_default=
    MediumWat.specificHeatCapacityCp(MediumWat.setState_pTX(
      T=MediumWat.T_default, p=MediumWat.p_default, X=MediumWat.X_default))
    "Default value for specific heat";

  parameter Modelica.SIunits.SpecificEnthalpy dh_nominal=
    cp_default*(TOut_nominal - TIn_nominal) +
    MediumSte.dewEnthalpy(MediumSte.setSat_p(pOut_nominal)) -
    MediumSte.bubbleEnthalpy(MediumSte.setSat_p(pOut_nominal))
   "Nominal change in enthalpy of boiler";

  Sources.Boundary_pT steSin(
    redeclare package Medium = MediumSte,
    use_p_in=true,
    p(displayUnit="Pa"),
    nPorts=1)            "Steam sink"
    annotation (Placement(transformation(extent={{100,10},{80,30}})));
  Modelica.Blocks.Sources.Constant pSet(k=pOut_nominal)
                                                   "Steam pressure setpoint"
    annotation (Placement(transformation(extent={{80,60},{100,80}})));
  FixedResistances.PressureDrop dpWat(
    redeclare package Medium = MediumWat,
    m_flow_nominal=m1_flow_nominal,
    dp_nominal(displayUnit="Pa") = 6000) "Pressure drop in water pipe network"
    annotation (Placement(transformation(extent={{0,10},{20,30}})));
  Sources.Boundary_pT watSou(
    redeclare package Medium = MediumWat,
    p(displayUnit="Pa"),
    nPorts=1) "Water source"
    annotation (Placement(transformation(extent={{-70,10},{-50,30}})));
  Movers.FlowControlled_m_flow pum(
    redeclare package Medium = MediumWat,
    m_flow_nominal=m1_flow_nominal,
    nominalValuesDefineDefaultPressureCurve=true) "Pump"
    annotation (Placement(transformation(extent={{-30,10},{-10,30}})));
  Modelica.Blocks.Sources.RealExpression mMax_flow(y=m1_flow_nominal)
    "Maximum (nominal) mass flow rate"
    annotation (Placement(transformation(extent={{-60,54},{-40,74}})));
  Modelica.Blocks.Math.Product m1Act_flow
    "Actual mass flow rate for water side"
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));
  Modelica.Blocks.Sources.TimeTable y(table=[0,0; 1800,1; 1800,0; 2400,0; 2400,
        1; 3600,1])
    annotation (Placement(transformation(extent={{-110,80},{-90,100}})));
  Sources.Boundary_pT fluGasSin(
    redeclare package Medium = MediumFlu,                             p(
        displayUnit="Pa"),
    nPorts=1)              "Flue gas sink"
    annotation (Placement(transformation(extent={{100,-100},{80,-80}})));
  Sources.Boundary_pT airSou(redeclare package Medium = MediumFlu,
    p(displayUnit="Pa"),
    nPorts=1) "Air source"
    annotation (Placement(transformation(extent={{-70,-100},{-50,-80}})));
  Buildings.Fluid.Boilers.SteamBoilerFourPort boi(
    redeclare package Medium_a1 = MediumWat,
    redeclare package Medium_b1 = MediumSte,
    m1_flow_nominal=m1_flow_nominal,
    m2_flow_nominal=m2_flow_nominal,
    show_T=true,
    Q_flow_nominal=Q_flow_nominal,
    pOut_nominal=pOut_nominal,
    effCur=Buildings.Fluid.Types.EfficiencyCurves.Polynomial,
    a={0.8,-0.004},
    fue=Data.Fuels.NaturalGasLowerHeatingValue(),
    eta_nominal=0.796,
    redeclare package Medium2 = MediumFlu) "Steam boiler"
    annotation (Placement(transformation(extent={{40,8},{60,30}})));
  Movers.FlowControlled_m_flow fan(
    redeclare package Medium = MediumFlu,
    m_flow_nominal=m2_flow_nominal,
    nominalValuesDefineDefaultPressureCurve=true) "Fan"
    annotation (Placement(transformation(extent={{-30,-100},{-10,-80}})));
  FixedResistances.PressureDrop dpAir(
    redeclare package Medium = MediumFlu,
    m_flow_nominal=m2_flow_nominal,
    dp_nominal(displayUnit="Pa") = 6000) "Pressure drop in air side"
    annotation (Placement(transformation(extent={{0,-100},{20,-80}})));
  Modelica.Blocks.Math.Gain gai(k=3.7871) "Gain"
    annotation (Placement(transformation(extent={{-68,-20},{-48,0}})));
  Modelica.Blocks.Math.Add m2Act_flow
    "Actual mass flow rate for air side (determined empirically)"
    annotation (Placement(transformation(extent={{-30,-40},{-10,-20}})));
  Modelica.Blocks.Sources.Constant off(k=0.2898)
    "Offset (determined empirically)"
    annotation (Placement(transformation(extent={{-70,-60},{-50,-40}})));
equation
  connect(pSet.y, steSin.p_in) annotation (Line(points={{101,70},{110,70},{110,28},
          {102,28}},
                   color={0,0,127}));
  connect(watSou.ports[1], pum.port_a)
    annotation (Line(points={{-50,20},{-30,20}},
                                               color={0,127,255}));
  connect(pum.port_b, dpWat.port_a)
    annotation (Line(points={{-10,20},{0,20}}, color={0,127,255}));
  connect(mMax_flow.y, m1Act_flow.u2)
    annotation (Line(points={{-39,64},{-22,64}}, color={0,0,127}));
  connect(m1Act_flow.y, pum.m_flow_in) annotation (Line(points={{1,70},{10,70},{
          10,40},{-20,40},{-20,32}}, color={0,0,127}));
  connect(y.y, m1Act_flow.u1) annotation (Line(points={{-89,90},{-32,90},{-32,76},
          {-22,76}}, color={0,0,127}));
  connect(dpWat.port_b, boi.port_a1)
    annotation (Line(points={{20,20},{40,20}},
                                            color={0,127,255}));
  connect(boi.port_b1, steSin.ports[1])
    annotation (Line(points={{60,20},{80,20}},
                                             color={0,127,255}));
  connect(boi.port_b2, fluGasSin.ports[1]) annotation (Line(points={{60,12},{70,
          12},{70,-90},{80,-90}}, color={0,127,255}));
  connect(airSou.ports[1], fan.port_a)
    annotation (Line(points={{-50,-90},{-30,-90}}, color={0,127,255}));
  connect(fan.port_b, dpAir.port_a)
    annotation (Line(points={{-10,-90},{0,-90}}, color={0,127,255}));
  connect(dpAir.port_b, boi.port_a2) annotation (Line(points={{20,-90},{30,-90},
          {30,12},{40,12}}, color={0,127,255}));
  connect(y.y, boi.y) annotation (Line(points={{-89,90},{30,90},{30,29},{39,29}},
        color={0,0,127}));
  connect(y.y, gai.u) annotation (Line(points={{-89,90},{-80,90},{-80,-10},{-70,
          -10}}, color={0,0,127}));
  connect(off.y, m2Act_flow.u2) annotation (Line(points={{-49,-50},{-42,-50},{-42,
          -36},{-32,-36}}, color={0,0,127}));
  connect(gai.y, m2Act_flow.u1) annotation (Line(points={{-47,-10},{-40,-10},{-40,
          -24},{-32,-24}}, color={0,0,127}));
  connect(m2Act_flow.y, fan.m_flow_in) annotation (Line(points={{-9,-30},{0,-30},
          {0,-70},{-20,-70},{-20,-78}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},
            {120,120}})),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},{120,120}})),
experiment(Tolerance=1e-6, StopTime=100.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Boilers/Examples/SteamBoilerTwoPort.mos"
        "Simulate and plot"));
end SteamBoilerFourPort;
