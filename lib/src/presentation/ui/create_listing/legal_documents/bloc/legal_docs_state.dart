abstract class BaseLegalDocsState {}

class LegalDocsStateInitial extends BaseLegalDocsState {}

class LegalDocsStateLoading extends BaseLegalDocsState {}

class LegalDocsStateSuccess extends BaseLegalDocsState {
  final bool navigateScreen;

  LegalDocsStateSuccess(this.navigateScreen);
}
