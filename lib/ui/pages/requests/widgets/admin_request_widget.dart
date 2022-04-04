import 'dart:ui';
import 'package:contract_management/_all.dart';
import 'package:flutter/material.dart';

class AdminRequestWidget extends StatefulWidget {
  const AdminRequestWidget({Key? key}) : super(key: key);

  @override
  _AdminRequestWidgetState createState() => _AdminRequestWidgetState();
}

class _AdminRequestWidgetState extends State<AdminRequestWidget> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => RequestsBloc(request: context.serviceProvider.requestRepo)..add(RequestsLoadEvent()),
        ),
        BlocProvider(
          create: (context) => OrderBloc(orderRepo: context.serviceProvider.orderRepo)..add(OrderGetEvent()),
        ),
      ],
      child: BlocListener<RequestsBloc, RequestsState>(
        listener: (context, state) {
          if (state.status == RequestsStateStatus.error) showInfoMessage(state.errorMessage ?? 'Error happen', context);
        },
        child: Container(
          child: Column(
            children: [
              Obx(
                () => Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: ResponsiveWidget.isSmallScreen(context) ? 56 : 6),
                      child: CustomText(
                        text: menuController.activeItem.value,
                        size: 24,
                        weight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
                    PointerDeviceKind.touch,
                    PointerDeviceKind.mouse,
                  }),
                  child: BlocBuilder<CurrentUserBloc, CurrentUserState>(
                    builder: (context, currentUserState) {
                      return ListView(
                        children: [
                          CustomText(
                            text: 'Clients requests list',
                            color: Colors.black,
                            weight: FontWeight.bold,
                            size: context.textSizeXL,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          (() {
                            if (currentUserState.userModel!.role == RoleType.admin.translate() || currentUserState.userModel!.role == RoleType.orderEmployer.translate())
                              return BlocBuilder<RequestsBloc, RequestsState>(
                                builder: (context, requestsState) {
                                  if (requestsState.clientRequestModel.isEmpty)
                                    return Center(
                                      child: Container(
                                        child: CustomText(
                                          text: 'No data to display',
                                          textAlign: TextAlign.center,
                                          size: context.textSizeL,
                                          color: Colors.black,
                                        ),
                                      ),
                                    );
                                  else
                                    return CreateOrderWidget(
                                      requestState: requestsState,
                                      //not good practice but context of CreateOrderWidget is not in scope of adminRequest in widget tree(not its parent cuz Custom dialog I think), so I use callback function
                                      onCreate: () => context.orderBloc.add(OrderGetEvent()),
                                    );
                                },
                              );
                            else
                              return _NoAccessWidget();
                          }()),
                          SizedBox(
                            height: 20,
                          ),
                          CustomText(
                            text: 'Order list',
                            color: Colors.black,
                            weight: FontWeight.bold,
                            size: context.textSizeXL,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          (() {
                            if (currentUserState.userModel!.role != RoleType.announcementVerifyEmployer.translate())
                              return BlocListener<OrderBloc, OrderState>(
                                listener: (context, state) {
                                  if (state.status == OrderStateStatus.deleteSuccessful) context.orderBloc.add(OrderGetEvent());
                                },
                                child: BlocBuilder<OrderBloc, OrderState>(
                                  builder: (context, orderState) {
                                    return OrderDataTableWidget(
                                      firstColumnName: 'Receiver name',
                                      secondColumnName: 'Created date time',
                                      thirdColumnName: 'Sent date time',
                                      fourthColumnName: 'Order status type',
                                      fifthColumnName: 'Employer name',
                                      sixthColumnName: '',
                                      isEmpty: orderState.orderModels.isEmpty ? true : false,
                                      viewBtnTxt: 'View',
                                      editBtnTxt: 'Edit',
                                      deleteBtnTxt: 'Delete',
                                      viewBtnOnTap: (index) => showDialog(
                                        context: context,
                                        builder: (context) => ViewOrderDialog(
                                          orderModel: orderState.orderModels[index],
                                        ),
                                      ),
                                      editBtnOnTap: (index) => showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (dialogContext) => EditOrderDialog(
                                          orderModel: orderState.orderModels[index],
                                          orderEdited: () => context.orderBloc.add(OrderGetEvent()),
                                        ),
                                      ),
                                      deleteBtnOnTap: (index) => context.orderBloc.add(OrderDeleteEvent(orderId: orderState.orderModels[index].id)),
                                      firstColumnValue: orderState.orderModels.map((orderModel) => orderModel.receiverName ?? 'Not selected yet').toList(),
                                      secondColumnValue: orderState.orderModels.map((orderModel) => orderModel.createdDateTime.formatDDMMYY().toString()).toList(),
                                      thirdColumnValue: orderState.orderModels.map((orderModel) => orderModel.sentDateTime != null ? orderModel.sentDateTime!.formatDDMMYY().toString() : 'Not defined').toList(),
                                      fourthColumnValue: orderState.orderModels.map((orderModel) => orderModel.orderStatusType.translate()).toList(),
                                      fifthColumnValue: orderState.orderModels.map((orderModel) => orderModel.employerName).toList(),
                                    );
                                  },
                                ),
                              );
                            else
                              return _NoAccessWidget();
                          }()),
                          SizedBox(
                            height: 20,
                          ),
                          CustomText(
                            text: 'Announcement list',
                            color: Colors.black,
                            weight: FontWeight.bold,
                            size: context.textSizeXL,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          (() {
                            //TODO add when bloc is created
                            //   if (currentUserState.userModel!.role == RoleType.announcementEmployer.translate() || currentUserState.userModel!.role == RoleType.announcementVerifyEmployer.translate())
                            //     return RequestsDataTableWidget(
                            //       firstColumnName: 'Display name',
                            //       secondColumnName: 'Email',
                            //       thirdColumnName: 'Location',
                            //       fourthColumnName: 'Date time',
                            //       fifthColumnName: '',
                            //       isEmpty: false,
                            //       actionBtnTxt: 'Send announcement',
                            //       firstColumnValue: state.clientRequestModel.map((clientModel) => clientModel.displayName).toList(),
                            //       secondColumnValue: state.clientRequestModel.map((clientModel) => clientModel.email).toList(),
                            //       thirdColumnValue: state.clientRequestModel.map((clientModel) => clientModel.location).toList(),
                            //       fourthColumnValue: state.clientRequestModel.map((clientModel) => clientModel.createdDateTime.toLocal().toString()).toList(),
                            //       onTap: () => null,
                            //     );
                            //   else
                            return _NoAccessWidget();
                          }()),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NoAccessWidget extends StatelessWidget {
  const _NoAccessWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 600,
      height: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: active.withOpacity(.4), width: .5),
        boxShadow: [BoxShadow(offset: Offset(0, 6), color: lightGrey.withOpacity(.1), blurRadius: 12)],
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 30),
      child: Center(
        child: CustomText(
          text: 'You do not have access to this section',
          size: context.textSizeXL,
          color: Colors.black,
          textAlign: TextAlign.center,
          weight: FontWeight.bold,
        ),
      ),
    );
  }
}
