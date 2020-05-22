within Buildings.Applications.DHC.Networks;
model Connection1stGen4PipeSections
  "Connection for a first generation DHC network with 4 pipe sections"
  extends
    Buildings.Applications.DHC.Networks.BaseClasses.PartialConnection2Pipe2Medium(
    redeclare model Model_pip_aDisSup = Buildings.Fluid.FixedResistances.Pipe (
      thicknessIns=thicknessInsSup,
      lambdaIns=lambdaIns,
      length=lengthDisSup),
    redeclare model Model_pip_bDisRet = Buildings.Fluid.FixedResistances.Pipe (
      thicknessIns=thicknessInsRet,
      lambdaIns=lambdaIns,
      length=lengthDisRet),
    redeclare final model Model_pip_bDisSup =
        Buildings.Fluid.FixedResistances.LosslessPipe,
    redeclare final model Model_pip_aDisRet =
        Buildings.Fluid.FixedResistances.LosslessPipe,
    redeclare model Model_pipConSup = Buildings.Fluid.FixedResistances.Pipe (
      thicknessIns=thicknessInsSup,
      lambdaIns=lambdaIns,
      length=lengthConSup),
    redeclare model Model_pipConRet = Buildings.Fluid.FixedResistances.Pipe (
      thicknessIns=thicknessInsRet,
      lambdaIns=lambdaIns,
      length=lengthConRet));

  parameter Integer nSeg "Number of volume segments";
  parameter Modelica.SIunits.Length thicknessInsSup
    "Thickness of insulation on supply pipes";
  parameter Modelica.SIunits.Length thicknessInsRet
    "Thickness of insulation on return pipes";
  parameter Modelica.SIunits.ThermalConductivity lambdaIns
    "Heat conductivity of insulation";

  parameter Modelica.SIunits.Length lengthDisSup "Length of district supply pipe";
  parameter Modelica.SIunits.Length lengthDisRet "Length of district return pipe";
  parameter Modelica.SIunits.Length lengthConSup "Length of connection supply pipe";
  parameter Modelica.SIunits.Length lengthConRet "Length of connection return pipe";

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-25,8},{25,-8}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          origin={0,45},
          rotation=90),
        Rectangle(
          extent={{-25.5,7.5},{25.5,-7.5}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          origin={59.5,45.5},
          rotation=90)}),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Connection1stGen4PipeSections;
