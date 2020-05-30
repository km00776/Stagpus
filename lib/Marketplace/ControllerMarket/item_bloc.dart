import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stagpus/Marketplace/ControllerMarket/MarketController.dart';
import 'package:stagpus/Marketplace/ControllerMarket/item_state.dart';
import 'package:stagpus/Marketplace/backgrounds/item_event.dart';


class ItemBloc extends Bloc<SelectedItemEvent, SelectedItemState> {
  @override
  // TODO: implement initialState
  SelectedItemState get initialState => SelectedItemState(controllers, 0);

  @override
  Stream <SelectedItemState> mapEventToState(event) async*{
    List<Item> items;
    print(items);
    switch(event.index) {
      case 0:
        items = controllers;
        break;
      case 1:
        items = macs;
        break;
      case 2:
        items = mice;
        break;
    }
    yield SelectedItemState(items, event.index);

  }








  
}