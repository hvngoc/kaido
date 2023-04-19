import 'package:json_annotation/json_annotation.dart';

part 'paging_response.g.dart';

@JsonSerializable(createToJson: false, checked: true, genericArgumentFactories: true)
class PagingResponse<T> {
  List<T>? content;
  bool? empty;
  bool? first;
  bool? last;
  int? number;
  int? numberOfElements;
  Pageable? pageable;
  int? size;
  Sort? sort;
  int? totalElements;
  int? totalPages;

  PagingResponse(this.content, this.empty, this.first, this.last,this.number, this.numberOfElements,
      this.pageable, this.size, this.sort, this.totalElements, this.totalPages);

  factory PagingResponse.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT) => _$PagingResponseFromJson<T>(json, fromJsonT);

}

@JsonSerializable(createToJson: false, checked: true)
class Sort {
  bool? empty;
  bool? sorted;
  bool? unsorted;

  Sort(this.empty, this.sorted, this.unsorted);

  factory Sort.fromJson(Map<String, dynamic> json) => _$SortFromJson(json);

}

@JsonSerializable(createToJson: false, checked: true)
class Pageable {
  int? offset;
  int? pageNumber;
  int? pageSize;
  bool? paged;
  Sort? sort;
  bool? unpaged;

  Pageable(this.offset, this.pageNumber, this.pageSize, this.paged, this.sort, this.unpaged);

  factory Pageable.fromJson(Map<String, dynamic> json) => _$PageableFromJson(json);

}
