import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkati/config/app_injector.dart';
import 'package:linkati/core/extensions/date_format_extension.dart';

import '../../../../core/api/app_collections.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/widgets/alert_widget.dart';
import '../../data/models/link_model.dart';
import '../cubit/links_cubit.dart';

class LinksDashboardScreen extends StatelessWidget {
  const LinksDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LinksCubit linksCubit = context.read<LinksCubit>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("لوحة التحكم"),
      ),
      body: BlocListener<LinksCubit, LinksState>(
        bloc: linksCubit,
        listener: (context, state) {
          if (state is ManageLinkErrorState) {
            AppAlert.customDialog(context, subTitle: state.message);
          }
          if (state is ManageLinkLoadingState) {
            AppAlert.loading(context);
          }
          if (state is ManageLinkSuccessState) {
            AppAlert.customDialog(
              context,
              subTitle: state.message,
              icon: Icons.check,
              iconColor: Colors.green,
            );
          }
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),
              Title(
                color: Colors.black,
                child: const Text("قائمة الكلمات المحظورة"),
              ),
              StreamBuilder(
                stream: instance<AppCollections>().bannedWords.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text('No banned words available.'),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                      children: snapshot.data!.docs
                          .map(
                            (doc) => InkWell(
                              onTap: () {
                                linksCubit.deleteBannedWord(doc['word']);
                              },
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    doc['word'],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  );
                },
              ),
              SizedBox(height: 10),
              Title(color: Colors.black, child: const Text("قائمة المجموعات")),
              StreamBuilder<QuerySnapshot>(
                stream: instance<AppCollections>().links.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text('No social media links available.'),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var linkData = snapshot.data!.docs[index].data()
                            as Map<String, dynamic>;

                        var link = LinkModel.fromJson(linkData);

                        return InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              AppRoutes.linkDetailsRoute,
                              arguments: {'link': link},
                            );
                          },
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text((index + 1).toString()),
                                  ),
                                  Expanded(
                                    child: ListTile(
                                      title: Text(
                                        link.title,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      subtitle: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          if (link.isActive == true)
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius:
                                                    BorderRadius.circular(18),
                                              ),
                                              padding: const EdgeInsets.all(5),
                                              child: const Icon(
                                                CupertinoIcons
                                                    .checkmark_seal_fill,
                                                color: Colors.green,
                                              ),
                                            ),
                                          Expanded(
                                            child: Text(
                                              link.createDt
                                                  .formatTimeAgoString(),
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 5,
                                            ),
                                            child: Text(
                                              link.type,
                                              style:
                                                  const TextStyle(fontSize: 10),
                                            ),
                                          ),
                                        ],
                                      ),
                                      trailing: TextButton(
                                          onPressed: () {
                                            linksCubit.changeLinkActive(
                                              link.id,
                                              !link.isActive,
                                            );
                                          },
                                          child: Text('${link.isActive}')),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
