part of 'links_cubit.dart';

abstract class LinksState extends Equatable {
  const LinksState();

  @override
  List<Object> get props => [];
}

class LinksInitialState extends LinksState {}

class LinksLoadingState extends LinksState {}

class LinksErrorState extends LinksState {
  final String message; // error message

  const LinksErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class LinksSuccessState extends LinksState {
  final List<LinkModel> links; // list of links

  const LinksSuccessState(this.links);  

  @override
  List<Object> get props => [links];
}

class CreateLinkLoadingState extends LinksState {}

class CreateLinkErrorState extends LinksState {
  final String message; // error message

  const CreateLinkErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class CreateLinkSuccessState extends LinksState {}