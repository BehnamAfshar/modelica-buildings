within Buildings.Applications.DHC.Loads.BaseClasses;
partial model PartialTerminalUnit "Partial model for HVAC terminal unit"
  import funSpe = Buildings.Applications.DHC.Loads.Types.TerminalFunctionSpec
    "Specifications of heating or cooling function";
  replaceable package Medium1 =
    Buildings.Media.Water
    "Source side medium"
    annotation (choices(
      choice(redeclare package Medium1 = Buildings.Media.Water "Water"),
      choice(redeclare package Medium1 =
        Buildings.Media.Antifreeze.PropyleneGlycolWater (
          property_T=293.15,
          X_a=0.40)
        "Propylene glycol water, 40% mass fraction")));
  replaceable package Medium2 =
    Buildings.Media.Air
    "Load side medium"
    annotation(choices(
      choice(redeclare package Medium2 = Buildings.Media.Air "Moist air"),
      choice(redeclare package Medium2 = Buildings.Media.Water "Water"),
      choice(redeclare package Medium2 =
        Buildings.Media.Antifreeze.PropyleneGlycolWater(property_T=293.15, X_a=0.40)
        "Propylene glycol water, 40% mass fraction")));
  parameter funSpe heaFunSpe = funSpe.Water
    "Specification of the heating function";
  parameter funSpe cooFunSpe = funSpe.Water
    "Specification of the cooling function";
  parameter Boolean have_heaPor = false
    "Set to true for heat ports on the load side"
    annotation(Evaluate=true);
  parameter Boolean have_fluPor = false
    "Set to true for fluid ports on the load side"
    annotation(Evaluate=true);
  parameter Boolean have_QReq_flow = false
    "Set to true for required heat flow rate as an input"
    annotation(Evaluate=true);
  parameter Boolean have_weaBus = false
    "Set to true for weather bus"
    annotation(Evaluate=true);
  parameter Boolean have_fan = false
    "Set to true if the system has a fan"
    annotation(Evaluate=true);
  parameter Boolean have_pum = false
    "Set to true if the system has a pump"
    annotation(Evaluate=true);
  parameter Modelica.SIunits.HeatFlowRate QHea_flow_nominal(min=0)
    "Heating thermal power at nominal conditions (always positive)"
    annotation(Dialog(
      group="Nominal condition",
      enable=heaFunSpe <> funSpe.None));
  parameter Modelica.SIunits.HeatFlowRate QCoo_flow_nominal(min=0)
    "Cooling thermal power at nominal conditions (always positive)"
    annotation(Dialog(
      group="Nominal condition",
      enable=cooFunSpe <> funSpe.None));
  parameter Modelica.SIunits.MassFlowRate m1Hea_flow_nominal(min=0)
    "Heating water mass flow rate at nominal conditions"
    annotation(Dialog(
      group="Nominal condition",
      enable=heaFunSpe == funSpe.Water or heaFunSpe == funSpe.ChangeOver));
  parameter Modelica.SIunits.MassFlowRate m1Coo_flow_nominal(min=0)
    "Chilled water mass flow rate at nominal conditions"
    annotation(Dialog(
      group="Nominal condition",
      enable=cooFunSpe == funSpe.Water or cooFunSpe == funSpe.ChangeOver));
  parameter Modelica.SIunits.MassFlowRate m2Hea_flow_nominal(min=0) = 0
    "Load side mass flow rate at nominal conditions in heating mode"
    annotation(Dialog(
      group="Nominal condition",
      enable=heaFunSpe <> funSpe.None));
  parameter Modelica.SIunits.MassFlowRate m2Coo_flow_nominal(min=0) = 0
    "Load side mass flow rate at nominal conditions in cooling mode"
    annotation(Dialog(
      group="Nominal condition",
      enable=cooFunSpe <> funSpe.None));
  parameter Modelica.SIunits.Temperature T_a1Hea_nominal(
    min=Modelica.SIunits.Conversions.from_degC(0), displayUnit="degC")
    "Heating water inlet temperature at nominal conditions "
    annotation(Dialog(
      group="Nominal condition",
      enable=heaFunSpe == funSpe.Water or heaFunSpe == funSpe.ChangeOver));
  parameter Modelica.SIunits.Temperature T_b1Hea_nominal(
    min=Modelica.SIunits.Conversions.from_degC(0), displayUnit="degC")
    "Heating water outlet temperature at nominal conditions"
    annotation(Dialog(
      group="Nominal condition",
      enable=heaFunSpe == funSpe.Water or heaFunSpe == funSpe.ChangeOver));
  parameter Modelica.SIunits.Temperature T_a1Coo_nominal(
    min=Modelica.SIunits.Conversions.from_degC(0), displayUnit="degC")
    "Chilled water inlet temperature at nominal conditions "
    annotation(Dialog(
      group="Nominal condition",
      enable=cooFunSpe == funSpe.Water or cooFunSpe == funSpe.ChangeOver));
  parameter Modelica.SIunits.Temperature T_b1Coo_nominal(
    min=Modelica.SIunits.Conversions.from_degC(0), displayUnit="degC")
    "Chilled water outlet temperature at nominal conditions"
    annotation(Dialog(
      group="Nominal condition",
      enable=cooFunSpe == funSpe.Water or cooFunSpe == funSpe.ChangeOver));
  parameter Modelica.SIunits.Temperature T_a2Hea_nominal(
    min=Modelica.SIunits.Conversions.from_degC(0), displayUnit="degC")
    "Load side inlet temperature at nominal conditions in heating mode"
    annotation(Dialog(
      group="Nominal condition",
      enable=heaFunSpe == funSpe.Water or heaFunSpe == funSpe.ChangeOver));
  parameter Modelica.SIunits.Temperature T_a2Coo_nominal(
    min=Modelica.SIunits.Conversions.from_degC(0), displayUnit="degC")
    "Load side inlet temperature at nominal conditions in cooling mode"
    annotation(Dialog(
      group="Nominal condition",
      enable=cooFunSpe == funSpe.Water or cooFunSpe == funSpe.ChangeOver));
  parameter Buildings.Fluid.Types.HeatExchangerConfiguration hexConHea=
    Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow
    "Heating heat exchanger configuration"
    annotation(Dialog(
      enable=heaFunSpe == funSpe.Water));
  parameter Buildings.Fluid.Types.HeatExchangerConfiguration hexConCoo=
    Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow
    "Cooling heat exchanger configuration"
    annotation(Dialog(
      enable=cooFunSpe == funSpe.Water or cooFunSpe == funSpe.ChangeOver));
  final parameter Boolean allowFlowReversal = false
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation(Evaluate=true);
  // Dynamics
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab="Dynamics", group="Equations"));
  parameter Modelica.Fluid.Types.Dynamics massDynamics = energyDynamics
    "Type of mass balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab="Dynamics", group="Equations"));
  parameter Modelica.SIunits.Time tau = 1
    "Time constant at nominal flow (if energyDynamics <> SteadyState)"
    annotation (Dialog(tab="Dynamics", group="Nominal condition"));
  // IO connectors
  Modelica.Blocks.Interfaces.RealInput TSetHea if heaFunSpe <> funSpe.None
    "Heating set point"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-220,220}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-130,80})));
  Modelica.Blocks.Interfaces.RealInput TSetCoo if cooFunSpe <> funSpe.None
    "Cooling set point"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-220,180}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-130,40})));
  Modelica.Blocks.Interfaces.RealInput QReqHea_flow(
    quantity="HeatFlowRate") if have_QReq_flow and heaFunSpe <> funSpe.None
    "Required heat flow rate to meet heating set point (>=0)"
    annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-220,140}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-130,0})));
  Modelica.Blocks.Interfaces.RealInput QReqCoo_flow(
    quantity="HeatFlowRate") if have_QReq_flow and cooFunSpe <> funSpe.None
    "Required heat flow rate to meet cooling set point (<=0)"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-220,100}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-130,-40})));
  Modelica.Blocks.Interfaces.RealOutput m1ReqHea_flow(
    quantity="MassFlowRate") if
    heaFunSpe == funSpe.Water or heaFunSpe == funSpe.ChangeOver
    "Required heating water flow to meet heating set point" annotation (
      Placement(transformation(extent={{200,80},{240,120}}),
        iconTransformation(extent={{120,-40},{140,-20}})));
  Modelica.Blocks.Interfaces.RealOutput m1ReqCoo_flow(
    quantity="MassFlowRate") if
    cooFunSpe == funSpe.Water or cooFunSpe == funSpe.ChangeOver
    "Required chilled water flow to meet cooling set point"
    annotation (Placement(transformation(extent={{200,60},{240,100}}),
      iconTransformation(extent={{120,-60},{140,-40}})));
  Modelica.Blocks.Interfaces.RealOutput QActHea_flow(
    quantity="HeatFlowRate") if heaFunSpe <> funSpe.None
    "Heat flow rate transferred to the load for heating (>0)"
    annotation (Placement(transformation(extent={{200,200},{240,240}}),
        iconTransformation(extent={{120,80},{140,100}})));
  Modelica.Blocks.Interfaces.RealOutput QActCoo_flow(
    quantity="HeatFlowRate") if cooFunSpe <> funSpe.None
    "Heat flow rate transferred to the load for cooling (<=0)" annotation (
      Placement(transformation(extent={{200,180},{240,220}}),
        iconTransformation(extent={{120,60},{140,80}})));
  Modelica.Blocks.Interfaces.RealOutput PFan(
    quantity="Power", final unit="W") if have_fan
    "Power drawn by fans motors"
    annotation (Placement(transformation(extent={{200,120},{240,160}}),
        iconTransformation(extent={{120,0},{140,20}})));
  Modelica.Blocks.Interfaces.RealOutput PPum(
    quantity="Power", final unit="W") if have_pum
    "Power drawn by pumps motors"
    annotation (Placement(transformation(extent={{200,100},{240,140}}),
        iconTransformation(extent={{120,-20},{140,0}})));
  Modelica.Blocks.Interfaces.RealOutput PHea(
    quantity="Power", final unit="W") if heaFunSpe == funSpe.Electric
    "Power drawn by heating equipment"
    annotation (Placement(transformation(extent={{200,160},{240,200}}),
        iconTransformation(extent={{120,40},{140,60}})));
  Modelica.Blocks.Interfaces.RealOutput PCoo(
    quantity="Power", final unit="W") if cooFunSpe == funSpe.Electric
    "Power drawn by cooling equipment"
    annotation (Placement(transformation(extent={{200,140},{240,180}}),
        iconTransformation(extent={{120,20},{140,40}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a2(
    redeclare final package Medium=Medium2,
    p(start=Medium2.p_default),
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=Medium2.h_default, nominal=Medium2.h_default)) if have_fluPor
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (
      Placement(transformation(
      extent={{190,-10},{210,10}}),
      iconTransformation(extent={{110,100},{130,120}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b2(
    redeclare final package Medium=Medium2,
    p(start=Medium2.p_default),
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start=Medium2.h_default, nominal=Medium2.h_default)) if have_fluPor
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (
      Placement(transformation(extent={{-190,-10},{-210,10}}),
      iconTransformation(extent={{-110,100},{-130,120}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b heaPorCon if have_heaPor
    "Heat port transferring convective heat to the load"
    annotation (
      Placement(transformation(extent={{190,30},{210,50}}),
      iconTransformation(extent={{-50,-10},{-30,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b heaPorRad if have_heaPor
    "Heat port transferring radiative heat to the load"
    annotation (
      Placement(transformation(extent={{190,-50},{210,-30}}),
      iconTransformation(extent={{30,-10},{50,10}})));
  BoundaryConditions.WeatherData.Bus weaBus if have_weaBus
    "Weather data bus"
    annotation (Placement(
      transformation(extent={{-216,44},{-182,76}}),
      iconTransformation(extent={{-18,104},{16,136}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a1Hea(
    p(start=Medium1.p_default),
    redeclare final package Medium=Medium1,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=Medium1.h_default, nominal=Medium1.h_default)) if
    heaFunSpe == funSpe.Water
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-210,-230},{-190,-210}}),
        iconTransformation(extent={{-130,-120},{-110,-100}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a1Coo(
    p(start=Medium1.p_default),
    redeclare final package Medium=Medium1,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=Medium1.h_default, nominal=Medium1.h_default)) if
    cooFunSpe == funSpe.Water or cooFunSpe == funSpe.ChangeOver
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-210,-190},{-190,-170}}),
        iconTransformation(extent={{-130,-90},{-110,-70}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b1Hea(
    p(start=Medium1.p_default),
    redeclare final package Medium=Medium1,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start=Medium1.h_default, nominal=Medium1.h_default)) if
    heaFunSpe == funSpe.Water
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{210,-230},{190,-210}}),
        iconTransformation(extent={{130,-120},{110,-100}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b1Coo(
    p(start=Medium1.p_default),
    redeclare final package Medium=Medium1,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start=Medium1.h_default, nominal=Medium1.h_default)) if
    cooFunSpe == funSpe.Water or cooFunSpe == funSpe.ChangeOver
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{210,-190},{190,-170}}),
        iconTransformation(extent={{130,-90},{110,-70}})));
protected
  parameter Modelica.SIunits.SpecificHeatCapacity cp1Hea_nominal=
    Medium1.specificHeatCapacityCp(
      Medium1.setState_pTX(Medium1.p_default, T_a1Hea_nominal))
    "Source side specific heat capacity at nominal conditions in heating mode";
  parameter Modelica.SIunits.SpecificHeatCapacity cp1Coo_nominal=
    Medium1.specificHeatCapacityCp(
      Medium1.setState_pTX(Medium1.p_default, T_a1Coo_nominal))
    "Source side specific heat capacity at nominal conditions in cooling mode";
  parameter Modelica.SIunits.SpecificHeatCapacity cp2Hea_nominal=
    Medium2.specificHeatCapacityCp(
      Medium2.setState_pTX(Medium2.p_default, T_a2Hea_nominal))
    "Load side specific heat capacity at nominal conditions in heating mode";
  parameter Modelica.SIunits.SpecificHeatCapacity cp2Coo_nominal=
    Medium2.specificHeatCapacityCp(
      Medium2.setState_pTX(Medium2.p_default, T_a2Coo_nominal))
    "Load side specific heat capacity at nominal conditions in cooling mode";
annotation (
  defaultComponentName="terUni",
  Icon(coordinateSystem(preserveAspectRatio=false,
  extent={{-120,-120},{120,120}}),
    graphics={
    Rectangle(extent={{-120,120},{120,-120}}, lineColor={95,95,95}),
    Rectangle(
    extent={{-80,80},{80,-80}},
    lineColor={0,0,255},
    pattern=LinePattern.None,
    fillColor={95,95,95},
    fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(
    extent={{-200,-240},{200,240}})));
end PartialTerminalUnit;