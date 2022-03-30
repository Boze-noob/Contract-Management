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
    return BlocProvider(
      create: (context) => RequestsBloc(request: context.serviceProvider.requestRepo)..add(RequestsLoadEvent()),
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
                  child: BlocBuilder<RequestsBloc, RequestsState>(
                    builder: (context, state) {
                      return BlocBuilder<CurrentUserBloc, CurrentUserState>(
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
                                  return CreateOrderWidget(
                                    requestState: state,
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
                                  return RequestsDataTableWidget(
                                    firstColumnName: 'Display name',
                                    secondColumnName: 'Email',
                                    thirdColumnName: 'Location',
                                    fourthColumnName: 'Date time',
                                    fifthColumnName: '',
                                    isEmpty: false,
                                    actionBtnTxt: 'Send order',
                                    firstColumnValue: state.clientRequestModel.map((clientModel) => clientModel.displayName).toList(),
                                    secondColumnValue: state.clientRequestModel.map((clientModel) => clientModel.email).toList(),
                                    thirdColumnValue: state.clientRequestModel.map((clientModel) => clientModel.location).toList(),
                                    fourthColumnValue: state.clientRequestModel.map((clientModel) => clientModel.createdDateTime.toLocal().toString()).toList(),
                                    onTap: () => null,
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
                                if (currentUserState.userModel!.role == RoleType.announcementEmployer.translate() || currentUserState.userModel!.role == RoleType.announcementVerifyEmployer.translate())
                                  return RequestsDataTableWidget(
                                    firstColumnName: 'Display name',
                                    secondColumnName: 'Email',
                                    thirdColumnName: 'Location',
                                    fourthColumnName: 'Date time',
                                    fifthColumnName: '',
                                    isEmpty: false,
                                    actionBtnTxt: 'Send announcement',
                                    firstColumnValue: state.clientRequestModel.map((clientModel) => clientModel.displayName).toList(),
                                    secondColumnValue: state.clientRequestModel.map((clientModel) => clientModel.email).toList(),
                                    thirdColumnValue: state.clientRequestModel.map((clientModel) => clientModel.location).toList(),
                                    fourthColumnValue: state.clientRequestModel.map((clientModel) => clientModel.createdDateTime.toLocal().toString()).toList(),
                                    onTap: () => null,
                                  );
                                else
                                  return _NoAccessWidget();
                              }()),
                            ],
                          );
                        },
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
