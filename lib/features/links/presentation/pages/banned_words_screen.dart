import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkati/features/links/presentation/cubit/links_cubit.dart';

import '../../../../core/widgets/alert_widget.dart';

class BannedWordsScreen extends StatelessWidget {
  const BannedWordsScreen({super.key, required this.words});

  final List<String> words;

  @override
  Widget build(BuildContext context) {
    final LinksCubit linksCubit = context.read<LinksCubit>();
    return Scaffold(
      appBar: AppBar(title: const Text("الابلاغ عن الكلمات المحظورة")),
      body: BlocListener<LinksCubit, LinksState>(
        bloc: linksCubit,
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
              subTitle: "تمت أضافة الكلمة بنجاح",
              icon: Icons.check,
              iconColor: Colors.green,
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: ListView.builder(
            itemCount: words.length,
            itemBuilder: (context, index) {
              if (words[index] == "") {
                return const SizedBox();
              }
              return Column(
                children: [
                  if (index == 0) Text("الابلاغ عن الكلمات المحظورة"),
                  if (index == words.length - 1) Text("الابلاغ عن الرابط"),
                  InkWell(
                    onTap: () async {
                      linksCubit.createBannedWord(words[index].trim());
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Center(
                          child: Text(words[index]),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
