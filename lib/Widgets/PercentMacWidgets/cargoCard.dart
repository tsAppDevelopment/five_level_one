import 'dart:collection';
import 'dart:typed_data';

import 'package:five_level_one/Backend/cont.dart';
import 'package:five_level_one/Backend/model.dart';
import 'package:five_level_one/Widgets/PercentMacWidgets/CargoUI.dart';
import 'package:five_level_one/Widgets/PercentMacWidgets/tanks.dart';
import 'package:five_level_one/Widgets/UIWidgets/Cards.dart';
import 'package:five_level_one/Widgets/UIWidgets/Input.dart';
import 'package:five_level_one/Widgets/UIWidgets/Rows.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CargoCard extends StatefulWidget {
  Aircraft air;
  Config selected;
  int configSpinIdx;
  var configIndexes = List<int>();
  var cargo = HashMap<int,Widget>();
  CargoCard(this.air);
  @override
  _CargoCardState createState() => _CargoCardState();
}

class _CargoCardState extends State<CargoCard> {
  @override
  initState() {
    this.widget.configSpinIdx=0;
    this.widget.selected = this.widget.air.configs[0];
    super.initState();
  }

  //implemt button within cargo ui for this method
  void removeCargoID(int id){
    this.widget.cargo.remove(id);
    setState((){});
  }

  getWidgetForSpinner() {
    List<Widget> list = [];
    for (int i = 0; i < this.widget.air.configs.length; i++) {
      list.add(
          Text(
          this.widget.air.configs[i].name,
          style: TextStyle(color: Colors.white70, fontSize: 18),
          ));
    }
    return list;
  }

  change(int i) {
    this.widget.configSpinIdx=i;
    this.widget.selected = this.widget.air.configs[i];

    //rebuild tree to update config button text
    setState(() {});
  }

  addConfig(){
    print('Updating '+ this.widget.selected.name + ' to contain: ');
    removeConfig();
    for(NameWeightFS configCargo in this.widget.selected.nwfList){
      this.widget.cargo[configCargo.id] = CargoUI(
        this.widget.air.fs0,
        this.widget.air.fs1,
        this.widget.air.weight1,
        this.widget.air.simplemom,
        nwf: configCargo,
      );
      this.widget.configIndexes.add(configCargo.id);
      
    }
    setState(() {
    });
  }

  removeConfig(){
    for(int idx in this.widget.configIndexes){
      try{this.widget.cargo.removeWhere((key, value) => key == idx);}catch(Exception){}
    }
    this.widget.configIndexes.clear();
    setState(() {
      
    });
  }

  List<Widget> getCargo(){
    var ret = List<Widget>();
    this.widget.cargo.forEach((key, value) {ret.add(value);});
    return ret;
  }

  Widget build(BuildContext context) {
    return CardAllwaysOpen(
        'Cargo',
        Column(children: <Widget>[
          Row2(
              Text('Select Config'),

              CustomButton(
        this.widget.selected.name,
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return Container(
                height: 200,
                color: Colors.black,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                      height: 200,
                      child:
                      CupertinoPicker(
                        scrollController: FixedExtentScrollController(initialItem: this.widget.configSpinIdx),
                        children: getWidgetForSpinner(),
                        onSelectedItemChanged: (int i)=>{change(i)},
                        itemExtent: 35,
                      )
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      )),


                  Row2(
                    CustomButton('Update Config', onPressed: ()=>{addConfig()} ),
                    CustomButton('Remove All', onPressed: ()=>{removeConfig()},)
                  ),
                  Column(
                    
                    children: getCargo()
                  )



        ]));
  }
}