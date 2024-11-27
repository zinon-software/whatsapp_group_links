import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkati/core/widgets/alert_widget.dart';
import 'package:linkati/core/widgets/custom_text_field.dart';

import '../../../../config/app_injector.dart';
import '../../../../core/api/app_collections.dart';
import '../../../../core/widgets/custom_button_widget.dart';
import '../cubit/links_cubit.dart';

class BannedWordsScreen extends StatelessWidget {
  const BannedWordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LinksCubit linksCubit = context.read<LinksCubit>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("كلمات محظورة"),
      ),
      body: BlocListener<LinksCubit, LinksState>(
        bloc: linksCubit,
        listenWhen: (previous, current) =>
            current is ManageLinkLoadingState ||
            current is ManageLinkErrorState ||
            current is ManageLinkSuccessState,
        listener: (context, state) {
          if (state is ManageLinkErrorState) {
            AppAlert.showAlert(context, subTitle: state.message);
          }
          if (state is ManageLinkLoadingState) {
            AppAlert.loading(context);
          }
          if (state is ManageLinkSuccessState) {
            AppAlert.showAlert(
              context,
              subTitle: state.message,
              icon: Icons.check,
              iconColor: Colors.green,
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: FirestoreQueryBuilder<String>(
            pageSize: 20,
            query: instance<AppCollections>().bannedWords.withConverter<String>(
                  fromFirestore: (snapshot, _) =>
                      snapshot.data()?['word'] as String,
                  toFirestore: (word, _) => {'word': word},
                ),
            builder: (context, snapshot, _) {
              if (snapshot.isFetching) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (!snapshot.hasData || snapshot.docs.isEmpty) {
                return const Center(
                  child: Text('No social media links available.'),
                );
              }

              return ListView.builder(
                itemCount: snapshot.docs.length,
                itemBuilder: (context, index) {
                  if (snapshot.hasMore && index + 1 == snapshot.docs.length) {
                    // Tell FirestoreQueryBuilder to try to obtain more items.
                    // It is safe to call this function from within the build method.
                    snapshot.fetchMore();
                  }
                  final doc = snapshot.docs[index];
                  return InkWell(
                    onTap: () {
                      AppAlert.showAlert(
                        context,
                        subTitle: "حذف ${doc.data()}",
                        onConfirm: () {
                          linksCubit.deleteBannedWordEvent(doc.data());
                        },
                      );
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          doc.data(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  );
                },
              );

              // return Wrap(
              //   children: snapshot.docs
              //       .map(
              //         (doc) => ,
              //       )
              //       .toList(),
              // );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          AppAlert.showAlertWidget(
            context,
            child: AddBannedWordsView(linksCubit: linksCubit),
          );
        },
      ),
    );
  }
}

class AddBannedWordsView extends StatefulWidget {
  const AddBannedWordsView({super.key, required this.linksCubit});
  final LinksCubit linksCubit;

  @override
  State<AddBannedWordsView> createState() => _AddBannedWordsViewState();
}

class _AddBannedWordsViewState extends State<AddBannedWordsView> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _wordController;

  @override
  void initState() {
    super.initState();
    _wordController = TextEditingController();
    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _wordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: BlocListener<LinksCubit, LinksState>(
        bloc: widget.linksCubit,
        listenWhen: (previous, current) =>
            current is CreateBannedWordLoadingState ||
            current is CreateBannedWordErrorState ||
            current is CreateBannedWordSuccessState,
        listener: (context, state) {
          if (state is CreateBannedWordErrorState) {
            AppAlert.showAlert(context, subTitle: state.message);
          }
          if (state is CreateBannedWordLoadingState) {
            AppAlert.loading(context);
          }
          if (state is CreateBannedWordSuccessState) {
            AppAlert.showAlert(
              context,
              subTitle: state.message,
              icon: Icons.check,
              iconColor: Colors.green,
            ).then(
              (value) {
                _wordController.clear();
              },
            );
          }
        },
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("اضافة كلمات محظورة"),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _wordController,
                labelText: 'كلمة',
                validator: (value) => value!.isEmpty ? 'مطلوب' : null,
              ),
              const SizedBox(height: 20),
              CustomButtonWidget(
                label: 'اضافة',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    widget.linksCubit
                        .createBannedWordEvent(_wordController.text);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
