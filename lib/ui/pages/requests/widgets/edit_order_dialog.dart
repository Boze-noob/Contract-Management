import 'package:contract_management/_all.dart';
import 'package:flutter/material.dart';

class EditOrderDialog extends StatefulWidget {
  final OrderModel orderModel;
  final void Function() orderEdited;

  EditOrderDialog({
    Key? key,
    required this.orderModel,
    required this.orderEdited,
  }) : super(key: key);

  @override
  State<EditOrderDialog> createState() => _EditOrderDialogState();
}

class _EditOrderDialogState extends State<EditOrderDialog> {
  late List<int> selectedContractItemsIndex;
  late PaymentType selectedPaymentTypeValue;

  @override
  void initState() {
    //PaymentType getValue static method doesn't work properly below, idk exactly why?
    selectedPaymentTypeValue = PaymentType.values[widget.orderModel.paymentType.index];
    selectedContractItemsIndex = ContractItemsType.getIndexValueList(widget.orderModel.contractItems);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return BlocProvider(
        create: (context) => OrderBloc(orderRepo: context.serviceProvider.orderRepo)..add(OrderInitEvent(orderModel: widget.orderModel)),
        child: BlocBuilder<OrderBloc, OrderState>(
          builder: (context, orderState) {
            print('Payment value isss ----------------' + orderState.orderModel.paymentType.translate());
            if (orderState.status == OrderStateStatus.loading)
              return Center(
                child: Loader(
                  width: 100,
                  height: 100,
                  color: active,
                ),
              );
            return Builder(
              builder: (context) {
                return CustomDialog(
                  buttonText: 'Submit',
                  onButtonPressed: () {
                    context.orderBloc.add(OrderSubmitUpdateEvent());
                    //This should be done via listener when edit is successful
                    widget.orderEdited();
                  },
                  child: Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: CustomText(
                              text: 'Edit order',
                              weight: FontWeight.bold,
                              size: context.textSizeXL,
                              color: Colors.black,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          TextFormField(
                            initialValue: orderState.orderModel.senderName.value,
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: 'Enter sender name',
                            ),
                            onChanged: (text) => context.orderBloc.add(OrderUpdateEvent(orderModel: orderState.orderModel.copyWith(senderName: text))),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            initialValue: orderState.orderModel.receiverName.value,
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: 'Enter receiver name',
                            ),
                            onChanged: (text) => context.orderBloc.add(OrderUpdateEvent(orderModel: orderState.orderModel.copyWith(receiverName: text))),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            initialValue: orderState.orderModel.orderLocation.value,
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: 'Enter order location',
                            ),
                            onChanged: (text) => context.orderBloc.add(OrderUpdateEvent(orderModel: orderState.orderModel.copyWith(orderLocation: text))),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              CustomText(
                                text: 'Pick payment option',
                                color: Colors.black,
                                size: context.textSizeM,
                                weight: FontWeight.bold,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              DropdownButton(
                                value: selectedPaymentTypeValue,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: PaymentType.values.map((PaymentType items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text(items.translate()),
                                  );
                                }).toList(),
                                onChanged: (PaymentType? newValue) {
                                  setState(() {
                                    context.orderBloc.add(OrderUpdateEvent(orderModel: orderState.orderModel.copyWith(paymentType: newValue)));
                                    selectedPaymentTypeValue = newValue!;
                                  });
                                },
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Divider(
                            color: Colors.black12.withOpacity(0.4),
                          ),
                          CustomText(text: 'Contract items:'),
                          SizedBox(
                            height: 5,
                          ),
                          ListView.builder(
                              itemCount: ContractItemsType.values.length,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (selectedContractItemsIndex.contains(index)) {
                                        selectedContractItemsIndex = List.from(selectedContractItemsIndex)..remove(index);
                                      } else {
                                        selectedContractItemsIndex = List.from(selectedContractItemsIndex)..add(index);
                                      }
                                      context.orderBloc.add(OrderUpdateEvent(orderModel: orderState.orderModel.copyWith(contractItems: selectedContractItemsIndex.map((index) => ContractItemsType.getValue(index)).toList())));
                                    });
                                  },
                                  child: ListTile(
                                    title: Text(ContractItemsType.getValue(index).translate()),
                                    tileColor: Colors.green.withOpacity(0.4),
                                    selected: selectedContractItemsIndex.contains(index) ? true : false,
                                  ),
                                );
                              }),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      );
    });
  }
}
