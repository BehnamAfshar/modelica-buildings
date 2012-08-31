within Buildings.Fluid.HeatExchangers.DXCoils.Data.PerformanceCurves;
record Curve_II "Curve_II"
  extends Buildings.Fluid.HeatExchangers.DXCoils.Data.PerformanceCurves.Generic(
    each capFunT={0.766956,0.0107756,-0.0000414703,0.00134961,-0.000261144,
        0.000457488},
    each capFunFF={0.8,0.2,0,0},
    each EIRFunT={0.297145,0.0430933,-0.000748766,0.00597727,0.000482112,-0.000956448},

    each EIRFunFF={1.1552,-0.1808,0.0256,0},
    each TConInRanCap={291.15,319.26111},
    each TWetBulInRanCap={285.92778,297.03889},
    each ffRanCap={0.5,1.5},
    each TConInRanEIR={291.15,319.26111},
    each TWetBulInRanEIR={285.92778,297.03889},
    each ffRanEIR={0.5,1.5});

  annotation (defaultComponentName="per", Documentation(info="<html>
This record has default performance curves coefficents with min-max range 
for cooling capacity and EIR curve-fits obtained from ExampleFiles of EnergyPlus 7.1
(DXCoilSystemAuto.idf). 
</html>",
revisions="<html>
<ul>
<li>
August 15, 2012 by Kaustubh Phalak:<br>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={
        Text(
          extent={{-95,53},{-12,-2}},
          lineColor={0,0,255},
          textString="capFunT"),
        Text(
          extent={{7,55},{90,0}},
          lineColor={0,0,255},
          textString="%capFunT"),
        Text(
          extent={{-105,-9},{-48,-48}},
          lineColor={0,0,255},
          textString="capFunFF"),
        Text(
          extent={{2,-16},{94,-38}},
          lineColor={0,0,255},
          textString="%capFunFF"),
        Text(
          extent={{-95,-49},{-12,-104}},
          lineColor={0,0,255},
          textString="EIRFunT"),
        Text(
          extent={{7,-53},{84,-94}},
          lineColor={0,0,255},
          textString="%EIRFunT")}));
end Curve_II;
