abstract class LegalDocsEvent {}

class LoadQuoEvent extends LegalDocsEvent {}

class UpdateLegalDocsEvent extends LegalDocsEvent {
  final int? id;
  final int? priceForStatusQuo;
  final int? statusQuoId;
  final int? useRightTypeId;

  UpdateLegalDocsEvent({
    this.id,
    this.priceForStatusQuo,
    this.statusQuoId,
    this.useRightTypeId,
  });
}
