within Buildings.Applications.DHC.Examples.FifthGeneration.Unidirectional.Loads;
model BuildingRCZ6WithETS
  "Model of a building (RC 6 zones) with an energy transfer station"
  extends BaseClasses.PartialBuildingWithETS(redeclare
    Buildings.Applications.DHC.Loads.Examples.BaseClasses.BuildingRCZ6
    bui,
    ets(
      QCoo_flow_nominal=sum(bui.terUni.QCoo_flow_nominal),
      QHea_flow_nominal=sum(bui.terUni.QHea_flow_nominal)));
  BoundaryConditions.WeatherData.Bus weaBus
    "Weather data bus"
    annotation (Placement(
    transformation(extent={{-18,84},{16,116}}),
    iconTransformation(extent={{-18,84},{16,116}})));
equation
  connect(weaBus, bui.weaBus)
  annotation (Line(
      points={{-1,100},{0.1,100},{0.1,71.4}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
end BuildingRCZ6WithETS;
